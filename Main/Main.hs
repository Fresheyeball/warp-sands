{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Data.ByteString.Internal       as B  (ByteString)
import qualified Data.ByteString.Lazy.Internal  as LB (ByteString, packChars)
import           Data.Monoid                    ((<>))
import           Network.HTTP.Types             (status200)
import           Network.HTTP.Types.Header      (HeaderName (), hContentType)
import           Network.HTTP.Types.Method      (StdMethod (..), parseMethod)
import           Network.Wai                    (Application (), Response (),
                                                 isSecure, pathInfo,
                                                 requestMethod, responseLBS)
import           Network.Wai.Application.Static (defaultWebAppSettings,
                                                 staticApp)
import           Network.Wai.Handler.Warp       (run)

import           Config                         (port)
import           User.User

main :: IO ()
main = do
  putStrLn $ "We are listening on port " ++ show port ++ "."
  run port app

json, text :: (HeaderName, B.ByteString)
json = (hContentType, "application/json")
text = (hContentType, "text/plain")

app :: Application
app req res | True         = handleSecure
            | isSecure req = handleSecure
            | otherwise    = insecureError

  where

  handleSecure = case parseMethod $ requestMethod req of
    Right GET  -> get req res
    Right _    -> p "METHOD not found"
    Left  x    -> p $ "Uh something went wrong" <> LB.packChars (show x)

  insecureError = p "Your connection is not secure"

  p             = res . plain

get :: Application
get req res = case pathInfo req of

  ["login"]     -> res login
  ["signup"]    -> createAccount' >>= res . responseLBS status200 [json]
  ("static":xs) -> static req{ pathInfo = xs } res
  _             -> res fourOhFour

static :: Application
static = staticApp . defaultWebAppSettings $ "/static"

plain :: LB.ByteString -> Response
plain = responseLBS status200 [text]

fourOhFour, login :: Response
fourOhFour = plain "Error: 404"
login      = plain "Login"

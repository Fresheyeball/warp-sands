{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Data.ByteString.Lazy.Internal  (ByteString)
import           Network.HTTP.Types             (status200)
import           Network.HTTP.Types.Header      (hContentType)
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

app :: Application
app req res | isSecure req = handleSecure
            | otherwise    = insecureError
  where
  handleSecure = case parseMethod $ requestMethod req of
    Right GET  -> get req res
    Right _    -> p "Method not found"
    Left  _    -> p "Uh something went wrong"
  insecureError = p "Your connection is not secure"
  p = res . plain

get :: Application
get req res = case pathInfo req of
  ["login"]     -> res login
  ["signup"]    -> createAccount >>= res . plain
  ("static":xs) -> static req{ pathInfo = xs } res
  _             -> res fourOhFour

static :: Application
static = staticApp . defaultWebAppSettings $ "/static"

plain :: ByteString -> Response
plain = responseLBS status200 [(hContentType, "plain/text")]

fourOhFour, login :: Response
fourOhFour = plain "Error: 404"
login      = plain "Login"

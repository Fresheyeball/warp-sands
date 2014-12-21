{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.ByteString.Lazy.Internal
import Network.Wai
-- import Network.Wai.Handler.Warp
import Network.HTTP.Types (status200)
import Network.HTTP.Types.Header (hContentType)
import Config (port)

main :: IO ()
main = print port

app :: Application
app req res = case pathInfo req of
  ["login"] -> res login
  _ -> res fourOhFour

plain :: ByteString -> Response
plain = responseLBS status200 [(hContentType, "plain/text")]

fourOhFour :: Response
fourOhFour = plain "Error: 404"

login :: Response
login = plain "Login"

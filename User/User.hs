{-# LANGUAGE OverloadedStrings #-}
module User.User where

import           Control.Lens
import           Data.Aeson
import           Data.ByteString.Lazy.Internal (ByteString)
import           Network.Wreq

createAccount :: IO ByteString
createAccount = do
  r <- get "http://www.google.com/"
  return $ r ^. responseBody

{-# LANGUAGE OverloadedStrings #-}
module User.User where

import           Control.Lens
import           Data.Aeson
import           Data.ByteString.Lazy.Internal (ByteString)
import           Network.Wreq

import Google.Requests.Types

dummy :: User
dummy = User {
  name = HumanName { givenName = "GreatBig", familyName = "Dummy" },
  primaryEmail = "f@g.c",
  password = "12345",
  organizations = [Organization { title = "Officer", department = "Drugs" }],
  suspended = False
}

-- {
--   "name":{
--     "givenName":"GreatBig",
--     "familyName":"Dummy"
--   },
--   "primaryEmail":"f@g.c",
--   "password":"12345",
--   "organizations":[
--     {
--       "department":"Drugs",
--       "title":"Officer"
--     }
--   ],
--   "suspended":false
-- }

createAccount :: IO ByteString
createAccount = do
  r <- get "http://www.google.com/"
  return $ r ^. responseBody

createAccount' :: IO ByteString
createAccount' = return $ encode dummy

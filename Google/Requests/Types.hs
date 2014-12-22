{-# LANGUAGE OverloadedStrings #-}
module Google.Requests.Types where

-- import           Control.Lens
import           Control.Applicative
import           Control.Monad
import           Data.Aeson
import           Data.Text
-- import           Data.ByteString.Lazy.Internal (ByteString)
-- import           Network.Wreq

data User = User {
  name          :: HumanName,
  primaryEmail  :: !Text,
  password      :: !Text,
  organizations :: [Organization],
  suspended     :: Bool
}

n, pe, p, os, s :: Text
n  = "name"
pe = "primaryEmail"
p  = "password"
os = "organizations"
s  = "suspended"

instance FromJSON User where
  parseJSON (Object v) =
    User <$> v .: n
         <*> v .: pe
         <*> v .: p
         <*> v .: os
         <*> v .: s
  parseJSON _ = mzero

instance ToJSON User where
  toJSON (User { name          = n'
               , primaryEmail  = pe'
               , password      = p'
               , organizations = os'
               , suspended     = s' }) =
    object [ n  .= n'
           , pe .= pe'
           , p  .= p'
           , os .= os'
           , s  .= s' ]

-- -- -- -- --

data HumanName = HumanName {
  givenName  :: !Text,
  familyName :: !Text
} deriving(Show)

gn, fn :: Text
gn = "givenName"
fn = "familyName"

instance FromJSON HumanName where
  parseJSON (Object v) =
    HumanName <$> v .: gn
              <*> v .: fn
  parseJSON _ = mzero

instance ToJSON HumanName where
  toJSON (HumanName { givenName = gn', familyName = fn' }) =
    object [ gn .= gn'
           , fn .= fn' ]

-- -- -- -- --

data Organization = Organization {
  title      :: !Text,
  department :: !Text
} deriving(Show)

ot, od :: Text
ot = "title"
od = "department"

instance FromJSON Organization where
  parseJSON (Object v) =
    Organization <$> v .: ot
                 <*> v .: od
  parseJSON _ = mzero

instance ToJSON Organization where
  toJSON (Organization { title = ot', department = od'}) =
    object [ ot .= ot'
           , od .= od' ]

api :: String
api = "https://www.googleapis.com/"

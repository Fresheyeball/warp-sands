module Google.Requests.Types where

-- import           Control.Lens
-- import           Data.Aeson
-- import           Data.ByteString.Lazy.Internal (ByteString)
-- import           Network.Wreq

data Role = Admin | Common

data User = User {
  name          :: HumanName,
  primaryEmail  :: String,
  password      :: String,
  organizations :: [Organization],
  suspended     :: Bool,
  role          :: Role
}

data HumanName = HumanName {
  givenName  :: String,
  familyName :: String
}

data Organization = Organization {
  title      :: String,
  department :: String
}

api :: String
api = "https://www.googleapis.com/"

module SignIn.Types exposing (..)

type alias Model = {user: User}

type alias User = {username: String, password: String}

type Msg = SignedIn

initialUser: User
initialUser = User "" ""

initialModel : Model
initialModel =
  Model initialUser
module SignIn.Types exposing (..)

type alias Model = {user: User}

type alias User = {email: String, password: String}

type alias UserAuth = {jwt: String, exp: Int}

type Msg = SignIn | SignedIn

initialUser: User
initialUser = User "" ""

initialUserAuth: UserAuth
initialUserAuth = UserAuth "" 0

initialModel : Model
initialModel =
  Model initialUser
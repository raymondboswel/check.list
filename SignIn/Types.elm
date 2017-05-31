module SignIn.Types exposing (..)
import Http exposing (..)

type alias Model = {user: User, email: String, password: String}

type alias User = {email: String, password: String}

type alias UserAuth = {user_id: Int, jwt: String, exp: Int}

type Msg =  SignIn |
            SignedIn (Result Http.Error UserAuth) |
            OnEmailInput String |
            OnPasswordInput String

initialUser: User
initialUser = User "" ""

initialUserAuth: UserAuth
initialUserAuth = UserAuth 0 "" 0

initialModel : Model
initialModel =
  Model initialUser "" ""
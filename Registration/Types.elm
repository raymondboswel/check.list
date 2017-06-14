module Registration.Types exposing (..)
import SignIn.Types exposing (UserAuth)
import Http exposing (..)

type alias Model = {user: User, email: String, password: String, repeatPassword: String, shouldDisplayPasswordModal: Bool}

type alias User = {email: String, password: String, repeatPassword: String}

type Msg =  Register |
            Registered (Result Http.Error UserAuth) |
            OnEmailInput String |
            OnPasswordInput String |
            OnPasswordRepeatInput String |
            AcknowledgeDialog

initialUser: User
initialUser = User "" "" ""

initialModel : Model
initialModel =
  Model initialUser "" "" "" False
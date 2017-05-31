module SignIn.State exposing (init, update)
import SignIn.Types exposing (..)
import SignIn.Rest exposing (..)


init : ( Model, Cmd Msg )
init =
  (Model initialUser "" "" , Cmd.none)

update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of
    OnEmailInput input ->
      ({model | email = input}, Cmd.none)
    OnPasswordInput input ->
      ({model | password = input}, Cmd.none)
    SignIn ->
      (model, SignIn.Rest.signIn model.email model.password)
    SignedIn userAuth ->
      (model, Cmd.none )
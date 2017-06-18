module Registration.State exposing (init, update)
import Registration.Types exposing (..)
import Registration.Rest exposing (..)


init : ( Model, Cmd Msg )
init =
  (Model initialUser "" "" "" False, Cmd.none)

update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of
    OnEmailInput input ->
      ({model | email = input}, Cmd.none)
    OnPasswordInput input ->
      ({model | password = input}, Cmd.none)
    Register ->
      if model.password == model.repeatPassword then
        (model, Registration.Rest.register model.email model.password)
      else
        ({model | shouldDisplayPasswordModal = True}, Cmd.none)
    Registered userAuth ->
      (model, Cmd.none)
    Registration.Types.OnPasswordRepeatInput repeatPassword ->
      ({model | repeatPassword = repeatPassword}, Cmd.none)
    AcknowledgeDialog ->
      ({model | shouldDisplayPasswordModal = False}, Cmd.none)
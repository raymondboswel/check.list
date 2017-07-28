module Registration.State exposing (init, update)
import Registration.Types exposing (..)
import Registration.Rest exposing (..)
import Models as RootModel exposing (Model)


init : ( Registration.Types.Model, Cmd Msg )
init =
  (Registration.Types.Model initialUser "" "" "" False, Cmd.none)

update : Msg -> Registration.Types.Model -> ( Registration.Types.Model, Cmd Msg )
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
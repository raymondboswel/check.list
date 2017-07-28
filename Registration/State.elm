module Registration.State exposing (init, update)
import Registration.Types exposing (..)
import Registration.Rest exposing (..)
import Models as RootModel exposing (Model)


init : ( Registration.Types.Model, Cmd Msg )
init =
  (Registration.Types.Model initialUser "" "" "" False, Cmd.none)

update : Msg -> RootModel.Model -> ( Registration.Types.Model, Cmd Msg )
update action model =
  case action of
    OnEmailInput input ->
      let newRegistrationModel = 
        model.registrationModel |> setEmail input 
      in
      (newRegistrationModel, Cmd.none)
    OnPasswordInput input ->
      let newRegistrationModel = 
        model.registrationModel |> setPassword input
      in
      (newRegistrationModel, Cmd.none)
    Register ->
      if model.registrationModel.password == model.registrationModel.repeatPassword then
        (model.registrationModel, Registration.Rest.register model.api model.registrationModel.email model.registrationModel.password)
      else
        let newRegistrationModel = 
          model.registrationModel |> setShouldDisplayPasswordModal True
        in
        (newRegistrationModel, Cmd.none)
    Registered userAuth ->
      (model.registrationModel, Cmd.none)
    Registration.Types.OnPasswordRepeatInput repeatPassword ->
      let newRegistrationModel = 
        model.registrationModel |> setRepeatPassword repeatPassword
      in
      (newRegistrationModel, Cmd.none)
    AcknowledgeDialog ->
      let newRegistrationModel = 
        model.registrationModel |> setShouldDisplayPasswordModal False
      in
      (newRegistrationModel, Cmd.none)

setRepeatPassword : String -> Registration.Types.Model -> Registration.Types.Model
setRepeatPassword repeatPassword model = 
  {model | repeatPassword = repeatPassword}

setEmail : String -> Registration.Types.Model -> Registration.Types.Model
setEmail email model = 
  {model | email = email}

setShouldDisplayPasswordModal : Bool -> Registration.Types.Model -> Registration.Types.Model
setShouldDisplayPasswordModal shouldDisplayPasswordModal model = 
  {model | shouldDisplayPasswordModal = shouldDisplayPasswordModal}

setPassword : String -> Registration.Types.Model -> Registration.Types.Model
setPassword password model = 
  {model | password = password}
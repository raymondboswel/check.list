module SignIn.State exposing (init, update)
import SignIn.Types exposing (..)
import SignIn.Rest exposing (..)
import Models exposing (..)

init : ( SignIn.Types.Model, Cmd Msg )
init =
  (SignIn.Types.Model initialUser "raymondboswel@gmail.com" "letmein" , Cmd.none)

update : Msg -> Models.Model -> ( SignIn.Types.Model, Cmd Msg )
update action model =
  case action of
    OnEmailInput input ->
    let signInModel = 
      model.signInModel
    in
      ({signInModel | email = input}, Cmd.none)
    OnPasswordInput input ->
    let signInModel = 
      model.signInModel
    in
      ({signInModel | password = input}, Cmd.none)
    SignIn ->
      let signInModel = 
        model.signInModel
      in
        (signInModel, SignIn.Rest.signIn model model.signInModel.email model.signInModel.password)
    SignedIn userAuth ->
      let signInModel = 
          model.signInModel
      in
      (signInModel, Cmd.none )
    GotoRegistration ->
      let signInModel = 
        model.signInModel
      in
        (signInModel, Cmd.none )

setEmail : String -> SignIn.Types.Model -> SignIn.Types.Model
setEmail email model =
  {model | email = email}
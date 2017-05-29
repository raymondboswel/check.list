module SignIn.State exposing (init, update)
import SignIn.Types exposing (..)
import SignIn.Rest exposing (..)


init : ( Model, Cmd Msg )
init =
  (Model initialUser , Cmd.none)

update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of
    SignIn ->
      let user = User "new User" ""
      in
      ({model | user = user}, SignIn.Rest.signIn user.email user.password)

    SignedIn userAuth ->
      (model, Cmd.map Msgs.OnUserAuth userAuth )
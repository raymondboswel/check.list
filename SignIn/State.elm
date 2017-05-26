module SignIn.State exposing (init, update)
import SignIn.Types exposing (..)


init : ( Model, Cmd Msg )
init =
  (Model initialUser , Cmd.none)

update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of
    SignIn ->
      let user = User "new User" ""
      in
      ({model | user = user}, Cmd.none)
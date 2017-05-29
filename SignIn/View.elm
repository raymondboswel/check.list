module SignIn.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, placeholder)
import Html.Events exposing (on, keyCode, onInput, onClick)
import SignIn.Types exposing (..)
import Msgs exposing (..)

view : Model -> Html SignIn.Types.Msg
view model =
    div []
        [h2 [] [text "Sign in"],
        input [placeholder "Username"] [text model.user.email],
        input [placeholder "Password"] [text model.user.password],
        button [ onClick SignIn ] [text "Sign in"]]
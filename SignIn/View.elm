module SignIn.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, placeholder)
import Html.Events exposing (on, keyCode, onInput, onClick)
import SignIn.Types exposing (..)
import Msgs exposing (..)
-- import RemoteData exposing (..)
-- import UI exposing (renderSpinner, onKeyDown)

view : Model -> Html Msgs.Msg
view model =
    div []
        [h2 [] [text "Sign in"],
        input [placeholder "Username"] [text model.user.username],
        input [placeholder "Password"] [text model.user.password],
        button [ ] [text "Sign in"]]
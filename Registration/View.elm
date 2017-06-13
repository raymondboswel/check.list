module Registration.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, placeholder, type_)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Registration.Types exposing (..)
import Msgs exposing (..)

view : Model -> Html Registration.Types.Msg
view model =
    div []
        [h2 [] [text "Register"],
        input [placeholder "Username", onInput Registration.Types.OnEmailInput] [text model.user.email],
        input [placeholder "Password", type_ "password", onInput Registration.Types.OnPasswordInput] [text model.user.password],
        input [placeholder "Password", type_ "password", onInput Registration.Types.OnPasswordRepeatInput] [text model.user.repeatPassword],
        button [ onClick Registration.Types.Register ] [text "Register"]
         ]
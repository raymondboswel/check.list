module SignIn.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, placeholder, type_)
import Html.Events exposing (on, keyCode, onInput, onClick)
import SignIn.Types exposing (..)
import Msgs exposing (..)
import Models exposing (..)

view : Models.Model -> Html SignIn.Types.Msg
view model =
    div []
        [h2 [] [text "Sign in"],
        input [placeholder "Username", onInput SignIn.Types.OnEmailInput] [text model.signInModel.user.email],
        input [placeholder "Password", type_ "password", onInput SignIn.Types.OnPasswordInput] [text model.signInModel.user.password],
        button [ onClick SignIn.Types.SignIn ] [text "Sign in"],
        div [] [a [class "clickable", onClick SignIn.Types.GotoRegistration] [text "Don't have a profile?"]] ]
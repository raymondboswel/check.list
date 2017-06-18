module Registration.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, placeholder, type_)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Registration.Types exposing (..)
import Dialog
import Msgs exposing (..)

view : Model -> Html Registration.Types.Msg
view model =
    div []
        [h2 [] [text "Register"],
        input [placeholder "Username", onInput Registration.Types.OnEmailInput] [text model.user.email],
        input [placeholder "Password", type_ "password", onInput Registration.Types.OnPasswordInput] [text model.user.password],
        input [placeholder "Password", type_ "password", onInput Registration.Types.OnPasswordRepeatInput] [text model.user.repeatPassword],
        button [ onClick Registration.Types.Register ] [text "Register"]
        ,
        Dialog.view
        (if model.shouldDisplayPasswordModal then
          Just (dialogConfig model)
         else
          Nothing
        ) ]

dialogConfig : Model -> Dialog.Config Registration.Types.Msg
dialogConfig model =
    { closeMessage = Nothing
    , containerClass = Nothing
    , header = Just (h3 [] [ text "Password mismatch" ])
    , body = Just (text ("Please ensure that the passwords match."))
    , footer =
        Just
            (button
                [ class "btn btn-success"
                , onClick Registration.Types.AcknowledgeDialog
                ]
                [ text "OK" ]
            )
    }
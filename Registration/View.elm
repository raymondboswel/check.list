module Registration.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, placeholder, type_)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Registration.Types exposing (..)
import Dialog
import Models exposing (..)
import Msgs exposing (..)

view : Models.Model -> Html (Registration.Types.Msg, Models.Model)
view model =
    div []
        [h2 [] [text "Register"],
        input [placeholder "Username", onInput Registration.Types.OnEmailInput] [text model.registrationModel.user.email],
        input [placeholder "Password", type_ "password", onInput Registration.Types.OnPasswordInput] [text model.registrationModel.user.password],
        input [placeholder "Password", type_ "password", onInput Registration.Types.OnPasswordRepeatInput] [text model.registrationModel.user.repeatPassword],
        button [ onClick (Registration.Types.Register, model) ] [text "Register"]
        ,
        Dialog.view
        (if model.registrationModel.shouldDisplayPasswordModal then
          Just (dialogConfig model)
         else
          Nothing
        ) ]

dialogConfig : Models.Model -> Dialog.Config Registration.Types.Msg
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
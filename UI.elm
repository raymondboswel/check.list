module UI exposing (..)
import Html exposing (Html, button, div, text, node, h4, input, i)
import Html.Events exposing (on, keyCode)
import Json.Decode as Json
import Html.Attributes exposing (..)
import Msgs exposing (..)

renderSpinner : () -> Html Msgs.Msg
renderSpinner () = 
    div [class "preloader-wrapper big active add-top center-spinner-horizontally"] 
      [
        div [class "spinner-layer spinner-blue-only"] 
          [
            div [class "circle-clipper left"] [div [class "circle"] []],
            div [class "gap-patch"] [div [class "circle"] []],
            div [class "circle-clipper right" ] [div [class "circle"] []]
        ]]

onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
  on "keydown" (Json.map tagger keyCode)
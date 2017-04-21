module Projects.List exposing (..)

import Html exposing (Html, button, div, text, node, h4, input, i)
import List exposing (foldl)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Json.Decode as Json
import Html.Attributes exposing (..)
import Http exposing (..)
import Projects.Model exposing (Projects)
import Msgs exposing (Msg)
import Html.Attributes exposing (..) 

view : Projects -> Html Msg
view model =
  div [class "container"] [
    div [class "collection with-header"]   
       [div [class "collection-header"] 
       [text "Projects", i [class "material-icons dp48"] []], 
       renderProjects model.projects,
       div [class "collection-item"] 
        [div [class "input-field"] 
          [input [placeholder "New project", onKeyDown Msgs.KeyDown, onInput Msgs.Input, value model.newProjectName] [] ]  ]  ] ]

renderProject : String -> Html Msg
renderProject name = div [class "collection-item"] [text name, i [class "material-icons pull-right", onClick (Msgs.RemoveProject name)] [text "delete"] ]

renderProjects : List String -> Html Msg
renderProjects projects =
  let
    projectItems = List.map renderProject projects
  in
    div [ class "collection-header" ] projectItems

onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
  on "keydown" (Json.map tagger keyCode)
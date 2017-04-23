module Projects.List exposing (..)

import Html exposing (Html, button, div, text, node, h4, input, i)
import List exposing (foldl)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Json.Decode as Json
import Html.Attributes exposing (..)
import Http exposing (..)
import Models exposing (Model, Project)
import Msgs exposing (Msg)
import Html.Attributes exposing (..) 
import RemoteData exposing (WebData)

view : Model -> Html Msg
view model =
  div [class "container"] [maybeRenderProjects model]
    

renderProject : Project -> Html Msg
renderProject project = div [class "collection-item"] [text project.name, i [class "material-icons pull-right"] [text "delete"] ]


maybeRenderProjects : Model -> Html Msg
maybeRenderProjects model =
    case model.projects of
        RemoteData.NotAsked ->
            renderSpinner ()
        RemoteData.Loading ->
            renderSpinner ()
        RemoteData.Success projects ->
            renderTable (projects) (model)
        RemoteData.Failure error ->
            renderSpinner ()

-- <div class="preloader-wrapper big active">
--     <div class="spinner-layer spinner-blue-only">
--       <div class="circle-clipper left">
--         <div class="circle"></div>
--       </div>
--       <div class="gap-patch">
--         <div class="circle"></div>
--       </div>
--       <div class="circle-clipper right">
--         <div class="circle"></div>
--       </div>
--     </div>
--   </div>


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

renderTable : List Project -> Model-> Html Msgs.Msg
renderTable projects model = 
    div [class "collection with-header"]   
       [
           div [class "collection-header"] [text "Projects", i [class "material-icons dp48"] []], 
           renderProjects projects,
           div [class "collection-item"] [
               div [class "input-field"] 
                [input [placeholder "New project", onKeyDown Msgs.KeyDown, onInput Msgs.Input, value model.newProjectName] [] ]]]

renderProjects : List Project -> Html Msgs.Msg
renderProjects projects =
  let
    projectItems = List.map renderProject projects
  in
    div [ class "collection-header" ] projectItems

onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
  on "keydown" (Json.map tagger keyCode)
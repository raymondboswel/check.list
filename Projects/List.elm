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
import UI exposing (renderSpinner, onKeyDown)

view : Model -> Html Msg
view model =
  maybeRenderProjects model
    

renderProject : Project -> Html Msg
renderProject project = div [class "collection-item row-item", onClick (Msgs.SelectProject project)] [text project.name, i [class "material-icons pull-right", onClick (Msgs.RemoveProject project)] [text "delete"] ]


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

renderTable : List Project -> Model-> Html Msgs.Msg
renderTable projects model = 
    div [class "collection with-header"] (constructTableChildren projects model)

constructTableChildren : List Project -> Model-> List (Html Msgs.Msg)
constructTableChildren projects model = 
    let table = div [class "collection-header"] [text "Projects", i [class "material-icons dp48"] []] :: renderProjects projects 
    in List.append table [(div [class "collection-item"] [inputField "New Project" model.newProjectName (Msgs.OnNewProjectInput "") (Msgs.OnNewProjectKeyDown 0)])]

inputField : String -> String -> Msgs.Msg -> Msgs.Msg -> Html Msgs.Msg
inputField placeholderText modelValue onInputEvent onKeyDownEvent =  
    div [class "input-field"] [input [placeholder placeholderText, onKeyDown Msgs.OnNewProjectKeyDown, onInput Msgs.OnNewProjectInput, value modelValue] []]

renderProjects : List Project -> List (Html Msgs.Msg)
renderProjects projects =
  let
    projectItems = List.map renderProject projects
  in
    projectItems


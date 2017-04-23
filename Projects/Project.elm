module Projects.Project exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, placeholder)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Msgs exposing (Msg)
import Models exposing (..) 
import RemoteData exposing (..) 
import UI exposing (renderSpinner, onKeyDown)

view : Model -> Html Msg
view model =
    div []
        [ maybeRenderChecklists model
        ]

maybeRenderChecklists : Model -> Html Msg
maybeRenderChecklists model =

    case model.checklists of
        RemoteData.NotAsked ->
            renderSpinner ()
        RemoteData.Loading ->
            renderSpinner ()
        RemoteData.Success checklists ->
            renderTable (checklists) (model)
        RemoteData.Failure error ->
            renderSpinner ()

renderTable : List Checklist -> Model-> Html Msgs.Msg
renderTable projects model = 
    div [class "collection with-header"]   
       [
           div [class "collection-header"] [text "Checklists", i [class "material-icons dp48"] []], 
           renderChecklists checklists,
           div [class "collection-item"] [
               div [class "input-field"] 
                [input [placeholder "New project", onKeyDown Msgs.KeyDown, onInput Msgs.Input, value model.newChecklistName] [] ]]]

renderChecklists : List Checklist -> Html Msgs.Msg
renderChecklists checklists =
  let
    checklistItems = List.map renderChecklist checklists
  in
    div [ class "collection-header" ] checklistItems

renderChecklist : Checklist -> Html Msg
renderChecklist checklist = div [class "collection-item"] [text checklist.name, i [class "material-icons pull-right", onClick (Msgs.RemoveChecklist checklist)] [text "delete"] ]
module Projects.Project exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, placeholder)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Msgs exposing (Msg)
import Models exposing (..) 
import RemoteData exposing (..) 
import UI exposing (renderSpinner, onKeyDown)

view : Model -> List Checklist -> Html Msg
view model checklists =
    div []
        [ renderTable checklists model
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
renderTable checklists model = 
    div [class "collection with-header"] (constructTableChildren checklists model)

constructTableChildren : List Checklist -> Model-> List (Html Msgs.Msg)
constructTableChildren checklists model = 
    let table = div [class "collection-header"] [text "Checklists", i [class "material-icons dp48"] []] :: renderChecklists checklists 
    in List.append table [(div [class "collection-item"] [inputField "New Checklist" model.newChecklistName (Msgs.OnNewChecklistInput "") (Msgs.OnNewChecklistKeyDown 0)])]

inputField : String -> String -> Msgs.Msg -> Msgs.Msg -> Html Msgs.Msg
inputField placeholderText modelValue onInputEvent onKeyDownEvent =  
    div [class "input-field"] [input [placeholder placeholderText, onKeyDown Msgs.OnNewChecklistKeyDown, onInput Msgs.OnNewChecklistInput, value modelValue] []]

renderChecklists : List Checklist -> List (Html Msgs.Msg)
renderChecklists checklists =
    List.map renderChecklist checklists
  

renderChecklist : Checklist -> Html Msg
renderChecklist checklist = div [class "collection-item row-item", onClick (Msgs.SelectChecklist checklist)] [text checklist.name, i [class "material-icons pull-right", onClick (Msgs.RemoveChecklist checklist)] [text "delete"] ]
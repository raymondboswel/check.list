module Projects.Checklist exposing (..)

import Exts.Html exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, value, href, checked, placeholder, type_, for, id, contenteditable, style)
import Html.Events exposing (on, keyCode, onInput, onClick, onCheck)
import Msgs exposing (Msg)
import Models exposing (..)
import RemoteData exposing (..)
import Html.Events exposing (onBlur, on)
import Json.Decode as Json
import UI exposing (renderSpinner, onKeyDown)

view : Model -> List Item -> Html Msg
view model items =
    div []
        [ renderTable items model
        ]

maybeRenderChecklists : Model -> Html Msg
maybeRenderChecklists model =

    case model.items of
        RemoteData.NotAsked ->
            renderSpinner ()
        RemoteData.Loading ->
            renderSpinner ()
        RemoteData.Success items ->
            renderTable (items) (model)
        RemoteData.Failure error ->
            renderSpinner ()

renderTable : List Item -> Model-> Html Msgs.Msg
renderTable items model =
    div [class "collection with-header"] (constructTableChildren items model)

constructTableChildren : List Item -> Model-> List (Html Msgs.Msg)
constructTableChildren items model =
    let table = div [class "collection-header"] [UI.backButton Msgs.GotoProject, text "Checklist items"] :: renderItems items
    in List.append table [(div [class "collection-item"] [inputField "New Item" model.newItemName (Msgs.OnNewItemInput "") (Msgs.OnNewItemKeyDown 0)])]

inputField : String -> String -> Msgs.Msg -> Msgs.Msg -> Html Msgs.Msg
inputField placeholderText modelValue onInputEvent onKeyDownEvent =
    div [class "input-field"] [input [placeholder placeholderText, onKeyDown Msgs.OnNewItemKeyDown, onInput Msgs.OnNewItemInput, value modelValue] []]

renderItems : List Item -> List (Html Msgs.Msg)
renderItems items =
    List.map renderItem items

renderItem : Item -> Html Msg
renderItem item = div [class "collection-item row-item", onClick (Msgs.EditingItem item) ]
                      [
                        input
                            [type_ "checkbox",
                             checked item.completed,
                             id (toString item.id)]
                            [],
                        label
                            [onClick (Msgs.ToggleItemCompleted item), for (toString item.id)]
                            [text Exts.Html.nbsp],
                        div [contenteditable True, class "inline-block", onClick (Msgs.EditingItem item) ,on "blur" (Json.map Msgs.EditItem targetTextContent)]
                            [text item.name],
                        i
                            [class "material-icons pull-right", onClick (Msgs.RemoveItem item)]
                            [text "delete"],
                        i   [class "material-icons pull-right"]
                            [text "expand_more"] ]

targetTextContent : Json.Decoder String
targetTextContent =
    Json.at ["target", "textContent"] Json.string
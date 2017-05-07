module View exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (..) 
import Models exposing (..)
import Msgs exposing (Msg)
import Projects.Project exposing (..)
import Projects.List exposing (..)
import Projects.Checklist exposing (..)
import RemoteData


view : Model -> Html Msg
view model =
    div [class "container"] 
        [ page model ]

page : Model -> Html Msg
page model =
    case model.route of
        Models.ProjectsRoute ->
            Projects.List.view model

        Models.ProjectRoute id ->
            projectChecklistsPage model id
        
        Models.ChecklistRoute id ->
            checklistItemsPage model id

        Models.NotFoundRoute ->
            notFoundView

checklistItemsPage : Model -> ChecklistId -> Html Msg
checklistItemsPage model checklistId =
    case model.items of 
        RemoteData.NotAsked ->
            text ""
        RemoteData.Loading ->
            text "Loading..."
        RemoteData.Success items ->
            Projects.Checklist.view model items
        RemoteData.Failure err -> 
            text (toString err)

projectChecklistsPage : Model -> ProjectId -> Html Msg
projectChecklistsPage model projectId =
    case model.checklists of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading ..."

        RemoteData.Success checklists ->
            Projects.Project.view model checklists

        RemoteData.Failure err ->
            text (toString err)

notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
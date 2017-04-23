module View exposing (..)

import Html exposing (Html, div, text)
import Models exposing (Model, ProjectId)
import Models exposing (Model)
import Msgs exposing (Msg)
import Projects.Project exposing (..)
import Projects.List exposing (..)
import RemoteData


view : Model -> Html Msg
view model =
    div []
        [ page model ]

page : Model -> Html Msg
page model =
    case model.route of
        Models.ProjectsRoute ->
            Projects.List.view model

        Models.ProjectRoute id ->
            projectChecklistsPage model id

        Models.NotFoundRoute ->
            notFoundView

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
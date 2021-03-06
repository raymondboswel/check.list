module View exposing (..)

import Html exposing (Html, div, text, button, h3)
import SignIn.View exposing (view)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Registration.View exposing (view)
import Html.Attributes exposing (..)
import Models exposing (..)
import Dialog
import Msgs exposing (Msg)
import SignIn.Types exposing (..)
import Registration.Types exposing (..)
import Projects.Project exposing (..)
import Projects.List exposing (..)
import Projects.Checklist exposing (..)
import RemoteData


view : Models.Model -> Html Msgs.Msg
view model =
    div [class "container"]
        [ page model ]

page : Models.Model -> Html Msgs.Msg
page model =
    case model.route of
        Models.ProjectsRoute ->
            Projects.List.view model

        Models.ProjectRoute id ->
            projectChecklistsPage model id

        Models.ChecklistRoute id ->
            checklistItemsPage model id

        Models.SignInRoute ->
            signInPage model

        Models.RegistrationRoute ->
        registrationPage model

        Models.NotFoundRoute ->
            notFoundView

registrationPage : Models.Model -> Html Msgs.Msg
registrationPage model =
    Html.map Msgs.RegistrationMsg (Registration.View.view model)

signInPage : Models.Model -> Html Msgs.Msg
signInPage model =
    Html.map Msgs.SignInMsg (SignIn.View.view model)


checklistItemsPage : Models.Model -> ChecklistId -> Html Msgs.Msg
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

projectChecklistsPage : Models.Model -> ProjectId -> Html Msgs.Msg
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
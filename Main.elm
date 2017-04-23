import Html exposing (Html, button, div, text, node, h4, input, i)
import List exposing (foldl)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Json.Decode as Json
import Json.Decode as Decode
import Msgs exposing (..)
import Models exposing (..)
import Commands exposing (..)
import RemoteData exposing (..)
import Routing exposing (..)
import Navigation exposing (Location)
import View exposing (view)

main : Program Never Model Msg
main =
  Navigation.program Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

init : Location -> (Model, Cmd Msg)
init location =
  let currentRoute = Routing.parseLocation location in
  (Model currentRoute RemoteData.Loading "" RemoteData.Loading "", Commands.fetchProjects)

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let one = "one" in 
    case Debug.log "message" msg of    
      
      OnNewProjectKeyDown key ->
        if key == 13 then 
          let projectName = model.newProjectName in 
            ({ model | newProjectName = ""}, Commands.addProject projectName)
        else
          (model, Cmd.none)

      OnNewChecklistInput projectName -> 
        ({ model | newProjectName = projectName }, Cmd.none)

      OnNewChecklistKeyDown key ->
        if key == 13 then 
          let projectName = model.newProjectName in 
            ({ model | newProjectName = ""}, Commands.addProject projectName)
        else
          (model, Cmd.none)
          
      OnNewProjectInput projectName -> 
        ({ model | newProjectName = projectName }, Cmd.none)

      OnFetchProjects response -> 
        ({model | projects = response}, Cmd.none)

      GetProjects -> 
        (model, Commands.fetchProjects )

      OnSaveProject projectId-> 
        (model, Commands.fetchProjects)

      RemoveProject project ->
        (model, Commands.deleteProject project)

      DeleteProject (Ok projectName)-> 
        (model, Commands.fetchProjects)
      
      DeletedChecklist (Ok checklistName) ->
        (model, Cmd.none) 

      DeletedChecklist (Err error) ->
        (model, Cmd.none) 

      DeleteProject (Err error)-> 
        (model, Cmd.none)

      SelectProject project ->
        ({model | route = ProjectRoute project.id}, Commands.fetchProjectChecklists project)

      RemoveChecklist checklist ->
        (model, Commands.deleteChecklist checklist)

      OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )


onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
  on "keydown" (Json.map tagger keyCode)


import Html exposing (Html, button, div, text, node, h4, input, i)
import List exposing (foldl)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Json.Decode as Json
import Json.Decode as Decode
import Msgs exposing (..)
import Models exposing (..)
import Projects.List exposing (..)
import Commands exposing (..)
import RemoteData exposing (..)

main : Program Never Model Msg
main =
  Html.program {init = init, view = Projects.List.view, update = update, subscriptions = subscriptions }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

init : (Model, Cmd Msg)
init =
  (Model RemoteData.Loading "", Commands.fetchProjects)

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let one = "one" in 
    case Debug.log "message" msg of    
      
      KeyDown key ->
        if key == 13 then 
          let projectName = model.newProjectName in 
            ({ model | newProjectName = ""}, Commands.addProject projectName)
            -- (model, Cmd.none)
        else
          (model, Cmd.none)
      Input projectName -> 
        ({ model | newProjectName = projectName }, Cmd.none)

      OnFetchProjects response -> 
        ({model | projects = response}, Cmd.none)

      -- OnFetchProjects (Err _) ->
      --   (model, Cmd.none)

      GetProjects -> 
        (model, Commands.fetchProjects )

      OnSaveProject projectId-> 
        (model, Commands.fetchProjects)

      -- AddProject (Ok project )->             
      --   (model, Commands.fetchProjects)

      -- AddProject (Err project )-> 
      --   (model, Commands.fetchProjects)

      -- RemoveProject project ->
      --   (model, Commands.deleteProject project)

      -- DeleteProject (Ok projectName)-> 
      --   (model, Commands.fetchProjects)

      -- DeleteProject (Err error)-> 
      --   (model, Cmd.none)

      ExpandProject projectName ->
        (model, Cmd.none)


onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
  on "keydown" (Json.map tagger keyCode)


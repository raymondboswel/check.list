import Html exposing (Html, button, div, text, node, h4, input, i)
import List exposing (foldl)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Json.Decode as Json
import Json.Decode as Decode
import Msgs exposing (..)
import Projects.Models exposing (..)
import Projects.List exposing (..)
import Commands exposing (..)

main : Program Never Projects Msg
main =
  Html.program {init = init, view = Projects.List.view, update = update, subscriptions = subscriptions }

subscriptions : Projects -> Sub Msg
subscriptions model =
  Sub.none

init : (Projects, Cmd Msg)
init =
  (Projects [] "", getProjects)

-- UPDATE

update : Msg -> Projects -> (Projects, Cmd Msg)
update msg model =
  let one = "one" in 
    case Debug.log "message" msg of    
      
      KeyDown key ->
        if key == 13 then 
          let projectName = model.newProjectName in 
            ({ model | newProjectName = ""}, Commands.addProject projectName)
        else
          (model, Cmd.none)
      Input projectName -> 
        ({ model | newProjectName = projectName }, Cmd.none)

      AllProjects (Ok newProjects) -> 
        ({model | projects = newProjects}, Cmd.none)

      AllProjects (Err _) ->
        (model, Cmd.none)

      GetProjects -> 
        (model, Commands.getProjects )

      AddProject (Ok project )->             
        (model, Commands.getProjects)

      AddProject (Err project )-> 
        (model, Commands.getProjects)

      RemoveProject projectName ->
        (model, Commands.deleteProject projectName)

      DeleteProject (Ok projectName)-> 
        ({ model | projects = List.filter (\project -> project /= projectName) model.projects}, Cmd.none)

      DeleteProject (Err error)-> 
        (model, Cmd.none)

      ExpandProject projectName ->
        (model, Cmd.none)


onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
  on "keydown" (Json.map tagger keyCode)


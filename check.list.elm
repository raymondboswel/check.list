import Html exposing (Html, button, div, text, node, h4, input, i)
import List exposing (foldl)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Json.Decode as Json
import Html.Attributes exposing (..) 

main : Program Never Model Msg
main =
  Html.program {init = init, view = view, update = update, subscriptions = subscriptions }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

type alias Model = {projects : List String, newProjectName : String}
init : (Model, Cmd Msg)
init =
  (Model ["Project 1", "Project 2"] "", Cmd.none)

-- UPDATE

type Msg = RemoveProject String | KeyDown Int | Input String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of    
    RemoveProject projectName ->
      ({ model | projects = List.filter (\project -> project /= projectName) model.projects}, Cmd.none)
    KeyDown key ->
      if key == 13 then 
        ({ model | projects = model.newProjectName :: model.projects, newProjectName = ""}, Cmd.none)
      else
        (model, Cmd.none)
    Input projectName -> 
      ({ model | newProjectName = projectName }, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  div [class "container"] [
    div [class "collection with-header"]   
       [div [class "collection-header"] 
       [text "Projects", i [class "material-icons dp48"] []], 
       renderProjects model.projects,
       div [class "collection-item "] 
        [div [class "input-field"] 
          [input [placeholder "New project", onKeyDown KeyDown, onInput Input, value model.newProjectName] [] ]  ]  ] ]


renderProject : String -> Html Msg
renderProject name = div [class "collection-item"] [text name, i [class "material-icons pull-right", onClick (RemoveProject name)] [text "delete"] ]

renderProjects : List String -> Html Msg
renderProjects projects =
  let
    projectItems = List.map renderProject projects
  in
    div [ class "collection-header" ] projectItems

onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
  on "keydown" (Json.map tagger keyCode)
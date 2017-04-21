import Html exposing (Html, button, div, text, node, h4, input, i)
import List exposing (foldl)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Json.Decode as Json
import Html.Attributes exposing (..) 
import Http exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Msgs exposing (..)

main : Program Never Model Msg
main =
  Html.program {init = init, view = view, update = update, subscriptions = subscriptions }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

type alias Model = {projects : List String, newProjectName : String}
init : (Model, Cmd Msg)
init =
  (Model [] "", getProjects)

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let one = "one" in 
    case Debug.log "message" msg of    
      
      KeyDown key ->
        if key == 13 then 
          let projectName = model.newProjectName in 
            ({ model | newProjectName = ""}, addProject projectName)
        else
          (model, Cmd.none)
      Input projectName -> 
        ({ model | newProjectName = projectName }, Cmd.none)

      AllProjects (Ok newProjects) -> 
        ({model | projects = newProjects}, Cmd.none)

      AllProjects (Err _) ->
        (model, Cmd.none)

      GetProjects -> 
        (model, getProjects )

      AddProject (Ok project )->             
        (model, getProjects)

      AddProject (Err project )-> 
        (model, getProjects)

      RemoveProject projectName ->
        (model, deleteProject projectName)

      DeleteProject (Ok projectName)-> 
        ({ model | projects = List.filter (\project -> project /= projectName) model.projects}, Cmd.none)

      DeleteProject (Err error)-> 
        (model, Cmd.none)

      ExpandProject projectName ->
        (model, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  div [class "container"] [
    div [class "collection with-header"]   
       [div [class "collection-header"] 
       [text "Projects", i [class "material-icons dp48"] []], 
       renderProjects model.projects,
       div [class "collection-item"] 
        [div [class "input-field"] 
          [input [placeholder "New project", onKeyDown KeyDown, onInput Input, value model.newProjectName] [] ]  ]  ] ]

renderProject : String -> Html Msg
renderProject name = div [class "collection-item", onClick (ExpandProject name)] [text name, i [class "material-icons pull-right", onClick (RemoveProject name)] [text "delete"] ]

renderProjects : List String -> Html Msg
renderProjects projects =
  let
    projectItems = List.map renderProject projects
  in
    div [ class "collection-header" ] projectItems

onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
  on "keydown" (Json.map tagger keyCode)

addProject : (String) -> Cmd Msg
addProject name =   
  let
    url =
      String.append "http://localhost:4000/api/projects?name=" name
  in    
    Http.send AddProject (Http.post url Http.emptyBody (Decode.at ["id"] (Decode.int)))


deleteProject : (String) -> Cmd Msg
deleteProject projectName = 
  Http.send DeleteProject (delete projectName)

delete : String -> Request String
delete name =
  request
    { method = "DELETE"
    , headers = []
    , url = String.append "http://localhost:4000/api/projects?name=" name
    , body = emptyBody
    , expect = Http.expectString
    , timeout = Nothing
    , withCredentials = False
    }

getProjects : Cmd Msg
getProjects =
  let
    url =
      "http://localhost:4000/api/projects"    
  in
    Http.send AllProjects (Http.get url decodeProjects)

decodeProjects : Decode.Decoder (List String)
decodeProjects =
  Decode.at ["data"] (Decode.list Decode.string)
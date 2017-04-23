module Commands exposing (..)
import Msgs exposing (..)
import Http exposing (..)
import Models exposing (..)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import RemoteData exposing (..)

addProject : (String) -> Cmd Msg
addProject projectName =   
  let
    url =
      String.append "http://localhost:4000/api/projects?name=" projectName
  in    
    Http.post url Http.emptyBody (Decode.at ["id"] (Decode.int))
    |> Http.send Msgs.OnSaveProject
    


deleteProject : (Project) -> Cmd Msg
deleteProject project = 
  Http.send DeleteProject (delete project.name) 

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

fetchProjects : Cmd Msg
fetchProjects =
    Http.get fetchProjectsUrl projectsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchProjects

projectsDecoder : Decode.Decoder (List Project)
projectsDecoder =
    Decode.list projectDecoder

projectDecoder : Decode.Decoder Project
projectDecoder =
    decode Project
        |> required "id" Decode.int
        |> required "name" Decode.string

fetchProjectsUrl : String
fetchProjectsUrl = "http://localhost:4000/api/projects"

-- getProjects : Cmd Msg
-- getProjects =
--   let
--     url =
--       "http://localhost:4000/api/projects"    
--   in
--     Http.send AllProjects (Http.get url decodeProjects)

-- decodeProjects : Decode.Decoder (List String)
-- decodeProjects =
--   Decode.list Decode.string
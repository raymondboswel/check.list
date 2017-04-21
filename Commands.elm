module Commands exposing (..)
import Msgs exposing (..)
import Http exposing (..)
import Json.Decode as Decode

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
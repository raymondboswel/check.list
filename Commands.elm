module Commands exposing (..)
import Msgs exposing (..)
import Http exposing (..)
import Models exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode exposing (..)
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

addChecklist : Int -> String -> Cmd Msg
addChecklist projectId checklistName =   
  let
    url =
      projectResourceUrl ++ "/" ++ toString(projectId) ++ "/checklists"
    body =
        checklistEncoder checklistName |> Http.jsonBody
  in    
    Http.post url body (Decode.at ["id"] (Decode.int))
    |> Http.send Msgs.OnSaveChecklist

checklistEncoder : String -> Encode.Value
checklistEncoder checklistName = 
    Encode.object 
        [ ("name", Encode.string checklistName)
        ]      
    
deleteProject : (Project) -> Cmd Msg
deleteProject project = 
  Http.send DeleteProject (deleteByName projectResourceUrl project.name) 

projectResourceUrl : String 
projectResourceUrl =
    "http://localhost:4000/api/projects"

deleteChecklist : Checklist -> Cmd Msg
deleteChecklist checklist =
    Http.send (Msgs.DeletedChecklist) (deleteById checklistResourceUrl checklist.id)

projectChecklistsResourceUrl : Project -> String
projectChecklistsResourceUrl project = 
    "http://localhost:4000/api/projects/" ++ toString(project.id) ++ "/checklists"

checklistResourceUrl : String
checklistResourceUrl =
    "http://localhost:4000/api/checklists"

deleteById : String -> Int -> Request String
deleteById url id =
  request
    { method = "DELETE"
    , headers = []
    , url = url ++ "/" ++ toString(id)
    , body = emptyBody
    , expect = Http.expectString
    , timeout = Nothing
    , withCredentials = False
    }

deleteByName : String -> String -> Request String
deleteByName url name =
  request
    { method = "DELETE"
    , headers = []
    , url = url ++ "?name=" ++ name
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

fetchProjectChecklists : Project -> Cmd Msg
fetchProjectChecklists project = 
    Http.get (fetchProjectChecklistsUrl project) projectsDecoder
            |> RemoteData.sendRequest
            |> Cmd.map Msgs.OnFetchProjectChecklists

fetchProjectChecklistsUrl : Project -> String
fetchProjectChecklistsUrl project = "http://localhost:4000/api/projects/" ++ toString project.id ++ "/checklists"

checklistsDecoder : Decode.Decoder (List Checklist)
checklistsDecoder = 
    Decode.list checklistDecoder

checklistDecoder : Decode.Decoder Checklist
checklistDecoder = 
    decode Checklist  
        |> required "id" Decode.int
        |> required "name" Decode.string

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
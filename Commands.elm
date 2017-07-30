module Commands exposing (..)
import Msgs exposing (..)
import Http exposing (..)
import Models exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode exposing (..)
import Json.Decode.Pipeline exposing (decode, required)
import RemoteData exposing (..)

addProject : Models.Model -> String -> Cmd Msg
addProject model projectName =   
  let
    url =
      model.api ++ "/api/projects?name=" ++ projectName
  in    
    Http.post url Http.emptyBody (Decode.at ["id"] (Decode.int))
    |> Http.send Msgs.OnSaveProject

addChecklist : Models.Model -> Int -> String -> Cmd Msg
addChecklist model projectId checklistName =   
  let
    url =
      (projectResourceUrl model) ++ "/" ++ toString(projectId) ++ "/checklists"
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

addItem : Models.Model -> Int -> String -> Cmd Msg
addItem model checklistId itemName =   
  let
    url =
      model.api ++ "/api/checklists/" ++ toString(checklistId) ++ "/items"
    body =
        itemEncoder itemName False 1 |> Http.jsonBody
  in    
    Http.post url body (Decode.at ["id"] (Decode.int))
    |> Http.send Msgs.OnSaveItem

updateChecklistItem : Models.Model -> Item -> Cmd Msg
updateChecklistItem model item = 
  let 
    url = model.api ++ "/api/items/" ++ toString(item.id)
    body = itemEncoder item.name item.completed item.sequenceNumber |> Http.jsonBody
  in Http.send Msgs.UpdatedItem (putRequest url body) 


putRequest : String -> Body -> Request String
putRequest url body =
    request
        { method = "PUT"
        , headers = []
        , url = url
        , body = body
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }

itemEncoder : String -> Bool -> Int -> Encode.Value
itemEncoder itemName completed sequenceNumber = 
    Encode.object 
        [ ("name", Encode.string itemName),
          ("completed", Encode.bool completed),
          ("sequence_number", Encode.int sequenceNumber)
        ]      
    
deleteProject : Models.Model -> (Project) -> Cmd Msg
deleteProject model project = 
  Http.send DeleteProject (deleteByName (projectResourceUrl model) project.name) 

projectResourceUrl : Models.Model -> String 
projectResourceUrl model =
    model.api ++ "/api/projects"

deleteChecklist : Models.Model -> Checklist -> Cmd Msg
deleteChecklist model checklist =
    Http.send (Msgs.DeletedChecklist) (deleteById (checklistResourceUrl model) checklist.id)

deleteItem : Models.Model -> Item -> Cmd Msg
deleteItem model item = 
    Http.send (Msgs.DeletedItem) (deleteById (itemResourceUrl model) item.id)

itemResourceUrl : Models.Model -> String
itemResourceUrl model = 
    model.api ++ "/api/items"

projectChecklistsResourceUrl : Models.Model -> Project -> String
projectChecklistsResourceUrl model project = 
    model.api ++ "/api/projects/" ++ toString(project.id) ++ "/checklists"

checklistResourceUrl : Models.Model -> String
checklistResourceUrl model =
    model.api ++ "/api/checklists"

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

fetchProjects : Models.Model -> Cmd Msg
fetchProjects model =
    Http.get (fetchProjectsUrl model) projectsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchProjects

fetchProjectChecklists : Models.Model -> Project -> Cmd Msg
fetchProjectChecklists model project = 
    Http.get (fetchProjectChecklistsUrl model project) checklistsDecoder
            |> RemoteData.sendRequest
            |> Cmd.map Msgs.OnFetchProjectChecklists

fetchChecklistItems : Models.Model -> Checklist -> Cmd Msg
fetchChecklistItems model checklist = 
     Http.get (fetchChecklistItemsUrl model checklist) itemsDecoder
            |> RemoteData.sendRequest
            |> Cmd.map Msgs.OnFetchChecklistItems

fetchChecklistItemsUrl : Models.Model -> Checklist -> String
fetchChecklistItemsUrl model checklist =
    model.api ++ "/api/checklists/" ++ toString(checklist.id) ++ "/items" 

fetchProjectChecklistsUrl : Models.Model -> Project -> String
fetchProjectChecklistsUrl model project = model.api ++ "/api/projects/" ++ toString project.id ++ "/checklists"

checklistsDecoder : Decode.Decoder (List Checklist)
checklistsDecoder = 
    Decode.list checklistDecoder

checklistDecoder : Decode.Decoder Checklist
checklistDecoder = 
    decode Checklist  
        |> required "id" Decode.int
        |> required "name" Decode.string

itemsDecoder : Decode.Decoder (List Item)
itemsDecoder = 
    Decode.list itemDecoder

itemDecoder : Decode.Decoder Item
itemDecoder = 
    decode Item  
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "completed" Decode.bool
        |> required "sequence_number" Decode.int
        |> Json.Decode.Pipeline.optional "displayDetails" Decode.bool False

projectsDecoder : Decode.Decoder (List Project)
projectsDecoder =
    Decode.list projectDecoder

projectDecoder : Decode.Decoder Project
projectDecoder =
    decode Project
        |> required "id" Decode.int
        |> required "name" Decode.string

fetchProjectsUrl : Models.Model -> String
fetchProjectsUrl model = model.api ++ "/api/projects"

-- getProjects : Cmd Msg
-- getProjects =
--   let
--     url =
--       model.api ++ "/api/projects"    
--   in
--     Http.send AllProjects (Http.get url decodeProjects)

-- decodeProjects : Decode.Decoder (List String)
-- decodeProjects =
--   Decode.list Decode.string
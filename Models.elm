module Models exposing (..)
import RemoteData exposing (WebData)

type alias Model = {projects : WebData (List Project), newProjectName : String}

type alias Project = {id: Int, name: String}

-- initialModel : Model
-- initialModel =
--     { 
--         projects = RemoteData.Loading, 
--         newProjectName = ""
--     }


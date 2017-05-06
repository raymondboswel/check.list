module Models exposing (..)
import RemoteData exposing (WebData)

type alias Model = {route: Route, selectedProject: Project, projects : WebData (List Project), newProjectName : String, checklists: WebData (List Checklist), newChecklistName: String}

type alias Project = {id: ProjectId, name: String}

initialProject : Project
initialProject =
    Project 0 ""

type alias Checklist = {id: ChecklistId, name: String}

type alias ChecklistId = Int
type alias ProjectId = Int  

type Route
    = ProjectsRoute
    | ProjectRoute ProjectId
    | NotFoundRoute

-- initialModel : Model
-- initialModel =
--     { 
--         projects = RemoteData.Loading, 
--         newProjectName = ""
--     }


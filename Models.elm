module Models exposing (..)
import RemoteData exposing (WebData)

type alias Model = {
    route: Route,
    selectedProject: Project,
    selectedChecklist: Checklist,
    projects : WebData (List Project),
    newProjectName : String,
    checklists: WebData (List Checklist),
    newChecklistName: String,
    items: WebData (List Item),
    newItemName: String,
    itemBeingEdited: Item
    }

type alias Project = {id: ProjectId, name: String}

initialProject : Project
initialProject =
    Project 0 ""

initialChecklist : Checklist
initialChecklist = Checklist 0 ""

type alias Item = {id: ItemId, name: String, completed: Bool, sequenceNumber: Int}
type alias ItemId = Int

type alias Checklist = {id: ChecklistId, name: String}

type alias ChecklistId = Int
type alias ProjectId = Int

type Route
    = ProjectsRoute
    | ProjectRoute ProjectId
    | ChecklistRoute ChecklistId
    | NotFoundRoute

-- initialModel : Model
-- initialModel =
--     {
--         projects = RemoteData.Loading,
--         newProjectName = ""
--     }


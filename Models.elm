module Models exposing (..)
import RemoteData exposing (WebData)
import SignIn.Types exposing (..)
import Registration.Types exposing (..)

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
    itemBeingEdited: Item,
    signInModel: SignIn.Types.Model,
    registrationModel: Registration.Types.Model,
    userAuth: SignIn.Types.UserAuth,
    api: String
    }

type alias Project = {id: ProjectId, name: String}

initialProject : Project
initialProject =
    Project 0 ""

initialChecklist : Checklist
initialChecklist = Checklist 0 ""

initialItem : Item
initialItem = Item 0 "" False 0 False

type alias Item = {id: ItemId, name: String, completed: Bool, sequenceNumber: Int, displayDetails: Bool}
type alias ItemId = Int

type alias Checklist = {id: ChecklistId, name: String}

type alias ChecklistId = Int
type alias ProjectId = Int

type Route =
    SignInRoute
    | ProjectsRoute
    | ProjectRoute ProjectId
    | ChecklistRoute ChecklistId
    | RegistrationRoute
    | NotFoundRoute

-- initialModel : Model
-- initialModel =
--     {
--         projects = RemoteData.Loading,
--         newProjectName = ""
--     }


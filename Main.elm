import Html exposing (Html, button, div, text, node, h4, input, i)
import List exposing (foldl)
import Html.Events exposing (on, keyCode, onInput, onClick)
import Json.Decode as Json
import Json.Decode as Decode
import Msgs exposing (..)
import Models exposing (..)
import Commands exposing (..)
import RemoteData exposing (..)
import Routing exposing (..)
import Navigation exposing (Location)
import SignIn.Types exposing (initialModel)
import Registration.Types exposing (initialModel)
import SignIn.State exposing(..)
import Registration.State exposing (..)
import View exposing (view)

main : Program Never Model Msg
main =
  Navigation.program Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

init : Location -> (Model, Cmd Msg)
init location =
  let currentRoute = Routing.parseLocation location in
  (Model  currentRoute --route
          Models.initialProject --selectedProject
          Models.initialChecklist --selectedChecklist
          RemoteData.Loading "" --projects/newProjectName
          RemoteData.Loading "" --checklists/newChecklistName
          RemoteData.Loading "" --items/NewItemName
          Models.initialItem
          SignIn.Types.initialModel
          Registration.Types.initialModel
          SignIn.Types.initialUserAuth
          , Commands.fetchProjects)

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let one = "one" in
    case Debug.log "message" msg of

      GotoProjects -> 
        ({model | route = ProjectsRoute}, Cmd.none)

      GotoProject ->
        ({model | route = ProjectRoute model.selectedProject.id}, Cmd.none)

      SignInMsg (SignIn.Types.SignedIn (Ok userAuth)) ->
        ({model | route = ProjectsRoute, userAuth = userAuth}, Cmd.none)

      RegistrationMsg (Registration.Types.Registered (Ok userAuth)) ->
        ({model | route = ProjectsRoute, userAuth = userAuth}, Cmd.none)

      SignInMsg (SignIn.Types.GotoRegistration) ->
        ({model | route = RegistrationRoute}, Cmd.none)

      SignInMsg signIn ->
            let
                (updatedSignInModel, signInCmd) =
                    SignIn.State.update signIn model.signInModel
            in
                ({ model | signInModel = updatedSignInModel }, Cmd.map SignInMsg signInCmd )

      Msgs.RegistrationMsg msg ->
        let
            (updatedRegistrationModel, registrationCmd) =
                Registration.State.update msg model.registrationModel
        in
            ({ model | registrationModel = updatedRegistrationModel }, Cmd.map RegistrationMsg registrationCmd )

      OnUserAuth userAuth ->
        ({model | userAuth = userAuth, route = ProjectsRoute}, Cmd.none)

      OnNewProjectKeyDown key ->
        if key == 13 then
          let projectName = model.newProjectName in
            ({ model | newProjectName = ""}, Commands.addProject projectName)
        else
          (model, Cmd.none)

      OnNewChecklistInput checklistName ->
        ({ model | newChecklistName = checklistName }, Cmd.none)

      OnNewChecklistKeyDown key ->
        if key == 13 then
          ({ model | newChecklistName = ""}, Commands.addChecklist model.selectedProject.id model.newChecklistName)
        else
          (model, Cmd.none)

      EditItem text ->
        let item = model.itemBeingEdited in
         (model, Commands.updateChecklistItem {item | name = text})

      EditingItem item ->
        ({model | itemBeingEdited = item}, Cmd.none)

      DisplayItemDetails item ->
        let 
          updatedItem = {item | displayDetails = not item.displayDetails}         
          updatedItems = RemoteData.map (updateItemInItems updatedItem) model.items            
        in                              
          ({model | items = updatedItems}, Cmd.none)

      OnEditItemInput itemName ->
        ({ model | newItemName = itemName }, Cmd.none)

      OnNewItemInput itemName ->
        ({ model | newItemName = itemName }, Cmd.none)

      OnNewItemKeyDown key ->
        if key == 13 then
          ({ model | newItemName = ""}, Commands.addItem model.selectedChecklist.id model.newItemName)
        else
          (model, Cmd.none)

      Msgs.ToggleItemCompleted item ->
        (model, Commands.updateChecklistItem {item | completed = not item.completed })

      Msgs.UpdatedItem item ->
        (model, Commands.fetchChecklistItems model.selectedChecklist)

      OnSaveChecklist projectId->
        (model, Commands.fetchProjectChecklists model.selectedProject)

      OnSaveItem checklistId->
        (model, Commands.fetchChecklistItems model.selectedChecklist)

      OnNewProjectInput projectName ->
        ({ model | newProjectName = projectName }, Cmd.none)

      OnFetchProjects response ->
        ({model | projects = response}, Cmd.none)

      OnFetchProjectChecklists response ->
        ({model | checklists = response}, Cmd.none)

      OnFetchChecklistItems response ->
        ({model | items = response}, Cmd.none)

      GetProjects ->
        (model, Commands.fetchProjects )

      OnSaveProject projectId->
        (model, Commands.fetchProjects)

      RemoveProject project ->
        (model, Commands.deleteProject project)

      RemoveItem item ->
        (model, Commands.deleteItem item)

      DeletedItem _ ->
        (model, Commands.fetchChecklistItems model.selectedChecklist)

      DeleteProject (Ok projectName)->
        (model, Commands.fetchProjects)

      DeletedChecklist (Ok checklistName) ->
        (model, Commands.fetchProjectChecklists model.selectedProject)

      DeletedChecklist (Err error) ->
        (model, Commands.fetchProjectChecklists model.selectedProject)

      DeleteProject (Err error)->
        (model, Cmd.none)

      SelectProject project ->
        ({model | route = ProjectRoute project.id, selectedProject = project}, Commands.fetchProjectChecklists project)

      SelectChecklist checklist ->
        ({model | route = ChecklistRoute checklist.id, selectedChecklist = checklist}, Commands.fetchChecklistItems checklist)

      RemoveChecklist checklist ->
        (model, Commands.deleteChecklist checklist)

      OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )


updateItemInItems : Item -> List Item -> List Item
updateItemInItems itemToUpdate items  =
  let    
    replace item =       
      if item.id == itemToUpdate.id then
        itemToUpdate
      else
        item
  in
    List.map replace items

updateElement : List Item -> Item -> List Item
updateElement list itemToToggle =
  let
    toggle item =
      if item.id == itemToToggle.id then
        { item | completed = not item.completed }
      else
        item
  in
    List.map toggle list


onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
  on "keydown" (Json.map tagger keyCode)


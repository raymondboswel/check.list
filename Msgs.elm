module Msgs exposing (..)
import Http exposing (..)
import RemoteData exposing (WebData)
import Models exposing (..)
import Navigation exposing (Location)

type Msg = 
           RemoveProject Project | 
           RemoveChecklist Checklist | 
           SelectProject Project |
           OnSaveProject (Result Http.Error Int)| 
           DeleteProject (Result Http.Error String) |
           DeletedChecklist (Result Http.Error String) | 
           OnNewProjectKeyDown Int | 
           OnNewProjectInput String | 
           OnNewChecklistKeyDown Int | 
           OnNewChecklistInput String |
           GetProjects | 
           OnLocationChange Location |
           OnFetchProjects (WebData (List Project)) |
           OnFetchProjectChecklists (WebData (List Checklist))
module Msgs exposing (..)
import Http exposing (..)
import RemoteData exposing (WebData)
import Models exposing (..)

type Msg = 
           RemoveProject Project | 
           RemoveChecklist Checklist | 
           ExpandProject String |
           OnSaveProject (Result Http.Error Int)| 
           DeleteProject (Result Http.Error String) | 
           OnNewProjectKeyDown Int | 
           OnNewProjectInput String | 
           OnNewChecklistKeyDown Int | 
           OnNewChecklistInput String |
           GetProjects | 
           OnFetchProjects (WebData (List Project))
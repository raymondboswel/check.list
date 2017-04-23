module Msgs exposing (..)
import Http exposing (..)
import RemoteData exposing (WebData)
import Models exposing (..)

type Msg = 
        --    RemoveProject Project | 
           ExpandProject String |
           OnSaveProject (Result Http.Error Int)| 
        --    DeleteProject (Result Http.Error String) | 
           KeyDown Int | 
           Input String | 
           GetProjects | 
           OnFetchProjects (WebData (List Project))
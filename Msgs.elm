module Msgs exposing (..)
import Http exposing (..)

type Msg = RemoveProject String | 
           ExpandProject String |
           AddProject (Result Http.Error Int) | 
           DeleteProject (Result Http.Error String) | 
           KeyDown Int | 
           Input String | 
           GetProjects | 
           AllProjects (Result Http.Error (List String))
module Projects.Models exposing (..)
import RemoteData exposing (WebData)

type alias Projects = {projects : WebData (List Project), newProjectName : Project}

type alias Project = String
module Routing exposing (..)

import Navigation exposing (Location)
import Models exposing (ProjectId, Route(..))
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ 
          map SignInRoute top
        , map ProjectRoute (s "projects" </> int)
        , map ProjectsRoute (s "projects")
        , map ChecklistRoute (s "checklists" </> int)
        
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route
        Nothing ->
            NotFoundRoute
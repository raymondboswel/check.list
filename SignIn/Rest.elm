module SignIn.Rest exposing (..)
import Msgs exposing (..)
import Http exposing (..)
import Models exposing (..)
import SignIn.Types exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode exposing (..)
import Json.Decode.Pipeline exposing (decode, required)
import RemoteData exposing (..)

signIn : String -> String -> Cmd SignIn.Types.Msg
signIn email password =
  let
    url =
      "http://localhost:4000/api/users/sign_in"
    body =
          checklistEncoder email password |> Http.jsonBody
  in
    Http.post url body userAuthDecoder
    |> Http.send SignIn.Types.SignedIn
checklistEncoder : String -> String -> Encode.Value
checklistEncoder email password =
    Encode.object
        [ ("email", Encode.string email),
          ("password", Encode.string password )
        ]

userAuthDecoder : Decode.Decoder UserAuth
userAuthDecoder =
    decode UserAuth
        |> required "user_id" Decode.int
        |> required "jwt" Decode.string
        |> required "exp" Decode.int
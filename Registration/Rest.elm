module Registration.Rest exposing (..)
import Msgs exposing (..)
import Http exposing (..)
import Models exposing (..)
import Registration.Types exposing (..)
import SignIn.Types exposing (UserAuth)
import Json.Decode as Decode
import Json.Encode as Encode exposing (..)
import Json.Decode.Pipeline exposing (decode, required)
import RemoteData exposing (..)

register : String -> String -> String -> Cmd Registration.Types.Msg
register api email password =
  let
      url =
        api ++ "/api/users/"
      body =
            authEncoder email password |> Http.jsonBody
    in
      Http.post url body userAuthDecoder
      |> Http.send Registration.Types.Registered

authEncoder : String -> String -> Encode.Value
authEncoder email password =
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
module SignIn.Rest exposing (..)
import Msgs exposing (..)
import Http exposing (..)
import Models exposing (..)
import SignIn.Types exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode exposing (..)
import Json.Decode.Pipeline exposing (decode, required)
import RemoteData exposing (..)

signIn : Models.Model -> String -> String -> Cmd SignIn.Types.Msg
signIn model email password =
  let
    url =
      model.api ++ "/api/users/sign_in"
    body =
          authEncoder email password |> Http.jsonBody
  in
    Http.post url body userAuthDecoder
    |> Http.send SignIn.Types.SignedIn

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
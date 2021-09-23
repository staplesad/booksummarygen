module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Http
import String exposing(split, join, replace)

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL

type Status =
  Blank
  | Failure
  | Generating
  | Success String

type alias Model
  = { status: Status
    , seed: String
    }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model Blank placeholder_txt, Cmd.none)



-- UPDATE


type Msg
  = GetBook
  | Seed String
  | GotGenerated (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetBook -> ({model | status = Generating},
                Http.get
                { url = "/gen/" ++ model.seed
                , expect = Http.expectString GotGenerated})
    Seed new_seed ->
      ({model | seed = new_seed}, Cmd.none)
    GotGenerated result ->
      case result of
        Ok fullText ->
          ({model | status = Success fullText}, Cmd.none)

        Err _ ->
          ({model | status = Failure}, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW
placeholder_txt : String
placeholder_txt = "A Brave New Universe."

view : Model -> Html Msg
view model =
    case model.status of
      Blank ->
        div[][
          div [] [text "Start generating a story summary: "]
          , input [type_ "title", placeholder placeholder_txt, value model.seed, onInput Seed] []
          -- adding inputs to allow customisation of the model vars
          , input [type_ "top_p", placeholder ""] []
          , button [onClick GetBook] [text "Generate!"]
          ]

      Failure ->
        text "I was unable to load the generated text."

      Generating ->
        text "Loading..."

      Success fullText ->
        div [] [
          h2 [] [text "Generated story summary"]
          , p [] [ text (formatText fullText) ]
          ]

formatText : String -> String
formatText text = join ".\n" (split "." (replace "<|endoftext|>" "" text))


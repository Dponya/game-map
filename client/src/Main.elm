module Main exposing(..)

import Browser
import Html exposing(Html)
import Color exposing (black)
import Collage exposing (..)
import Collage.Layout exposing (at, base)
import Collage.Render exposing (svg)
import Json.Decode exposing (field, Decoder, map2, float, list)
import Http

main : Program String Model Msg
main = Browser.element
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

type alias Entity = { x : Float, y : Float }

type alias GameMap =
  { size : Float
  , entities : List Entity
  }

type Model
  = Success GameMap
  | Failure

entityDecoder : Decoder (List Entity)
entityDecoder = list
  (map2 Entity
    (field "x" float)
    (field "y" float)
  )

gameMapDecoder : Decoder GameMap
gameMapDecoder = map2 GameMap
  (field "size" float)
  (field "entities" entityDecoder)

-- UPDATE

type Msg = GotMap (Result Http.Error GameMap)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotMap res ->
      case res of
        Ok newModel -> (Success newModel, Cmd.none)
        Err err -> let _ = Debug.log "err map get" err in (Failure, Cmd.none)

-- INITIAL MODEL

init : String -> (Model, Cmd Msg)
init host =
  ( Success (GameMap 0 [])
  , Http.request 
      { url = host
      , expect = Http.expectJson GotMap gameMapDecoder 
      , method = "GET"
      , headers = [Http.header "Token" "12345"]
      , body = Http.emptyBody
      , timeout = Nothing
      , tracker = Nothing
      }
  )

-- VIEW

view : Model -> Html Msg
view model = case model of
  Success gameMap -> render gameMap
  Failure -> Html.text "Failure"

render : GameMap -> Html msg
render gameMap =
  let
    circ =
        circle 30
            |> filled (uniform Color.red)
    entityToCollage : List Entity -> Collage msg -> Collage msg
    entityToCollage ess rect1 = case ess of
      [] -> rect1
      (e::es) -> rect1
          |> at base (shift (e.x, e.y) circ)
          |> entityToCollage es
    in entityToCollage gameMap.entities circ |> svg

-- SUBSCRIPTIONS

subscriptions model =
    Sub.none
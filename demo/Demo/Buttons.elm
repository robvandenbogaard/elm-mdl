module Demo.Buttons where

import Html exposing (..)
import Html.Attributes exposing (..)
import Effects exposing (Effects)
import String
import Signal exposing (Address)

import Material.Button as Button exposing (..)
import Material.Grid as Grid
import Material.Icon as Icon
import Material.Options as Options exposing (Style)
import Material.Helpers exposing (map1st, map2nd)
import Material

import Demo.Code as Code
import Demo.Page as Page


-- MODEL


type alias Index = 
  List Int


type Misc 
  = Default | Ripple | Disabled


type Color 
  = Plain | Colored


type Kind 
  = Flat | Raised | FAB | MiniFAB | Icon 


type alias Model = 
  { last : Maybe (Kind, Color, Misc)
  , mdl : Material.Model
  , code : Code.Model
  }


model : Model
model = 
  { last = Nothing
  , mdl = Material.model
  , code = Code.model
  }


-- ACTION/UPDATE


type Action 
  = Click (Kind, Color, Misc)
  | Mdl (Material.Action Action)
  | Code Code.Action


update : Action -> Model -> (Model, Effects Action)
update action model = 
  case action of 
    Mdl action' -> 
      Material.update Mdl action' model

    Code action' -> 
      Code.update action' model.code
        |> map1st (\code' -> { model | code = code' })
        |> map2nd (Effects.map Code)

    Click last -> 
      let
        (code', fx) = 
          Code.update (Code.Set (program last)) model.code
      in
        ( { model 
          | last = Just last 
          , code = code'
          }
        , Effects.map Code fx
        )


-- VIEW


miscs : List Misc
miscs = 
  [ Default, Ripple, Disabled ]


colors : List Color
colors = 
  [ Plain, Colored ]


kinds : List Kind
kinds = 
  [ Flat, Raised, FAB, MiniFAB, Icon ]


describe : (Kind, Color, Misc) -> String
describe (kind, color, misc) = 
  [ case kind of 
      Flat -> "flat"
      Raised -> "raised"
      FAB -> "fab"
      MiniFAB -> "mini-fab"
      Icon -> "icon"
  , case color of 
      Plain -> "plain"
      Colored -> "colored"
  , case misc of
      Ripple -> "w/ripple"
      Disabled -> "disabled"
      Default -> ""
  ]
    |> List.filter ((/=) "")
    |> String.join " "


program : (Kind, Color, Misc) -> String
program (kind, color, misc) = 
  let 
    options = 
      [ case kind of 
          Flat -> ""
          Raised -> "raised"
          FAB -> "fab"
          MiniFAB -> "minifab"
          Icon -> "icon"
      , case color of 
          Plain -> ""
          Colored -> "colored"
      , case misc of
          Ripple -> "ripple"
          Disabled -> "disabled"
          Default -> ""
      , "onClick addr MyClickAction"
      ] 
      |> List.filter ((/=) "")
      |> List.map ((++) "Button.")
      |> String.join "\n  , "
    contents = 
      case kind of
        Flat -> "text \"Flat button\""
        Raised -> "text \"Raised button\""
        FAB -> "Icon.i \"add\""
        MiniFAB -> "Icon.i \"zoom_in\""
        Icon -> "Icon.i \"flight_land\""
  in
    """Button.render Mdl [0] addr model.mdl
  [ """ ++ options ++ """
  ]
  [ """ ++ contents ++ "]"


indexedConcat : (Int -> a -> List b) -> List a -> List b
indexedConcat f xs = 
  List.indexedMap f xs
    |> List.concat


viewButtons : Address Action -> Model -> List (Grid.Cell)
viewButtons addr model =
  kinds |> indexedConcat (\idx0 kind -> 
  colors |> indexedConcat (\idx1 color -> 
  miscs |> List.indexedMap (\idx2 misc -> 
    Grid.cell
      [ Grid.size Grid.All 2]
      [ div
          [ style
            [ ("text-align", "center")
            , ("margin-top", ".6em")
            , ("margin-bottom", ".6em")
            ]
          ]
          [ Button.render Mdl [idx0, idx1, idx2] addr model.mdl
              [ case kind of 
                  Flat -> Button.flat
                  Raised -> Button.raised
                  FAB -> Button.fab
                  MiniFAB -> Button.minifab
                  Icon -> Button.icon
              , case color of 
                  Plain -> Button.plain
                  Colored -> Button.colored
              , case misc of
                  Disabled -> Button.disabled
                  Ripple -> Button.ripple
                  Default -> Options.nop
              , Button.onClick addr (Click (kind, color, misc))
              ]
              [ case kind of
                  Flat -> text "Flat button"
                  Raised -> text "Raised button"
                  FAB -> Icon.i "add"
                  MiniFAB -> Icon.i "zoom_in"
                  Icon -> Icon.i "flight_land"
              ]
          , div
              [ style
                [ ("font-size", "9pt")
                , ("margin-top", ".6em")
                ]
              ]
              [ text <| describe (kind, color, misc) ]
          ]
      ]
  )))


view : Address Action -> Model -> Html
view addr model = 
  Page.body2 "Buttons" srcUrl intro references  
    [ p [] 
        [ text """Various combinations of colors and button styles can be seen
                  below. Most buttons have animations; try clicking. Code for the
                  last clicked button appears below the buttons."""
        ]
    , Grid.grid [] (viewButtons addr model)
    , p []
        [ model.last 
           |> Maybe.map describe 
           |> Maybe.map (\str -> "Code for '" ++ str ++ "':")
           |> Maybe.withDefault "Click a button to see the corresponding code."
           |> text
        , Code.view (Signal.forwardTo addr Code) model.code
        ]
    ] 


intro : Html
intro =
  Page.fromMDL "https://www.getmdl.io/components/#buttons-section" """
> The Material Design Lite (MDL) button component is an enhanced version of the
> standard HTML `<button>` element. A button consists of text and/or an image that
> clearly communicates what action will occur when the user clicks or touches it.
> The MDL button component provides various types of buttons, and allows you to
> add both display and click effects.
>
> Buttons are a ubiquitous feature of most user interfaces, regardless of a
> site's content or function. Their design and use is therefore an important
> factor in the overall user experience. See the button component's Material
> Design specifications page for details.
>
> The available button display types are flat (default), raised, fab, mini-fab,
> and icon; any of these types may be plain (light gray) or colored, and may be
> initially or programmatically disabled. The fab, mini-fab, and icon button
> types typically use a small image as their caption rather than text.

"""

srcUrl : String
srcUrl = 
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Buttons.elm"

references : List (String, String)
references = 
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Button"
  , Page.mds "https://www.google.com/design/spec/components/buttons.html"
  , Page.mdl "https://www.getmdl.io/components/#buttons-section"
  ]

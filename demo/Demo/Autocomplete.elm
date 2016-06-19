module Demo.Autocomplete exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Material.Autocomplete as Autocomplete
import Material
import Demo.Page as Page


-- MODEL


type alias Mdl =
    Material.Model


type alias Model =
    { mdl : Material.Model
    }


model : Model
model =
    { mdl = Material.model
    }



-- ACTION, UPDATE


type Msg
    = AutocompleteMsg
    | Mdl Material.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        AutocompleteMsg ->
            ( model, Cmd.none )

        Mdl action' ->
            Material.update Mdl action' model



-- VIEW


view : Model -> Html Msg
view model =
    [ div []
        [ Autocomplete.render Mdl [ 0 ] model.mdl [] []
        ]
    ]
        |> Page.body2 "AUTOCOMPLETE" srcUrl intro references


intro : Html m
intro =
    Page.fromMDL "https://www.getmdl.io/components/index.html#AUTOCOMPLETE-section" """
> ...
"""


srcUrl : String
srcUrl =
    "https://github.com/debois/elm-mdl/blob/master/demo/Demo/AUTOCOMPLETE.elm"


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-AUTOCOMPLETE"
    , Page.mds "https://www.google.com/design/spec/components/AUTOCOMPLETE.html"
    , Page.mdl "https://www.getmdl.io/components/index.html#AUTOCOMPLETE"
    ]

module Material.Autocomplete
    exposing
        ( Model
        , defaultModel
        , Msg
        , update
        , view
        , Property
        , render
        )

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#AUTOCOMPLETE-section):

> ...

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/AUTOCOMPLETE.html).

Refer to [this site](http://debois.github.io/elm-mdl#/template)
for a live demo.

@docs Model, model, Msg, update
@docs view

# Component support

@docs Container, Observer, Instance, instance, fwdAutocomplete
-}

-- AUTOCOMPLETE. Copy this to a file for your component, then update.

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.App as App
import Parts exposing (Indexed)
import Material.Options as Options exposing (Style, cs)
import Autocomplete exposing (Autocomplete)
import Autocomplete.Config


-- MODEL


{-| Component model.
-}
type alias Model =
    { autocomplete : Autocomplete }


{-| Default component model constructor.
-}
defaultModel : Model
defaultModel =
    { autocomplete = Autocomplete.init [] }



-- ACTION, UPDATE


{-| Component action.
-}
type Msg
    = UpdateAutocomplete Autocomplete.Msg


{-| Component update.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateAutocomplete msg ->
            let
                ( autocomplete, status ) =
                    Autocomplete.update msg model.autocomplete
            in
                { model | autocomplete = autocomplete } ! [ Cmd.none ]



-- PROPERTIES


type alias Config =
    { autocomplete : Autocomplete.Config.Config Msg }


defaultConfig : Config
defaultConfig =
    { autocomplete = Autocomplete.Config.defaultConfig }


type alias Property m =
    Options.Property Config m



{- See src/Material/Button.elm for an example of, e.g., an onClick handler. -}
-- VIEW


{-| Component view.
-}
view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html a
view lift model options elems =
    Options.div
        (cs "AUTOCOMPLETE"
            :: options
        )
        [ h6 [] [ text "AUTOCOMPLETE COMPONENT" ]
        , App.map UpdateAutocomplete (Autocomplete.view model.autocomplete)
        ]



-- COMPONENT


type alias Container c =
    { c | autocomplete : Indexed Model }


{-| Component render.
-}
render :
    (Parts.Msg (Container c) -> m)
    -> Parts.Index
    -> Container c
    -> List (Property m)
    -> List (Html m)
    -> Html m
render =
    Parts.create view update .autocomplete (\x y -> { y | autocomplete = x }) defaultModel



{- See src/Material/Layout.mdl for how to add subscriptions. -}

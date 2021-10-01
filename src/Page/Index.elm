module Page.Index exposing (Data, Model, Msg, page)

import Browser.Navigation exposing (Key)
import DataSource exposing (DataSource)
import DataSource.File
import Head
import Head.Seo as Seo
import Html
import OptimizedDecoder
import Page exposing (PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)


type alias Model =
    List Item


type alias Msg =
    Never


type alias RouteParams =
    {}


page : PageWithState RouteParams Data Model Msg
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildWithLocalState
            { view = view
            , update = update
            , subscriptions = \_ _ _ _ -> Sub.none
            , init = init
            }


init : Maybe PageUrl -> Shared.Model -> StaticPayload Data RouteParams -> ( Model, Cmd Msg )
init _ _ static =
    ( static.data, Cmd.none )


update : PageUrl -> Maybe Key -> Shared.Model -> StaticPayload Data RouteParams -> Msg -> Model -> ( Model, Cmd Msg )
update _ _ _ _ _ model =
    ( model, Cmd.none )


data : DataSource Data
data =
    DataSource.File.jsonFile (OptimizedDecoder.list decoder) "data/items.json"


decoder : OptimizedDecoder.Decoder Item
decoder =
    OptimizedDecoder.map2 Item
        (OptimizedDecoder.field "id" OptimizedDecoder.string)
        (OptimizedDecoder.field "name" OptimizedDecoder.string)


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Item =
    { id : String
    , name : String
    }


type alias Data =
    List Item


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ model _ =
    { title = "elm-pages bug"
    , body =
        [ model
            |> List.map itemView
            |> Html.div []
        ]
    }


itemView : Item -> Html.Html Msg
itemView { id, name } =
    Html.div
        []
        [ Html.text id, Html.text name ]

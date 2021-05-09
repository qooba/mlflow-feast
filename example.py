# This is an example feature definition file

from google.protobuf.duration_pb2 import Duration

from feast import Entity, Feature, FeatureView, ValueType
from feast.data_source import FileSource

# Read data from parquet files. Parquet is convenient for local development mode. For
# production, you can use your favorite DWH, such as BigQuery. See Feast documentation
# for more info.
propensity_data = FileSource(
    path="s3://propensity/training_sample.parquet",
    event_timestamp_column="datetime",
    created_timestamp_column="created",
)

# Define an entity for the driver. You can think of entity as a primary key used to
# fetch features.
user = Entity(name="UserID", value_type=ValueType.STRING, description="user id",)


Feature(name="basket_icon_click"           , dtype=ValueType.DOUBLE),
Feature(name="basket_add_list"             , dtype=ValueType.DOUBLE),
Feature(name="basket_add_detail"           , dtype=ValueType.DOUBLE),
Feature(name="sort_by"                     , dtype=ValueType.DOUBLE),
Feature(name="image_picker"                , dtype=ValueType.DOUBLE),
Feature(name="account_page_click"          , dtype=ValueType.DOUBLE),
Feature(name="promo_banner_click"          , dtype=ValueType.DOUBLE),
Feature(name="detail_wishlist_add"         , dtype=ValueType.DOUBLE),
Feature(name="list_size_dropdown"          , dtype=ValueType.DOUBLE),
Feature(name="closed_minibasket_click"     , dtype=ValueType.DOUBLE),
Feature(name="checked_delivery_detail"     , dtype=ValueType.DOUBLE),
Feature(name="checked_returns_detail"      , dtype=ValueType.DOUBLE),
Feature(name="sign_in"                     , dtype=ValueType.DOUBLE),
Feature(name="saw_checkout"                , dtype=ValueType.DOUBLE),
Feature(name="saw_sizecharts"              , dtype=ValueType.DOUBLE),
Feature(name="saw_delivery"                , dtype=ValueType.DOUBLE),
Feature(name="saw_account_upgrade"         , dtype=ValueType.DOUBLE),
Feature(name="saw_homepage"                , dtype=ValueType.DOUBLE),
Feature(name="device_mobile"               , dtype=ValueType.DOUBLE),
Feature(name="device_computer"             , dtype=ValueType.DOUBLE),
Feature(name="device_tablet"               , dtype=ValueType.DOUBLE),
Feature(name="returning_user"              , dtype=ValueType.DOUBLE),
Feature(name="loc_uk"                      , dtype=ValueType.DOUBLE),
Feature(name="ordered"                     , dtype=ValueType.DOUBLE)


propensity_view = FeatureView(
    name="propensity_data",
    entities=["UserID"],
    ttl=Duration(seconds=86400 * 100),
    features=[
        Feature(name="basket_icon_click"           , dtype=ValueType.DOUBLE),
        Feature(name="basket_add_list"             , dtype=ValueType.DOUBLE),
        Feature(name="basket_add_detail"           , dtype=ValueType.DOUBLE),
        Feature(name="sort_by"                     , dtype=ValueType.DOUBLE),
        Feature(name="image_picker"                , dtype=ValueType.DOUBLE),
        Feature(name="account_page_click"          , dtype=ValueType.DOUBLE),
        Feature(name="promo_banner_click"          , dtype=ValueType.DOUBLE),
        Feature(name="detail_wishlist_add"         , dtype=ValueType.DOUBLE),
        Feature(name="list_size_dropdown"          , dtype=ValueType.DOUBLE),
        Feature(name="closed_minibasket_click"     , dtype=ValueType.DOUBLE),
        Feature(name="checked_delivery_detail"     , dtype=ValueType.DOUBLE),
        Feature(name="checked_returns_detail"      , dtype=ValueType.DOUBLE),
        Feature(name="sign_in"                     , dtype=ValueType.DOUBLE),
        Feature(name="saw_checkout"                , dtype=ValueType.DOUBLE),
        Feature(name="saw_sizecharts"              , dtype=ValueType.DOUBLE),
        Feature(name="saw_delivery"                , dtype=ValueType.DOUBLE),
        Feature(name="saw_account_upgrade"         , dtype=ValueType.DOUBLE),
        Feature(name="saw_homepage"                , dtype=ValueType.DOUBLE),
        Feature(name="device_mobile"               , dtype=ValueType.DOUBLE),
        Feature(name="device_computer"             , dtype=ValueType.DOUBLE),
        Feature(name="device_tablet"               , dtype=ValueType.DOUBLE),
        Feature(name="returning_user"              , dtype=ValueType.DOUBLE),
        Feature(name="loc_uk"                      , dtype=ValueType.DOUBLE),
        Feature(name="ordered"                     , dtype=ValueType.DOUBLE)
    ],
    online=True,
    input=propensity_data,
    tags={},
)

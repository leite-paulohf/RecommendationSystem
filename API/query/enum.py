from enum import Enum


class Query(Enum):
    client = 'query/api/client.sql'
    search_client = 'query/api/search_client.sql'
    create_client = 'query/api/register.sql'
    usages = 'query/api/usages.sql'
    create_usage = 'query/api/create_usage.sql'
    favorites = 'query/api/favorites.sql'
    add_favorite = 'query/api/add_favorite.sql'
    remove_favorite = 'query/api/remove_favorite.sql'
    restaurant = 'query/api/restaurant.sql'
    restaurants = 'query/api/restaurants.sql'
    recommendations = 'query/api/recommendations.sql'


class PrivateQuery(Enum):
    usages = 'query/private/usages.sql'
    favorites = 'query/private/favorites.sql'
    restaurants = 'query/private/restaurants.sql'

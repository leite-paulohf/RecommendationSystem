SELECT restaurants.id,
       restaurants.name,
       restaurants.address,
       restaurants.latitude,
       restaurants.longitude,
       restaurants.accept_holidays,
       restaurants.average_cost,
       restaurants.average_rating,
       restaurants.has_wifi,
       restaurants.chairs,
       restaurants.city_id,
       cities.name AS city_name,
       restaurants.neighborhood_id,
       neighborhoods.name AS neighborhood_name,
       restaurants.kind_id,
       kind.name AS kind_name,
       restaurants.cuisine_id,
       cuisines.name AS cuisine_name,
       restaurants.category_id,
       categories.name AS category_name,
       restaurants.moment_id,
       moments.name AS moment_name,
       restaurants.offer_id,
       offers.discount,
       offers.restrictions,
       offers.benefits
FROM restaurants
INNER JOIN cities ON cities.id == restaurants.city_id
INNER JOIN neighborhoods ON neighborhoods.id == restaurants.neighborhood_id
INNER JOIN kind ON kind.id == restaurants.kind_id
INNER JOIN cuisines ON cuisines.id == restaurants.cuisine_id
INNER JOIN categories ON categories.id == restaurants.category_id
INNER JOIN moments ON moments.id == restaurants.moment_id
INNER JOIN offers ON offers.id == restaurants.offer_id
WHERE restaurants.city_id == :city_id
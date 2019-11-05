select
  restaurants.id,
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
  cities.name as city_name,
  restaurants.neighborhood_id,
  neighborhoods.name as neighborhood_name,
  restaurants.kind_id,
  kind.name as kind_name,
  restaurants.cuisine_id,
  cuisines.name as cuisine_name,
  restaurants.category_id,
  categories.name as category_name,
  restaurants.moment_id,
  moments.name as moment_name,
  restaurants.offer_id,
  offers.discount,
  offers.restrictions,
  offers.benefits
from
  restaurants
  inner join cities on cities.id == restaurants.city_id
  inner join neighborhoods on neighborhoods.id == restaurants.neighborhood_id
  inner join kind on kind.id == restaurants.kind_id
  inner join cuisines on cuisines.id == restaurants.cuisine_id
  inner join categories on categories.id == restaurants.category_id
  inner join moments on moments.id == restaurants.moment_id
  inner join offers on offers.id == restaurants.offer_id
where
  restaurants.id == :restaurant_id

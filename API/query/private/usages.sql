select
  restaurants.id,
  accept_holidays,
  average_cost,
  average_rating,
  benefits,
  category_id,
  chairs,
  cuisine_id,
  discount,
  has_wifi,
  kind_id,
  latitude,
  longitude,
  moment_id,
  neighborhood_id,
  restrictions,
  offer_id
from
  restaurants
  inner join offers on offers.id == restaurants.offer_id
where
  restaurants.id in (
    select
      restaurant_id
    from
      usages
    where
      client_id == :client_id
  )

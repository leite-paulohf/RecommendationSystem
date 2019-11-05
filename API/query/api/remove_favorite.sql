delete from
  favorites
where
  client_id == :client_id
  and restaurant_id == :restaurant_id
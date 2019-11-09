update clients
set name = :name,
    cpf = :cpf,
    city_id = :city_id,
    password = :password
where
    clients.cpf == :cpf
select
  *
from
  clients
where
  cpf == :cpf
  and password == :password
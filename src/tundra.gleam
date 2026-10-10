import envoy
import gleam/erlang/process
import gleam/result
import mist
import pog
import tundra/router
import wisp
import wisp/wisp_mist

pub fn main() -> Nil {
  wisp.configure_logger()
  let db_pool_name = process.new_name("db_pool")
  let database_url = case envoy.get("DATABASE_URL") {
    Ok(database_url) -> database_url
    Error(_) -> "postgres://gleam:gleam@localhost:5432/gleamdb"
  }
  let assert Ok(pog_config) = pog.url_config(db_pool_name, database_url)
  let assert Ok(_) = pog_config |> pog.pool_size(10) |> pog.start
  let connection = pog.named_connection(db_pool_name)
  let context = router.Context(connection)

  let secret =
    result.unwrap(envoy.get("SECRET_KEY_BASE"), "wisp_secret_fallback")
  let handler = router.handle_request(_, context)
  let assert Ok(_) =
    wisp_mist.handler(handler, secret)
    |> mist.new
    |> mist.port(8000)
    |> mist.start
  process.sleep_forever()
}

import envoy
import gleam/erlang/process
import gleam/result
import lib/router
import mist
import wisp
import wisp/wisp_mist

pub fn main() -> Nil {
  wisp.configure_logger()
  let secret =
    result.unwrap(envoy.get("SECRET_KEY_BASE"), "wisp_secret_fallback")
  let assert Ok(_) =
    wisp_mist.handler(router.handle_request, secret)
    |> mist.new
    |> mist.port(8000)
    |> mist.start
  process.sleep_forever()
}

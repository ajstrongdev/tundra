import gleam/http
import gleam/http/response
import wisp

fn health_check() -> response.Response(wisp.Body) {
  wisp.json_response("{\"status\": \"ok\"}", 200)
}

pub fn handler(req: wisp.Request) -> wisp.Response {
  case req.method {
    http.Get -> health_check()
    _ -> wisp.method_not_allowed([http.Get])
  }
}

import pog
import tundra/handler/health
import wisp.{type Request, type Response}

pub type Context {
  Context(db: pog.Connection)
}

pub fn handle_request(req: Request, _ctx: Context) -> Response {
  case wisp.path_segments(req) {
    ["health"] -> health.handler(req)
    _ -> wisp.not_found()
  }
}

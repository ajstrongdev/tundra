import lib/handlers/issues
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  case wisp.path_segments(req) {
    ["issues"] -> issues.issues_handler(req)
    ["issues", id] -> issues.issue_handler(req, id)
    _ -> wisp.not_found()
  }
}

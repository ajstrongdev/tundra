import lib/handler/issue
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  case wisp.path_segments(req) {
    ["issues"] -> issue.issues_handler(req)
    ["issues", id] -> issue.issue_handler(req, id)
    _ -> wisp.not_found()
  }
}

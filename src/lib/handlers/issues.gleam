import gleam/http
import gleam/json
import gleam/option
import gleam/time/calendar
import gleam/time/timestamp
import wisp.{type Request, type Response}
import youid/uuid

// Types
type IssueItem {
  IssueItem(
    id: uuid.Uuid,
    title: String,
    description: option.Option(String),
    status: String,
    created_at: timestamp.Timestamp,
    updated_at: timestamp.Timestamp,
  )
}

// Utils
fn timestamp_to_json(stamp: timestamp.Timestamp) {
  json.string(timestamp.to_rfc3339(stamp, calendar.utc_offset))
}

fn issue_to_json(item: IssueItem) {
  json.object([
    #("id", json.string(uuid.to_string(item.id))),
    #("title", json.string(item.title)),
  ])
}

// Impl
fn delete_issue(_id) {
  wisp.no_content()
}

fn get_issue(id) {
  wisp.string_body(wisp.ok(), "Returned issue: " <> id)
}

fn get_issues() {
  wisp.string_body(wisp.ok(), "Issues:")
}

fn post_issues() {
  wisp.created()
}

// Handlers
pub fn issue_handler(req: Request, id) -> Response {
  case req.method {
    http.Get -> get_issue(id)
    http.Delete -> delete_issue(id)
    _ -> wisp.method_not_allowed([http.Get, http.Delete])
  }
}

pub fn issues_handler(req: Request) -> Response {
  case req.method {
    http.Get -> get_issues()
    http.Post -> post_issues()
    _ -> wisp.method_not_allowed([http.Get, http.Post])
  }
}

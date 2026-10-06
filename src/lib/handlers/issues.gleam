import gleam/dynamic/decode
import gleam/http
import gleam/json
import gleam/option
import gleam/result
import gleam/time/calendar
import gleam/time/timestamp
import wisp.{type Request, type Response}
import youid/uuid

// Types
type IssueStatus {
  Planned
  Todo
  InProgress
  Review
  Done
  Cancelled
}

type IssueItem {
  IssueItem(
    id: uuid.Uuid,
    title: String,
    description: option.Option(String),
    status: IssueStatus,
    created_at: timestamp.Timestamp,
    updated_at: timestamp.Timestamp,
  )
}

// Utils
fn timestamp_to_json(stamp: timestamp.Timestamp) {
  json.string(timestamp.to_rfc3339(stamp, calendar.utc_offset))
}

fn issue_status_to_string(status: IssueStatus) {
  case status {
    Planned -> "Planned"
    Todo -> "Todo"
    InProgress -> "In Progress"
    Review -> "Review"
    Done -> "Done"
    Cancelled -> "Cancelled"
  }
}

fn issue_to_json(item: IssueItem) {
  json.object([
    #("id", json.string(uuid.to_string(item.id))),
    #("title", json.string(item.title)),
    #("description", json.string(option.unwrap(item.description, ""))),
    #("status", json.string(issue_status_to_string(item.status))),
    #("created_at", timestamp_to_json(item.created_at)),
    #("updated_at", timestamp_to_json(item.updated_at)),
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

fn post_issues(req: Request) {
  use json <- wisp.require_json(req)
  let result = {
    let decoder = {
      use title <- decode.field("title", decode.string)
      use description <- decode.optional_field("description", "", decode.string)
      decode.success(#(title, description))
    }
    use #(title, description) <- result.try(decode.run(json, decoder))

    let issue_item =
      IssueItem(
        uuid.v4(),
        title,
        option.Some(description),
        Planned,
        timestamp.from_unix_seconds(1_766_689_000),
        timestamp.from_unix_seconds(1_766_689_000),
      )
    Ok(
      issue_to_json(issue_item)
      |> json.to_string
      |> wisp.json_response(200),
    )
  }
  case result {
    Ok(res) -> res
    Error(_) -> wisp.unprocessable_content()
  }
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
    http.Post -> post_issues(req)
    _ -> wisp.method_not_allowed([http.Get, http.Post])
  }
}

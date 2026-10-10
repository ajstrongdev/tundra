import gleam/http
import gleeunit
import tundra/handler/health
import wisp/simulate

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn hello_world_test() {
  let name = "Joe"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Joe!"
}

pub fn get_health_test() {
  let response = health.handler(simulate.request(http.Get, "/health"))
  assert response.status == 200
  assert simulate.read_body(response) == "{\"status\": \"ok\"}"
}

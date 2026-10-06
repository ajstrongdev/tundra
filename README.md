# Tundra

Small product management software, written in Gleam.

## Development

Install Gleam and Erlang/OTP via Pacstall on Rhino Linux:

```sh
pacstall -I gleam-bin
```

When Pacstall prompts to install Erlang as an optional dependency, say yes.
Also install Podman with a Compose provider (`podman-compose`).
The local PostgreSQL service uses Podman's networking tools. On Rhino Linux
(Ubuntu-based), install the missing tools if Podman reports `nft: No such file
or directory` or `aardvark-dns binary not found`:

```sh
sudo apt install nftables aardvark-dns
```

From the project root, start PostgreSQL and then the Gleam server:

```sh
podman compose up -d
gleam run
```

The server listens on <http://localhost:8000>.

Run tests with `gleam test`. To stop PostgreSQL, run `podman compose down`;
this leaves the database volume intact.

### Purpose

To learn Gleam. 'Nuff said.

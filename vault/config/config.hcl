storage "file" {
  path = "/vault/data"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disabled = true # TLS is on Caddy side
}

ui = true
disabled_mlock = true

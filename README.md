# vps-infra

Docker Compose + Caddy stack for `*.okryshto.dev` on the VPS.

Third-party services only. Own application services (profile, orbit, vizitka,
docs) live in a separate repository under their own Docker Compose.

No CI at the moment — the previous GitHub Actions setup (digest-bump bot,
cross-repo dispatch from lokki, remote restart button) was removed on
2026-08-10 to be rebuilt from scratch. Everything below is what you run by hand.

## Layout

| Path                       | Role                                          |
| -------------------------- | --------------------------------------------- |
| `docker-compose.yml`       | Includes compose fragments                    |
| `compose/00-caddy.yml`     | Reverse proxy, ports 80/443                   |
| `compose/10-affine.yml`    | Affine + its Postgres/Redis                   |
| `compose/20-vault.yml`     | Vault                                         |
| `compose/30-wireguard.yml` | wg-easy                                       |
| `compose/40-ntfy.yml`      | ntfy                                          |
| `Caddyfile`                | Host → container routing for every domain     |
| `scripts/`                 | rsync to the VPS, Caddy restart, chown helper |

## Domains

| Host                           | Service      | Source        |
| ------------------------------ | ------------ | ------------- |
| `affine.okryshto.dev`          | `affine`     | third-party   |
| `vault.okryshto.dev`           | `vault`      | third-party   |
| `vpn.okryshto.dev`             | `wg-easy`    | third-party   |
| `ntfy.okryshto.dev`            | `ntfy`       | third-party   |
| `profile.okryshto.dev`         | `okryshto-caddy` | okryshto repo |
| `storybook.okryshto.dev`       | `okryshto-caddy` | okryshto repo |

## Operating the VPS

```bash
# Push local changes to the server (.env is excluded — edit it there by hand)
scripts/sync.sh

# On the VPS
cd ~/vps-infra
docker compose restart              # restart everything that is already up
docker compose restart caddy        # or a single service
docker compose pull && docker compose up -d   # after changing an image tag
```

`scripts/caddy.sh` restarts Caddy and tails its log.

## Deploy note

Nothing deploys itself. Changing an image tag in git does not touch the server
until you sync and bring the service up. Keep `.env` local to the VPS — the sync
helpers exclude it.

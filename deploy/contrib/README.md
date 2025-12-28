# Community Contributed Guides

These guides are **community-contributed** and cover integration with third-party
reverse proxy solutions. They may not be actively maintained by the PuzzleTime team.

## ⚠️ Disclaimer

- **Use at your own risk** — These guides may become outdated
- **Check official docs** — Always refer to the official documentation for each tool
- **Version-specific** — Examples were tested at a specific point in time

## Available Guides

| Guide | Description | Last Tested |
|-------|-------------|-------------|
| [Traefik](traefik.md) | Docker-native reverse proxy with automatic SSL | Dec 2024 |
| [Caddy](caddy.md) | Simple reverse proxy with automatic HTTPS | Dec 2024 |
| [Nginx](nginx.md) | Traditional reverse proxy | Dec 2024 |

## Official Documentation

For the official (maintained) deployment documentation, see:

- [Main README](../README.md) — Full deployment guide
- [Direct Access](../docs/direct-access.md) — Internal/homelab without reverse proxy
- [Reverse Proxy Requirements](../docs/reverse-proxy.md) — What any proxy needs to provide

## Contributing

Found an issue or want to improve a guide? PRs welcome!

When contributing, please:

1. Test your changes with a real deployment
2. Include the version of the tool you tested with
3. Update the "Last Tested" date
4. Keep guides minimal — focus on PuzzleTime-specific config
5. Link to official documentation for full setup instructions

## Adding a New Guide

Want to add support for another reverse proxy? Create a new file following this template:

```markdown
# [Tool Name] Integration

> **Community Contributed** — Last tested: [Month Year] with [Tool] v[X.X]
>
> For complete documentation, see [official docs](https://...)

## Requirements

- PuzzleTime running (see main README)
- [Tool] installed and configured

## PuzzleTime Configuration

[Minimal config specific to PuzzleTime]

## Troubleshooting

[Common issues]
```


# dockhand-mcp

An [MCP (Model Context Protocol)](https://modelcontextprotocol.io) server that exposes the [Dockhand](https://dockhand.pro) Docker management REST API as tools for LLMs such as Claude.

Runs as a Docker-hosted SSE server — deploy it once, connect any MCP client over HTTP.

## Features

- Manage **containers**: list, inspect, create, start, stop, restart, remove, get logs
- Manage **compose stacks**: list, create, start, stop, restart, remove
- Manage **Git stacks**: list, create, deploy
- Manage **images**: list, pull, push, remove, vulnerability scan
- Manage **volumes**: list, create, remove
- Manage **networks**: list, create, remove
- **Bulk operations**: batch start/stop/restart/remove across containers, images, volumes, networks, or stacks
- **Activity log and schedules**: inspect events and scheduled tasks
- All long-running operations return synchronous JSON results (no job-polling needed)

## Requirements

- Docker + Docker Compose
- A running [Dockhand](https://dockhand.pro) instance

## Deployment

The image is published automatically to `ghcr.io/markhaines/dockhand-mcp:latest` on every push to main.

### Remote server (recommended)

Copy `docker-compose.yml` to any machine with Docker and run:

```bash
DOCKHAND_URL=http://your-dockhand-host:3001 \
DOCKHAND_TOKEN="your-api-token" \
docker compose up -d
```

No build step — Docker pulls the pre-built image from the registry.

### Local

```bash
git clone https://github.com/markhaines/dockhand-mcp
cd dockhand-mcp
DOCKHAND_URL=http://localhost:3000 docker compose up -d
```

## Configuration

| Variable | Default | Description |
|---|---|---|
| `DOCKHAND_URL` | `http://localhost:3000` | Base URL of your Dockhand instance |
| `DOCKHAND_TOKEN` | _(empty)_ | API token for authenticated instances |
| `PORT` | `8000` | Port the MCP server listens on |
| `ROOT_PATH` | _(empty)_ | Public path prefix when serving behind a reverse proxy sub-path (e.g. `/dockhand`) |

To get your API token, log in to Dockhand, go to **Settings → API Tokens**, and generate a new token.

## Connecting to Claude

### Claude Desktop

Add this to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "dockhand": {
      "url": "http://your-server:8000/sse"
    }
  }
}
```

### Claude Code

```bash
claude mcp add --transport sse dockhand http://your-server:8000/sse
```

## Available Tools

| Category | Tool | Description |
|---|---|---|
| Environments | `list_environments` | List all configured Docker environments |
| Environments | `get_dashboard_stats` | Get CPU/memory/container stats |
| Containers | `list_containers` | List all containers |
| Containers | `get_container` | Inspect a container |
| Containers | `create_container` | Create a new container |
| Containers | `start_container` | Start a stopped container |
| Containers | `stop_container` | Stop a running container |
| Containers | `restart_container` | Restart a container |
| Containers | `remove_container` | Delete a container |
| Containers | `get_container_logs` | Fetch container logs |
| Bulk | `batch_operation` | Bulk start/stop/restart/remove |
| Stacks | `list_stacks` | List compose stacks |
| Stacks | `create_stack` | Create and deploy a stack |
| Stacks | `start_stack` | Start a stack |
| Stacks | `stop_stack` | Stop a stack |
| Stacks | `restart_stack` | Restart a stack |
| Stacks | `remove_stack` | Remove a stack |
| Git Stacks | `list_git_stacks` | List Git-backed stacks |
| Git Stacks | `create_git_stack` | Create a Git-backed stack |
| Git Stacks | `deploy_git_stack` | Deploy a Git stack |
| Images | `list_images` | List images |
| Images | `pull_image` | Pull an image |
| Images | `push_image` | Push an image |
| Images | `remove_image` | Remove an image |
| Images | `scan_image` | Vulnerability scan |
| Volumes | `list_volumes` | List volumes |
| Volumes | `create_volume` | Create a volume |
| Volumes | `remove_volume` | Remove a volume |
| Networks | `list_networks` | List networks |
| Networks | `create_network` | Create a network |
| Networks | `remove_network` | Remove a network |
| Activity | `get_activity` | Get container event log |
| Schedules | `list_schedules` | List scheduled tasks |

## Multi-environment support

Every tool accepts an optional `env` parameter (integer environment ID). Omit it to use the default environment, or pass the ID returned by `list_environments` to target a specific remote host.

## License

MIT

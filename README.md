# Home Server Configuration

Documentation of my self-hosted home server.

## Principles

My reasons for self-hosting can be split into three:

### Control

By self-hosting, I control things that are impossible (or unrealistic) to do with services available on the internet. I control the content of the services, meaning I can control (and eliminate!) any ads I see, remove useless content blocks, and host services that align with my priorities. I also don't have to worry about many third party APIs, rate limiting, inconvenient or opaque service updates, and single points of failure that come with proprietary, third-party cloud services.

### Privacy

"Privacy" is basically an extension of "Control," but it is so central to the services I host that I figured it should be its own section. Self-hosting allows me to host my own data and the data of those close to me. Data minimization is the guiding principle. Every external connection becomes an attack vector, and self-hosting allows me to surgically prune those vectors. The default assumption of corporate services is that data equals profit. My goal is to build systems where data remains a utility for my users, not a commodity to be exploited.

### Skill-Building

Hosting, using, and sharing services on my server allow me to build operational mastery that would otherwise be impossible. I am learning how to build, maintain, and recover complex infrastructure. Self-hosting allows me to gain experience in networking, hardening, disaster recovery, and backups, among other important skills for information technology. 

## Services

| Service | Description |
|---------|-------------|
| [authentik](authentik/README.md) | Identity provider & SSO |
| [immich](immich/README.md) | Photo & video management |
| [jellyfin](jellyfin/README.md) | Media server |
| [donetick](donetick/README.md) | Todo list with badges |
| [invidious](invidious/README.md) | YouTube front-end |
| [glance](glance/README.md) | Dashboard with feeds |
| [owntracks](owntracks/README.md) | Location tracking |
| [actual_budget](actual_budget/README.md) | Budget tracking |
| [ntfy](ntfy/README.md) | Push notifications |
| [media_stack](media_stack/README.md) | Media download & management |
| [searxng](searxng/README.md) | Private metasearch |
| [neko](neko/README.md) | Virtual browser |

## Structure

Each service directory contains `docker-compose.yml`, `.env.example`, and `README.md`.

## Setup

1. Clone this repository
2. For each service:
   - Copy `.env.example` to `.env`
   - Edit `.env` with your values
   - Run `docker compose up -d`

See [docs/INSTRUCTIONS.md](docs/INSTRUCTIONS.md) for common setup details and [individual service READMEs](*/README.md) for service-specific configuration.

## Bulk Updates

Use `update_all.sh` to update all services at once with parallel execution. See [docs/UPDATE.md](docs/UPDATE.md) for details on principles, usage, and customization.

## License

MIT - feel free to use as reference


# SkyCRM Umbrella

## Description

This is the SkyCRM project which I had worked on between 2020 and 2023. To date, it's still handling EverBright webhook matters, but much of it has had pieces of it replaced.

When this application was most active, it would handle passing information between Copper, Hubspot, Netsuite, OneDrive/SharePoint, PandaDocs, EverBright (Formerly Sighten), Google, Slack, and Zenefits.

In general, it would receive HTTP messages such as POST messages. These messages would be stored in Postgres using Oban. Oban would then at some point quickly after perform the message processing instructions defined in the Oban.Worker modules.

Phoenix and LiveView were used to provide a dashboard for reporting what the system was doing and what tasks it had completed and failed at. This would be done by querying on the Oban.Job schema stored in Postgres.

The application would be built into a docker image and that would run on a Digital Ocean droplet. Let's Encrypt was used to provide SSL. 

This has definitely been my largest Elixir project and I'm displaying it to show off to recruiters.

## SkyCRM Configuration

```Bash
#!/bin/bash
export COPPER_TOKEN=API_token &&
export COPPER_EMAIL=your.email@domain.com &&
export GCP_CREDENTIALS=config/creds.json &&
export SSL_KEY_PATH=apps/web/priv/cert/privkey.pem &&
export SSL_CERT_PATH=apps/web/priv/cert/fullchain.pem
# Compare with config/docker.env
# SSL Should use /app in production see Dockerfile
```

The above can make a properly configured Copper client for utilizing this application.

## Pushing a new docker version

- Do not use quotation marks when putting in the `docker.env` variables
- Use `MIX_ENV=prod mix release` to build
- Use `sudo docker system prune -a` to clean up all previous Docker images, containers, volumes, and networks
- Use `sudo docker build -t sky_crm:0.1.0 .` to build the docker image
- Use `sudo docker image tag sky_crm:0.1.0 marth141/sky_crm:0.1.0` to tag the new image
- Use `sudo docker image push marth141/sky_crm:0.1.0` to push up the new image
  - May need to `sudo docker login`
- Copy over `config/docker.env` to deployment environment (e.g. droplet)
- Run `docker-compose pull` on deployment environment

## How to update

After pushing a new docker version...

- At the droplet run `docker-compose pull`
  - One might have to login to docker hub
- Then run `./restart_skycrm.sh`

## How to access IEx in Prod

- At the droplet run `docker ps`
- Using the container id of the SkyCRM app run `./connect_to_container.sh -c [container-id]`
- Once in the SkyCRM container, open IEx with `./bin/sky_crm remote`

## How to shutdown

- At the droplet run `docker stack rm root`

## Resources

- [Material Color Pallet Based on the Rose/Maroon color](https://material.io/resources/color/#!/?view.left=0&view.right=1&primary.color=75495e)
- [Tailwind UI Components](https://tailwindui.com/components) most of the UI is based on
- [Phoenix LiveView Documentation](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html)
- [Heroicons](https://heroicons.dev/) (Icons used for most everything)
- [Tailwind Resources](https://tailwindcss.com/resources/) (For everything else UI)

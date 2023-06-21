# SkyCRM Umbrella

## Description

This application is largely to be able to provide a backend for Skyline Solar.

This application aims to wrap business contexts such as Sales, Proposals, or Operations and their dependencies on other applications such as Hubspot, Netsuite, and Sighten together under one application.

In doing this, we capture the data transfer between systems at specific points of the solar process. For example, we might have a message workflow that looks like,

"Hubspot sent a deal from one of its workflows to SkyCRM's endpoint where the records received by SkyCRM at this endpoint will create a Sighten site."

or

"When a customer signs a contract, Sighten will send a message to SkyCRM's endpoint where messages received here will look up information about the Sighten record and pass found information into Hubspot."

So one should generally check the Web.HookmonController module and start following functions from there around the SkyCRM. Typically this WebController module should only be touching a Skyline Solar business context such as Sales, Operations, or Proposals.

The wrong kind of communication model is to make communications that go from, for example, "Hubspot to Sighten to Hubspot".

The correct kind of communication model is to go "Hubspot to Sales to Sighten to Sales to Hubspot"

The correct model prevents cyclical dependencies and helps to keep the things that matter only to Sales in Sales. This causes stuff like the Hubspot application to be almost a 1:1 API Wrapper on Hubspot stuff. Specific details about that information such as, "Can you get the stuff in site survey from Hubspot?" should be a Sales function and not a Hubspot function.

If documentation is missing in places, it just hasn't been written yet

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

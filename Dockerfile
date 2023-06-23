# ---- Build Stage ----
FROM bitwalker/alpine-elixir-phoenix:latest as build

# install build dependencies
ENV MIX_ENV=prod

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# Bitwalker's Alpine Elixir image has prepared this directory for us, so we shouldn't need to mkdir
WORKDIR /app

# copy over necessary config files
COPY config/ /app/config/
COPY mix.exs /app/
COPY mix.* /app/

COPY apps/copper_api/mix.exs /app/apps/copper_api/
COPY apps/emailing/mix.exs /app/apps/emailing/
COPY apps/hubspot_api/mix.exs /app/apps/hubspot_api/
COPY apps/identity/mix.exs /app/apps/identity/
COPY apps/info_tech/mix.exs /app/apps/info_tech/
COPY apps/kixie_api/mix.exs /app/apps/kixie_api/
COPY apps/messaging/mix.exs /app/apps/messaging/
COPY apps/repo/mix.exs /app/apps/repo/
COPY apps/sighten_api/mix.exs /app/apps/sighten_api/
COPY apps/sitecapture_api/mix.exs /app/apps/sitecapture_api/
COPY apps/skyline_employee_manager/mix.exs /app/apps/skyline_employee_manager/
COPY apps/skyline_google/mix.exs /app/apps/skyline_google/
COPY apps/netsuite_api/mix.exs /app/apps/netsuite_api/
COPY apps/netsuite_oauth/mix.exs /app/apps/netsuite_oauth/
COPY apps/onedrive_api/mix.exs /app/apps/onedrive_api/
COPY apps/pandadoc_api/mix.exs /app/apps/pandadoc_api/
COPY apps/skyline_oban/mix.exs /app/apps/skyline_oban/
COPY apps/skyline_operations/mix.exs /app/apps/skyline_operations/
COPY apps/skyline_proposals/mix.exs /app/apps/skyline_proposals/
COPY apps/skyline_sales/mix.exs /app/apps/skyline_sales/
COPY apps/skyline_slack/mix.exs /app/apps/skyline_slack/
COPY apps/time_api/mix.exs /app/apps/time_api/
COPY apps/web/mix.exs /app/apps/web/

RUN mix do deps.get --only $MIX_ENV, deps.compile

COPY . /app/

WORKDIR /app/apps/web
RUN mix assets.deploy
RUN MIX_ENV=prod mix compile
# RUN npm install --prefix ./assets
# RUN npm run deploy --prefix ./assets
RUN mix phx.digest
RUN mix phx.gen.secret

WORKDIR /app
RUN MIX_ENV=prod mix release

# ---- Application Stage ----
FROM bitwalker/alpine-elixir:latest

# install runtime dependencies
RUN apk add --update bash openssl postgresql-client

ENV PORT=4001 \
    MIX_ENV=prod \
    SHELL=/bin/bash

# prepare app directory
WORKDIR /app

# copy release to app container
COPY --from=build app/_build/prod/rel/sky_crm .
COPY entrypoint.sh .
COPY /config/creds.json creds.json
COPY /apps/web/priv/cert/privkey.pem privkey.pem
COPY /apps/web/priv/cert/fullchain.pem fullchain.pem
RUN chmod -R 0700 /app
RUN apk add --no-cache tzdata
ENV TZ America/Denver

ENV HOME=/app
CMD ["bash", "/app/entrypoint.sh"]
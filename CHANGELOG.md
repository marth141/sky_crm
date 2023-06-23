# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [SkyCRM]

## [0.5.22] - 2022-03-25

### Changes
Since 0.5.17, there have been some fixes to Oban Jobs and the big update is getting SkyCRM to handle when tickets are created in Hubspot to also create a case in Netsuite on the assocaited record.

## [0.5.17] - 2021-11-12

### Added

- Dashboard for looking at counts of oban jobs.

### Changed

- Index is now a counts dashboard

### Removed

- None

## [0.5.16] - 2021-11-11

### Added

- Almost fully implemented all the tooling that connects org's applications Hubspot, Sighten, Copper, and Netsuite together. There is a missing implementation where Netsuite should attach project ids to Hubspot deals, but I'm not able to list all things from Netsuite yet. Once this is done, we can complete the id linking and that would complete the data pipeline project.

### Changed

- Skyline Operations has a job for creating a netsuite customer.
- Skyline Proposals now has a job for filling Hubspot with Sighten data on contract sign event.

### Removed

- None

## [0.5.13] - 2021-09-21

### Added

- Adding more tools to link copper and hubspot objects.
- Adding more proposal information to be sent over from Sighten.
- Adding state abbreviation function to create sighten site process.

### Changed

- None

### Removed

- None

## [0.5.12] - 2021-09-09

### Added

- Adding Operations Oban Jobs for Fulfillment Status Updates to Hubspot
- Adding Trello to Teamworks module to InfoTech

### Changed

- Skyline Operations (See Added)
- InfoTech

### Removed

- None

## [0.5.10] - 2021-08-19

### Added

- Adding an Oban Retrying list

### Changed

- Fixing Navbars from closing on phoenix updates.

### Removed

- None

## [0.5.9] - 2021-08-18

### Added

- None

### Changed

- Time displays as MST

### Removed

- None

## [0.5.8] - 2021-08-18

### Added

- Adding Oban Job Show

### Changed

- None

### Removed

- None

## [0.5.7] - 2021-08-18

### Added

- None

### Changed

- Oban Jobs "at" dates are now in MST.
- Moving errors behind args because errors grow the most.

### Removed

- None

## [0.5.6] - 2021-08-18

### Added

- None

### Changed

- Oban table simplified a bit for viewing.
- Oban prunes after 5 minutes.

### Removed

- None

## [0.5.5] - 2021-08-18

### Added

- Adding Oban Live View that refreshes every second.

### Changed

- Updating Navatar to not be open all the time.
- Setting Oban page time to be Mountain Standard.

### Removed

- None

## [0.5.4] - 2021-08-18

### Added

- None

### Changed

- Updating update_hubspot_with_copper_opportunity_install_date.ex with
  - Changing id from Date of Next Action to Install Date, had ids mismatched.
- Updating Dockerfile because adding the mix setup in web would kill Tailwind in prod.

### Removed

- None

## [0.5.3] - 2021-08-18

### Added

- None

### Changed

- Updating update_hubspot_with_copper_opportunity_install_date.ex with
  - better catching for errors.
  - Solving Time issue with Hubspot Endpoint

### Removed

- None

## [0.5.2] - 2021-08-17

### Added

- None

### Changed

- Updating update_hubspot_with_copper_opportunity_install_date.ex with better slack to Nate.

### Removed

- None

## [0.5.1] - 2021-08-17

### Added

- None

### Changed

- Updating update_hubspot_with_copper_opportunity_install_date.ex with catches for latest no clause errors.

### Removed

- None

## [0.5.0] - 2021-08-17

### Added

- Added Copper Opportunity Webhook Endpoint for sending Intall Dates into Copper.
  - If the id is missing, will try with email. If both are missing, Nate is slacked.
- Added all of app/skyline_operations/
  - Look at update_hubspot_with_sighten_proposal_info.ex for Oban job

### Changed

- Updated Dockerfile to include skyline_operations
- Updated copper_api.ex adding functions
  - get_opportunity - with opportunity_id will get, store, and return a copper opportunity.
  - delete_webhooks - Deletes webhooks in Copper via their id in a list e.g. [12345, 12346, ...]
  - updated get*person - Returns {:ok, *} pattern
- Updated copper_api/client.ex adding Tesla.delete wrapper
- Updated opportunity.ex adding create function that matches valid changeset
- Updated people.ex adding create function that matches valid changeset
- Added copper_api/webhook_body.ex struct for incoming copper webhooks
- Updated hubspot_api.ex with functions
  - search_deals_for_copper_id which searches Hubspot deals for their Copper Opportunity Ids
  - search_deals_for_email which searches Hubspot deals for their email using the Copper Opportunity's person's email
- Updated info_tech.ex adding more oban functions
- Updated hookmon_controller_test.ex with functions to test copper install date to hubspot deal process
- Updated hookmon_controller.ex adding functions for Copper install date to Hubspot deal process using Oban Job
- Updated router.ex adding endpoint for updating hubspot with copper install date.
- Updated config.exs adding oban queue for operations_webhooks

### Removed

- Removed oban view functions from SkylineSales and into InfoTech since the developer is mostly using them.

## [0.4.2] - 2021-08-12

### Added

- Added Copper testing endpoint

### Changed

- Fixed issue when creating Sighten Site where request Ecto Schema wasn't working out.
- Fixed issue when creating Sighten Site where State String Trim would attempt on a nil.

### Removed

- None

## [0.4.1] - 2021-08-12

### Added

- None

### Changed

- Fixed issue when creating Sighten Site where Hubspot's API was returning hs_all_owner_ids instead of hubspot_owner_id. Sighten Site would not create and Oban Job returned {:error, nil}

### Removed

- None

## [0.4.0] - 2021-08-10

### Added

- Added Oban for persistent queuing of jobs into the SkyCRM and significantly better job and error handling throughout the system.
  - Oban creates queues for "Workers/Jobs" which will "perform" a "Job" module. These queues can have worker pools where ready to go "Workers" with thier job to perform will go and attempt doing it up to 20 times. One would use `Repo.all(Oban.Job)` to view the jobs that are still in the Oban Queue. All the while, an engineer can see what is wrong with the task it tried to perform and debug it. Very simple. A job can be picked from the list and used in the developer environment to debug it. They're still in the queue becuase they hadn't finished.
  - Use the `SkylineContext.Jobs.SomeJob` modules to see what is being performed by SkyCRM.

### Changed

- Start using "changelog" over "change log" since it's the common usage.
- Updated Google and Enerflo Tesla clients to use Finch instead of httpc.
  - There were some errors with Finch in the other clients. Will debug in dev, will use httpc in prod.
- Revised several endpoint namings so they can be more clear on initial read.
- Dev version of SkyCRM able to use TailWindCSS while Prod version having issues.
- Revised all of the endpoint functions to run through Oban for Job persistence and better error catching and troubleshooting.
- Fixed endpoint bugs (check commit history from https://github.com/zblanco/sky_crm/commit/d5b9b9b5a1648325e401c51b30dc4f61803dd3ca and earlier)

### Removed

- None

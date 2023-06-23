## Nate's Goals

- Getting an interactive way to get different results.
  - Like instead of solar consultations, some other activity type.
  - Can I enter a date?

## Alpha / Prototype Requirements (Stage 1)

=======

- [x] Redo these metrics
  - [x] Count Copper Tasks by Solar Consulation activity type and count by "Due Date" for given date
  - [x] Count Copper Tasks by Solar Consultation Activity Type and Dispositions [Sat - Close Canceled, Sat - Closed, Sat - Failed Credit, Sat - Incomplete Close, Sat - One Legger, Sat - Rescheduled, Sat - Swing N Miss, Sat- Pitched at door] by "Due Date" for given date
  - [x] Count Copper Opportunities in Solar Consulation Pipeline by "Created" date for given date
  - [x] Count Copper Opportuntiies in Solar Consultation pipeline by "Created" date for given date
  - [x] Count Copper Opportunities in Customer Life Cycle pipeline by "Close Date" for given date
  - [x] Count Copper Opportunities in Customer Life Cycle pipeline by "SITE SURVEY COMPLETED" date for given date
  - [x] Count Copper Opportunities in Customer Life Cycle pipeline by "Created" date for given date
  - [x] Count Copper Leads by "Created" date for given date

Goal: Build a bare minimum extensible base for CRM and service integration escape hatch.

This should be a phoenix app that can handle web hooks, automate notifications, and run external integrations
in a maintainable way. In addition it can have basic user authentication and reporting using Liveview
for live-updated dashboards and simple internal forms. Early features will be to glue systems together (integrations)
and provide visibility. Next steps are to start implementing workflows for day-to-day operations.

The challenge is finding a way to replace Copper. This will require a database behind an application layer
managing authentication, authorization, workflows, and data visibility (BI reporting and metrics).

BI reporting is best served with a well designed database schema. A well designed database schema is only useful
if workflows supported by an application layer allow users to keep the data accurate and valid.

While we could copy all of Copper's data into a new database and report off of that, the data would become stale unless we continuously synced it. The implementation of syncing the data continuously is sufficiently complex that you might as well replace Copper and get further for the same effort and \$.

Instead we replace Copper workflow by workflow and replace it for a team at a time. That means we can develop a workflow, deploy, migrate data from existing systems (Copper), and train just the team on the new tools. The data migration only has to happen once instead of continuously, we're not maintaining multiple sources of truths, and features for just a team can be implemented gradually instead of everything for everyone at the same time.

So the end goal of a CRM/Business Workflow Management application is clear enough, but what's the path to get there?

## Stage 1 (Late Spring early Summer)

Basic integrations, live metric visibility, auth, and user administration.

Copper is the source of truth for most of the business workflows. It has a limited API, and a limited data model, but
we can overcome that to some extent by polling the data, storing it in memory, and building materialized views that let
us report on various metrics in soft real time.

Using in-memory polling to support live metrics is a temporary solution, but one with a fairly flat cost. Having to integrate with Copper, munge the data around, store in memory, and serve to UI is more steps than will be necessary for a given metric implementation compared to having everything within SkyCRM, but it provides immediate value.

Liveview as the front-end UI layer lets us build live dashboards of this data with minimal effort.

A basic email+password authentication layer and user administration capability protects this data to unauthorized parties.

Finally while not a front-facing feature we want an CI/CD pipeline for the application to automate deployments. This saves so much developer time the upfront cost pays for itself within weeks. It also allows Nate and Zack to roll out a new metrics same day.

That's pretty much it for stage 1. Zack helps Nate get the application setup with user management and authentication,
and Nate builds the Copper integrations necessary to access live metrics.

## Stage 2 (Mid - Late Summer)

The details here are still up in the air, but there are some good options:

### GSuite Single Sign On / OAuth2 provider support

- Most of Skyline's interactions are over GSuite supported applications, minimal friction is to allow the same for SkyCRM.
- This isn't a Stage 1 feature because this takes longer to implement than a basic email+password authentication mechanism.
  - In addition early features are just live dashboard metrics. The features don't require frequent interactions from most employees, just data visibility.
  - With more workflow implementations or a wider feature set it will make sense to implement SSO.

### Lead Management Workflows

- Ingest leads from lead sources (e.g. Facebook or Google Ads)
- Display untouched leads to Inside Sales users
- Track lead interactions with Inside Sales
  - Contact attempts
    - Calls, SMS, etc
  - Qualification Requirements
- Allow management to monitor and report on Inside Sales activity in real time (live metrics & workflow monitoring)
- Allow management to report on Inside Sales successes over time(BI reporting)
- Trigger / Insert / Schedule qualified leads into Sales scheduling systems such as Enerflo, Copper, Google Calendar etc.
- Send automated notifications

Lead management is a good candidate for an early workflow implementation because it's at the beginning of the customer lifecycle. Having clean sanitized data managed in an organized way will avoid lots of potential issues at later stages (such as Sales Consultations & Fulfillment). Zapier can still be used in temporary scenarios, but for the primary lead pipelines such as Facebook Ads, it can be replaced with a more reliable mechanism that costs significantly less per lead.

### Scheduling and Booking

Enerflo's data model as-is doesn't support granular historical BI reporting of Sales Consultations. When an appointment is rescheduled the details of the old appointment are lost. This is problematic when you want to look for patterns as to how more consultations can translate into signed contracts.

Were Enerflo to have a public API and a datamodel supporting the BI this wouldn't be an issue. Any integrations to their system, Copper, SkyCRM etc could be developed independently of Enerflo's schedule and availability. Until these limitations are removed there is a significant dependency on Enerflo's internal team for Skyline's Sales Operations systems to be streamlined or improved.

The contract calculations and proposal generation Enerflo provides would take a fair bit more time and effort to recreate. They have integrations and relationships with financing providers that also take time.

However booking, scheduling and field service management capabilities are worth evaluating.

- Sales consultants need scheduling and booking
- Site Surveyors need scheduling and booking
- Installers and techinicians need scheduling and booking
- There are at least 5 separate scheduling and booking spreadsheets in active use at Skyline.

Either an external service for general field service management and scheduling can be integrated with, or those features can be built into SkyCRM directly. A minimal version might just handle timezones, calendars, and resource availability/booking. At later stages drive time estimations, route optimization, skill-based resource management, field data collection, inventory integration, and mobile location tracking can be added.

### Internal Company Operations

- HR On/Offboarding forms and workflows
- Employee Contact database
- Ticketing / internal task queueing:

  - Accounting
  - HR
  - IT

- User Authentication

  - Stage 1: Basic Username + Password (MVP)
  - Stage 2: Gsuite SSO via Open Id Connect &/or OAuth2

- User Management

  - Accessible to Admins only (ensure_is_admin plug)
  - Add new users
    - Button opens modal
    - Modal has form, when submitted, registers user
  - Table of all users
  - Ability to Deactivate users (prevent logins)
  - Send password resets
  - Make other users Admins, but only if admin, button deactivated or missing unless is_admin
  - Logout

  - Stage 2:
    - Profile / Contact Details
    - Your profile - manage self
    - Avatar dropdown
    - Upload avatar

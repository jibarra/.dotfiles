---
name: unused_rails_endpoints
description: Identify Rails routes with zero or very low production traffic using Datadog APM. Use when asked to find unused/deprecated endpoints, audit a routes file for cleanup candidates, or check an engine's real-world usage before removing code.
---

# Find unused endpoints

Given a Rails routes file (or a list of controllers/actions), query Datadog APM to identify which endpoints are actually hit in production, and classify them as unused, low-traffic, or healthy. Output a report the user can act on.

**Before running the workflow, read `repo-context.md` (in this same skill directory).** It contains the codebase-specific values the generic steps below rely on — the Datadog service name, engine namespace conventions, where frontend callers live, and an example run. The generic workflow uses placeholders like `<SERVICE>` and `<ENGINE_NAMESPACE>`; substitute from `repo-context.md` before running queries.

## Data Sources

- **Datadog APM spans** — web spans tagged with the app's Datadog service (see `repo-context.md` for the service name and engine tagging behaviour).
- **The routes file** the user provides — source of truth for which endpoints *should* exist.
- **The repo itself** — for the caller-check step before any removal plan.

## Step 1: Parse the routes file

Read the routes file the user references. Build a map of each route to its expected `Controller#action` resource name. For a mounted engine, include the engine namespace prefix (see `repo-context.md`).

## Step 2: Confirm the Datadog service and resource naming

Even though `repo-context.md` lists the expected service name, confirm with a single sample query before aggregating — tagging sometimes drifts.

```
search_datadog_spans:
  query: "service:<SERVICE> type:web"
  custom_attributes: ["http.url", "http.url_details.path", "http.route"]
  from: "now-1h"
```

Check that a sample span has the expected `service` tag and a `resource_name` of the form `<EngineNamespace>::<Namespaces>::<Controller>#<action>`. Adjust and re-check if not.

## Step 3: Aggregate over 30 days

Query by `@rails.route.controller` with a wildcard, grouped by `resource_name`:

```
aggregate_spans:
  query: "service:<SERVICE> type:web env:production @rails.route.controller:<ENGINE_NAMESPACE>*"
  computes: [{ field: "*", aggregation: "COUNT", output: "hits", sort: "desc" }]
  group_by: { fields: ["resource_name"], limit: 500 }
  from: "now-30d"
  to: "now"
```

For an audit of the whole app (not just an engine), drop the `@rails.route.controller` filter — be prepared for a very large result set.

**Gotcha:** Datadog's query parser rejects unquoted `::` in `resource_name:`. Always filter with `@rails.route.controller:Foo*` (wildcard), or quote: `@rails.route.controller:"Foo::Bar"`. Bare `resource_name:Foo::Bar` throws `InvalidArgument: Cannot parse query`.

## Step 4: Classify each route

Map every entry in the routes file to its hit count, then bucket:

| Bucket | Threshold (30d) | Action |
|---|---|---|
| **Unused** | 0 hits | Removal candidate |
| **Very low** | 1–10 hits | Review with the feature owner; may still be critical admin paths |
| **Low** | 11–100 hits | Healthy but worth noting |
| **Healthy** | 100+ hits | Leave alone |
| **Anomaly** | Resource appears in Datadog but NOT in the routes file | Investigate — could be 404s, old controllers, or another route file |

Flag **health endpoints** separately. Platform probes (k8s, Heroku) often bypass APM or tag spans differently; engine-mounted health routes may look unused even when they are real probe targets. Confirm with infra before removing.

## Step 5: Caller check (always do this before proposing removal)

Zero hits in Datadog does NOT mean "safe to delete." The endpoint may still be wired to a UI button that nobody clicked in the window you checked. Grep the repo for callers of each zero-hit route path — see the caller-directory map in `repo-context.md`.

Categorise each hit:

- **Engine-internal only** (controllers + specs inside the engine) — safe to remove.
- **JS/TS caller** — check whether the JS function is still invoked from a component. If a live button calls it but nobody clicked in the window, the PR should remove the endpoint AND the UI wiring together.
- **Ruby caller outside the engine** — stop. Report back. Do not silently remove.

## Step 6: Produce the report

Write findings as a short markdown document with four sections:

1. **Zero hits** — table of route, controller#action, routes.rb line. Flag each as "safe after caller check" / "has live UI wiring" / "has Ruby caller".
2. **Very low traffic** — same table format.
3. **Healthy (for context)** — top 5 by hits, so the reviewer can sanity-check the classification.
4. **Anomalies** — `resource_name`s seen in Datadog but not declared in the routes file.

Include the exact Datadog query you used so the reviewer can reproduce.

## Optional Step 7: Generate deep-link Datadog URLs

For PR bodies and review docs, per-endpoint links make review faster. Pattern:

```
https://app.datadoghq.com/apm/traces?query=<URL_ENCODED_QUERY>&start=<MS>&end=<MS>&historicalData=true&paused=true
```

Good per-endpoint filter: `service:<SERVICE> env:production @rails.route.controller:"<FullyQualified::Controller>" @rails.route.action:<action>`. Quote the controller to survive the `::` parser. `*` encodes as `%2A`.

## Generic gotchas

- **`::` in queries** — always use `@rails.route.controller:Foo*` with a wildcard, or quote: `@rails.route.controller:"Foo::Bar"`.
- **Time window** — 30 days is the default. Widen to 60–90 days before recommending removal of rare-but-real admin paths (quarterly jobs, annual compliance flows).
- **Health endpoints** — engine-mounted health routes (`/health`, `/healthz`, root) usually show zero APM hits. Not evidence of unused. Confirm with infra.
- **Anomalies are real** — `resource_name`s sometimes appear in spans for routes not in the engine's `config/routes.rb`. Likely explanations: a secondary route file, a dynamic draw in an initializer, or 404 handlers that still emit tagged spans. Grep for the controller class before concluding.
- **UI cleanup is part of the job** — if a zero-hit endpoint has a live JS caller + UI component, the removal PR should include the UI cleanup. Leaving a dead button that 404s when clicked is worse than the original state.

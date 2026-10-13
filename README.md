# qone-advisor-db

> advisor bounded context: database (schema, seeds, migrations)

Part of the **Qampus (Quorum One)** distributed system — team `quorum-one`, Grupo 1.
Governance and documentation live in [`qone-docs`](https://github.com/code-corhuila/qone-docs).

## Purpose

The database of the **advisor** domain (course norm 5.2, Annex A): its own PostgreSQL 16
instance, the schema `advisor` and the migrations that build it. `qone-advisor-api` consumes it
and never versions it; no other service connects here (ADR-006). The tool is **Flyway
Community** (ADR-007): one SQL file, one version, a mirror `U` script per version.

Specification: `06-data/models.md` (schema `advisor`), `06-data/modeling-conventions.md`,
`06-data/migration-strategy.md`, ADR-003. Stories: `code-corhuila/qone-docs#46` (HU-ADV-002) and
`#47` (HU-ADV-003).

## Schema

| Table | What it keeps | Rules the database enforces |
|---|---|---|
| `conversation` | one chat of one user, with the role that chose its tool set | role list; `user_id` is the token's subject (INV-ADV-002) |
| `message` | the turns of a conversation | **append-only by grant** (INV-ADV-004): the writer has `INSERT, SELECT` only; content up to 8000 characters |
| `plan` | the enrollments the agent proposes and the student confirms | status list; **a confirmation id exactly when confirmed** (INV-ADV-003, INV-ENR-005); one plan per confirmation and per saga |
| `llm_cache` | provider answers by SHA-256 of model and prompt | key shape; pruned after 7 days by `qone-worker` |
| `catalog_subject_view`, `catalog_section_view`, `student_view` | projections fed by catalog, enrollment and billing events (D-11); the subject view is the pensum of the degree audit | rebuilt from events, never edited by hand |
| `idempotency_key`, `outbox`, `inbox` | the shared shapes of 06-data | `PlanProposed`, `PlanConfirmed`, `PlanDismissed` |

`user_id`, `student_id` and `section_id` are ids of other domains and are not foreign keys.

## How to run it

```bash
cp .env.example .env            # set ADVISOR_DB_PASSWORD; .env is ignored by git
docker network create platform  # once; qone-infra creates it in the full platform
docker compose --env-file .env -f deploy/compose.yml up -d advisor-db
docker compose --env-file .env -f deploy/compose.yml --profile tooling run --rm advisor-db-migrate
sh scripts/rebuild-check.sh     # the Annex A check db-ci runs on every pull request
```

## Branching

Three permanent branches. **None of them accepts a direct commit** — you enter through a child
branch and leave through a Pull Request.

```
develop  <--PR--  feat/... fix/... chore/...
qa       <--PR--  qa/...
main     <--PR--  release/...  hotfix/...
```

Promotion happens **by re-application** (`git cherry-pick -x`), never by merging one permanent
branch into another: `merge develop -> qa` and `merge qa -> main` do not exist in this model.

`main` requires **1 approval from `ariel5253`**. On `develop` and `qa` the team sets its own review
rule.

Full policy: `00-governance/branching-policy.md` in `qone-docs`.

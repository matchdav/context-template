# Repository Maintenance & Archival Policy (Template)

Authoritative policy for retention, archival, and synthesis workflows.

## Objectives
- Minimize cognitive noise
- Preserve traceability without clutter
- Elevate durable insights above raw logs
- Encode routine cleanup into lightweight automation

## Content Classes
| Class | Examples | Purpose | Retention | Disposition |
|-------|----------|---------|----------|-------------|
| Ephemeral Snapshot | `daily-digest.md`, standup reports | Situational awareness | 7 days (digests), monthly rollup (standups) | Rotate / archive |
| Transitional Journal | `journal/*.md` debugging, handoffs | High-resolution session context | Until summarized | Summarize → archive |
| Synthesis (Insights) | `insights/` lessons, trends | Durable knowledge | Permanent | Curate & evolve |
| Living Product Lens | `perspectives/*.md` | Product strategy & focus | Active only | Refresh on milestone |
| Architecture / ADR | `architecture/*.md` | Authoritative design intent | Permanent | Consolidate duplicates |
| Operational State | `workload/*.md` | Current priorities & dependencies | Current only | Overwrite in place |

## Lifecycle Workflows
See root README for summaries; extend here as needed.

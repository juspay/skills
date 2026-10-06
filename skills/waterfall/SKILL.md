---
name: waterfall
description: "Implement anything end-to-end using two agents: planner cum reviewer (premium model) and an implementer (fast model)"
compatibility: Requires kolu
---

# Waterfall

This skill is invoked with an argument that tells us what to implement.

You will respond to the user with a plan, who then approves it (unless they pre-approve). After they approve you must finalize the plan to remove all ambiguities using the question tool, along with asking the user these questions:

- Which agent to run (e.g.: omp, codex --yolo, etc.)
- Whether to auto-merge on green CI at end

Then you open a new Kolu split terminal, and run the implementor agent (in the same $PWD worktree as you) to implement the plan opening PR and then wait[^debrief] for the implementor to finish. Then, you review the PR per repo's guidelines (e.g.: Cordis-perfection, /solidjs) posting it in the PR itself, and then ask the implementor to address it. Then you re-review. Once satisfied, you ask the implementor do a final refactor per https://kolu.dev/blog/hickey-lowy/ and then to run CI (to save time, we don't run full CI until reviews are fully done). Once the PR is green, our work is done (unless auto-merge is enabled).

**IMPORTANT**: 
- If you are Fable model, you must **NOT** use Fable for any subagents you spawn unless that subagent requires premium intelligence.
- You are banned from doing any implementation yourself; that happens only through the implementor agent.

[^debrief]: Use kolu debrief to wait on any kolu terminal running an agent to go idle.

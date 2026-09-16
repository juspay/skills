---
name: waterfall
description: "Implement anything end-to-end using two agents: planner cum reviewer (premium model) and an implementer (fast model)"
compatibility: Requires kolu
---

# Waterfall

This skill is invoked with an argument that tells what to implement.

You will respond to the user with a plan, who then approves it (unless they pre-approve). After they approve you must finalize the plan to remove all ambiguities using the question tool, along with the asking the user these questions:

- Which model to use for implementor (default: open-fast)
- Whether to auto-merge on green CI at end

Then you open a new Kolu split terminal, and run the implementor agent `omp` using the user-provided model to implement the plan opening PR and then wait for the implementor to finish. Then, you review the PR per repo's guidelines (e.g.: Cordis-perfection) posting it in the PR itself, and then ask the implementor to address it. Then you re-review. Once satisfied, you ask the implementor do a final refactor per https://kolu.dev/blog/hickey-lowy/ and then to run CI (to save time, we don't run full CI until reviews are fully done). Once the PR is green, our work is done (unless auto-merge is enabled).

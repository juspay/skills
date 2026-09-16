---
name: waterfall
description: "Implement anything end-to-end using two agents: planner cum reviewer (premium model) and an implementer (fast model)"
compatibility: Requires kolu
---

# Waterfall

This skill is invoked with an argument that tells what to implement. You will respond to the user with a plan, who then approves it (unless they pre-approve). After they approve you must finalize the plan to remove all ambiguities using the question tool. Then you open a new Kolu split terminal, and run the implementor agent `omp` (the user tells you which model) to implement the plan opening PR and then wait for the implementor to finish. Then, you review the PR per repo's guidelines (e.g.: Cordis-perfection) posting it in the PR itself, and then ask the implementor to address it. Then you re-review. Once satisfied, you ask the implementor to run CI (to save time, we don't run full CI until reviews are fully done). Once the PR is gree, it is up to the human to merge (unless they approve auto-merge).

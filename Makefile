# Achievement Farm — local helpers
#
# These commands are convenience wrappers around `gh`; they DO NOT handle the
# secret. You must still create the `PAT` repository secret in the GitHub UI
# (the token must never be pasted into a terminal/local file).

# Derive owner/repo from the `origin` remote (not `gh repo view`, which can
# resolve to the upstream parent when this is a fork).
REPO ?= $(shell git remote get-url origin | sed -E 's#.*github.com[:/]##; s#\.git$$##')

.PHONY: help setup trigger status open

help:
	@echo "Targets:"
	@echo "  make setup    - print the one-time PAT secret setup steps"
	@echo "  make trigger  - trigger a manual workflow run (after PAT is set)"
	@echo "  make status   - show the latest workflow runs"
	@echo "  make open     - open the repo in a browser"

setup:
	@echo "=== One-time setup: create the PAT repository secret ==="
	@echo "1. Go to: https://github.com/$(REPO)/settings/secrets/actions"
	@echo "2. New repository secret:"
	@echo "     Name : PAT"
	@echo "     Value: a Personal Access Token with the 'repo' scope"
	@echo "3. Enable Actions on the repo if it is disabled."
	@echo "4. Run: make trigger"

trigger:
	gh workflow run farm.yml --repo $(REPO)

status:
	gh run list --repo $(REPO) --workflow farm.yml --limit 10

open:
	gh repo view $(REPO) --web

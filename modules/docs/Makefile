.PHONY : docs
docs/deps::
	@mkdir -p docs

.PHONY : docs/targets.md
## Update `docs/targets.md` from `make help`
docs/targets.md: docs/deps
	@( \
		echo "## Makefile Targets"; \
		echo '```'; \
		$(SELF) --no-print-directory --quiet --silent $(DEFAULT_HELP_TARGET) | sed $$'s,\x1b\\[[0-9;]*[a-zA-Z],,g'; \
		echo '```'; \
	) > $@

.PHONY : docs/terraform.md
## Update `docs/terraform.md` from `terraform-docs`
docs/terraform.md: docs/deps packages/install/terraform-docs
	@$(BUILD_HARNESS_PATH)/bin/terraform-docs.sh md . > $@

.PHONY : docs/serverless.md
CONFIGS = $(wildcard ./config/vpc-*.js)
## Update `docs/serverless_<stage>.md` from `serverless info`
docs/serverless.md: docs/deps 
	@array=(${CONFIGS}) ; \
	for file in "$${array[@]}" ; do \
		stage=$$(echo $$(basename $$file) | cut -d'-' -f 2 | cut -d'.' -f 1 ) ; \
		( \
			echo "## Service Information for $${stage} stage" ; \
			echo ; \
			echo '```txt' ; \
			./node_modules/.bin/serverless info --stage $${stage} ; \
			echo '```' ; \
		) > ./docs/serverless_$${stage}.md ; \
	done

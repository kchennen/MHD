
########################################################################################################################
# Environment Management Makefile
########################################################################################################################

make_lockfile: environment.yaml
ifeq ($(VIRTUALENV_PROG), mamba)
	@$(VIRTUALENV_EXE) env export --prefix=$(VIRTUALENV_PATH) --file $(ENV_LOCKFILE)
endif


.PHONY: create_environment
## Set up virtual (mamba) environment for this project
create_environment: environment.yaml
ifeq ($(VIRTUALENV_PROG), mamba)
	@echo
	@echo -e "ℹ️  Creating mamba environment: $(PROJECT_NAME)\n"
	@$(VIRTUALENV_EXE) env create --prefix=$(VIRTUALENV_PATH) --file $<
	@echo
	@echo -e "ℹ️  Creating lockfile: $(PROJECT_NAME)\n"
	@$(VIRTUALENV_EXE) env export --prefix=$(VIRTUALENV_PATH) --file $(ENV_LOCKFILE)
ifneq ("X$(wildcard $(POST_CREATE_ENVIRONMENT_FILE))","X")
	@cat $(POST_CREATE_ENVIRONMENT_FILE) | \
	sed 's|\[PROJECT_NAME\]|$(PROJECT_NAME)|g' | \
	sed 's|\[VIRTUALENV_PATH\]|$(VIRTUALENV_PATH)|g'
endif
else
	$(error Unsupported Environment `$(VIRTUALENV_PROG)`. Use mamba)
endif


.PHONY: environment_enabled
# Checks if the project mamba environment is active
environment_enabled:
ifeq ($(CONDA_DEFAULT_ENV),$(VIRTUALENV_PATH))
	@echo "✅ Mamba environment '$(VIRTUALENV_PATH)' is active."
else
	@echo
	@echo "❌ Mamba environment '$(VIRTUALENV_PATH)' is not active."
	@echo
	@echo "👉 Activate the environment:\n \
		>>> conda activate $(VIRTUALENV_PATH)"
	@exit 1
endif


# Test that an environment lockfile exists
check_lockfile:
@echo "ℹ️  Checking lockfile: $(ENV_LOCKFILE)"
ifeq (X,X$(wildcard $(ENV_LOCKFILE)))
	$(error Run "make update_environment" before proceeding...)
endif


.PHONY: update_environment
## Install or update Python Dependencies in the virtual (mamba) environment
update_environment: environment.yaml environment_enabled check_lockfile
ifeq ($(VIRTUALENV_PROG), mamba)
	@echo
	@echo "ℹ️  Updating mamba environment: $(PROJECT_NAME)"
	@$(VIRTUALENV_EXE) env update --prefix=$(VIRTUALENV_PATH) --file environment.yaml
	@$(VIRTUALENV_EXE) env export --prefix=$(VIRTUALENV_PATH) --file $(ENV_LOCKFILE)
	@echo
	@echo "✅ $(PROJECT_NAME) mamba environment was successfully updated!"
ifneq ("X$(wildcard $(POST_UPDATE_ENVIRONMENT_FILE))","X")
	@cat $(POST_UPDATE_ENVIRONMENT_FILE)
endif
else
	$(error ERROR: Unsupported Environment `$(VIRTUALENV_PROG)`. Use mamba)
endif


# Check if environment is enabled and correctly configured
check_environment: environment_enabled check_lockfile
	@echo "✅ $(PROJECT_NAME) mamba environment is enabled and correctly configured!"
	@echo



.PHONY: delete_environment
## Delete the virtual (mamba) environment for this project
delete_environment:
ifeq ($(VIRTUALENV_PROG), mamba)
	@echo "⚠️  Deleting mamba environment: $(PROJECT_NAME)"
	@${VIRTUALENV_EXE} env remove --prefix=$(VIRTUALENV_PATH)
	@echo "⚠️  Deleting lockfile: $(ENV_LOCKFILE)"
	@rm -f $(ENV_LOCKFILE)
ifneq ("X$(wildcard $(POST_DELETE_ENVIRONMENT_FILE))","X")
	@echo
	@cat $(POST_DELETE_ENVIRONMENT_FILE) | \
	sed 's|\[YYYY-MM-DD\]|$(DATE)|g' | \
	sed 's|\[VIRTUALENV\]|$(VIRTUALENV)|g' | \
	sed 's|\[VIRTUALENV_PATH\]|$(VIRTUALENV_PATH)|g' | \
	sed 's|\[USERNAME\]|$(USERNAME)|g'
endif
else
	$(error Unsupported Environment `$(VIRTUALENV)`. Use mamba)
endif


.PHONY: debug_environment
## dump useful debugging information to $(DEBUG_FILE)
debug_environment:
	@echo
	@echo "=========================================================================================="
	@echo "- Please include the contents '$(DEBUG_FILE)' when submitting an issue or support request."
	@echo "=========================================================================================="
	@echo "##=========================================================================" > $(DEBUG_FILE)
	@echo "## Git status" >> $(DEBUG_FILE)
	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "ℹ️  Checking git status...\n"
	@git status >> $(DEBUG_FILE)
	@echo >> $(DEBUG_FILE)

	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "## Git log" >> $(DEBUG_FILE)
	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "ℹ️  Checking git log...\n"
	@git log -8 --graph --oneline --decorate --all >> $(DEBUG_FILE)
	@echo >> $(DEBUG_FILE)

	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "## Github remotes" >> $(DEBUG_FILE)
	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "ℹ️  Checking Github remote...\n"
	@git remote -v >> $(DEBUG_FILE)
	@echo >> $(DEBUG_FILE)

	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "## Github SSH credentials" >> $(DEBUG_FILE)
	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "ℹ️  Checking Github SSH credentials...\n"
	@ssh git@github.com 2>&1 | cat >> $(DEBUG_FILE)
	@echo >> $(DEBUG_FILE)

	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "## Mamba info" >> $(DEBUG_FILE)
	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "ℹ️  Checking mamba info...\n"
	@$(VIRTUALENV_EXE) info  >> $(DEBUG_FILE)
	@echo >> $(DEBUG_FILE)

	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "## Mamba list" >> $(DEBUG_FILE)
	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "ℹ️  Checking mamba list...\n"
	@$(VIRTUALENV_EXE) list >> $(DEBUG_FILE)

	@echo "✅  Created environment debug file: $(DEBUG_FILE)"

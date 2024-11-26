########################################################################################################################
# Project environment variables
########################################################################################################################
# Get the name of the parent directory
PARENT_DIR := $(shell basename "$(shell dirname "$(realpath $(lastword $(MAKEFILE_LIST)))")")

# Get the path of the project directory
PROJECT_PATH := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

PROJECT_NAME := $(PARENT_DIR)
PROJECT_NAME_LC := $(shell echo $(PROJECT_NAME) | tr "[:upper:]" "[:lower:]")
PROJECT_NAME_UC := $(shell echo $(PROJECT_NAME_LC) | tr "[:lower:]" "[:upper:]")

VIRTUALENV_PATH := $(PROJECT_PATH)/.env/$(PROJECT_NAME)

AUTHOR_EMAIL = kchennen@unistra.fr
AUTHOR_NAME = kchennen


# Reproducible Environments
include .mks/include.mk
include .mks/envs.mk
include .mks/help.mk




#################################################################################
# COMMANDS                                                                      #
#################################################################################
.PHONY: am_i_ready clean
## Check if the environment requirements are installed
am_i_ready:
	@$(PYTHON_INTERPRETER) .mks/am_i_ready.py


afac:
	@echo $(PARENT_DIR)
	@echo $(PROJECT_PATH)
	@echo $(PROJECT_DIRS)
	@echo $(PROJECT_NAME)
	@echo $(PROJECT_NAME_LC)
	@echo $(PROJECT_NAME_UC)
	@echo $(VIRTUALENV_PATH)
	@echo $(AUTHOR_EMAIL)
	@echo $(AUTHOR_NAME)
	@echo $(VIRTUALENV_EXE)

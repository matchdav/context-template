# Makefile for context-template project

# detect operating system
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
	PLATFORM := linux
else ifeq ($(UNAME_S),Darwin)
	PLATFORM := macos
else ifeq ($(UNAME_S),CYGWIN)
	PLATFORM := windows
else ifeq ($(UNAME_S),MINGW32_NT)
	PLATFORM := windows
else ifeq ($(UNAME_S),MSYS_NT)
	PLATFORM := windows
else
	PLATFORM := unknown
endif
# .sh or .ps1 based on platform
ifeq ($(PLATFORM),windows)
	SHELL_EXT := ps1
else
	SHELL_EXT := sh
endif

.PHONY: daily-digest

daily-digest:
	echo $(PLATFORM)
	./automations/daily-digest.sh

install: install/*.*
	./install/install-$(PLATFORM).$(SHELL_EXT)
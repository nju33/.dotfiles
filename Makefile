.PHONY: all clean brew

all: brew

clean:
	rm -rf Brewfile Brewfile-gitpod

brew: Brewfile
	@./scripts/make-brewfile-gitpod.sh

Brewfile:
	brew bundle --no-vscode dump



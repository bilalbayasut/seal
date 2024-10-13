help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Setup

setup-env:
	@echo "                Creating .env file..."
	@echo "-----------------------------------------------------------"
	@[ ! -f .env ] && cp .env.example .env || echo ".env file already exists, not overwriting"

setup:
	@make setup-python


setup-vscode: ## Adds vscode settings
	@[ ! -d .vscode ] && cp -R .templates/vscode .vscode && echo ".vscode directory created" || echo ".vscode directory already exists, not overwriting"

setup-python: ## Create/update local python dev environment
	pyenv install -s
	@[ ! -f .venv ] && python -m venv .venv
	.venv/bin/pip install -U pip pipenv
	.venv/bin/pipenv install

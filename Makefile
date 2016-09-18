all: build

help:
	@echo "-- Help Menu ----------"
	@echo ""
	@echo "  1. make build"
	@echo "  2. make relase"

build:
	@docker build --tag=exlair/ums .

release:
	@docker build --tag=exlair/ums:$(shell cat VERSION) .


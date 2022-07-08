## help - Display help about make targets for this Makefile
help:
	@cat Makefile | grep '^## ' --color=never | cut -c4- | sed -e "`printf 's/ - /\t- /;'`" | column -s "`printf '\t'`" -t

## brakeman - Runs security analysis on the project with Brakeman
brakeman:
	brakeman lib --force

## build - Builds the project
build:
	gem build easypost.gemspec

## clean - Cleans the project
clean:
	rm -rf coverage doc *.gem

## fix - Fix Rubocop errors
fix:
	rubocop -A

## install - Install globally from source
install:
	bundle install

## lint - Lint the project
lint:
	rubocop

## push - Pushes the built gem to Rubygems
push:
	gem push *.gem

## test - Test the project
test:
	bundle exec rspec

.PHONY: help build clean fix install lint push test

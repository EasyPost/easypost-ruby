## help - Display help about make targets for this Makefile
help:
	@cat Makefile | grep '^## ' --color=never | cut -c4- | sed -e "`printf 's/ - /\t- /;'`" | column -s "`printf '\t'`" -t

## build - Builds the project
build:
	gem build easypost.gemspec --strict
	mkdir -p dist
	mv *.gem dist/

## clean - Cleans the project
clean:
	rm -rf coverage doc *.gem dist

## fix - Fix Rubocop errors
fix:
	rubocop -A

## install - Install globally from source
install:
	bundle install

## lint - Lint the project
lint:
	rubocop

## publish - Publishes the built gem to Rubygems
publish:
	gem push *.gem

## release - Cuts a release for the project on GitHub (requires GitHub CLI)
# tag = The associated tag title of the release
release:
	gh release create ${tag} dist/*

## scan - Runs security analysis on the project with Brakeman
scan:
	brakeman lib --force

## test - Test the project
test:
	bundle exec rspec

.PHONY: help build clean fix install lint publish release scan test

.phony:

env:
	export $$(cat .env | grep -v ^#)

run:
	dart run

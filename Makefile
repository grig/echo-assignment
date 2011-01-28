all: test

compile:
	erlc -o ebin/ src/*.erl

test: compile
	erl -pa ebin -eval 'eunit:test(sequence_server), init:stop().'

.PHONY=all compile test

YAWS_EBIN=${YAWS_HOME}/ebin
YAWS_INCLUDE=${YAWS_HOME}/include

all: compile

compile:
	test -d ebin || mkdir ebin
	erlc -I "${YAWS_INCLUDE}" -o ebin/ src/*.erl
	cp src/sequence_app.app ebin

unit-test: compile
	erl -pa ebin -noshell -eval 'eunit:test(sequence_server), init:stop().'

acceptance-test: compile
	cucumber

test: unit-test acceptance-test

run: compile
	erl -pa ebin -pa ${YAWS_EBIN} -noshell -s sequence_app start ${CONFIG}

.PHONY: all compile test acceptance-test unit-test run

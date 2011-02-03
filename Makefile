YAWS_EBIN=${YAWS_HOME}/ebin
YAWS_INCLUDE=${YAWS_HOME}/include

all: compile

ebin: 
	test -d ebin || mkdir ebin

compile: ebin src/*.erl
	erlc -I "${YAWS_INCLUDE}" -o ebin/ src/*.erl
	cp src/sequence_app.app ebin

tmp: 
	test -d tmp || mkdir tmp
unit-test: compile tmp
	erl -pa ebin -noshell -eval 'eunit:test(sequence_server), init:stop().'

acceptance-test: compile tmp
	cucumber

test: unit-test acceptance-test

run: compile
	erl -pa ebin -pa ${YAWS_EBIN} -noshell -s sequence_app start ${CONFIG}

.PHONY: all compile test acceptance-test unit-test run

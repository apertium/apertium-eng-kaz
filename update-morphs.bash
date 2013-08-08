#!/bin/bash

#assuming that you have the whole apertium tree in your source dir. and you are in kaz-kir directory

python3 ../../trunk/apertium-tools/trim-lexc.py apertium-eng-kaz.eng-kaz.dix ../apertium-kaz/apertium-kaz.kaz.lexc ../apertium-kir/apertium-kir.kir.lexc

cp /tmp/apertium-kaz.kaz.lexc.trimmed apertium-eng-kaz.kaz.lexc

DIFF=$(diff ../apertium-kaz/apertium-kaz.kaz.twol apertium-eng-kaz.kaz.twol)
if [ "$DIFF" != "" ]; then
	cp ../apertium-kaz/apertium-kaz.kaz.twol apertium-eng-kaz.kaz.twol
fi;
cp ../apertium-kaz/apertium-kaz.kaz.rlx apertium-eng-kaz.kaz-eng.rlx

exit 0



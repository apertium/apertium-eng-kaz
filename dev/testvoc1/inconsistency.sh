TMPDIR=/tmp

DIR=$1

SED=sed

if [[ $DIR = "kaz-eng" ]]; then

lt-expand /home/apertium/apertium-testing/apertium-kaz/apertium-kaz.kaz.lexc | grep -v '<prn><enc>' | grep -v 'REGEX' | grep -v ':<:' | $SED 's/:>:/%/g' | $SED 's/:/%/g' | cut -f2 -d'%' |  $SED 's/^/^/g' | $SED 's/$/$ ^.<sent>$/g' | apertium-pretransfer | lt-proc -b ../../kaz-eng.autobil.bin | grep -v '/@' | cut -f1 -d'/' | $SED 's/$/$ ^.<sent>$/g' | tee $TMPDIR/$DIR.tmp_testvoc1.txt |\
        apertium-pretransfer|\
	lt-proc -b ../../kaz-eng.autobil.bin | tee $TMPDIR/$DIR.tmp_testvoc2.txt |\
        apertium-transfer -b ../../apertium-eng-kaz.kaz-eng.t1x  ../../kaz-eng.t1x.bin |\
        apertium-interchunk ../../apertium-eng-kaz.kaz-eng.t2x  ../../kaz-eng.t2x.bin |\
        apertium-postchunk ../../apertium-eng-kaz.kaz-eng.t3x ../../kaz-eng.t3x.bin  | tee $TMPDIR/$DIR.tmp_testvoc3.txt |\
        lt-proc -d ../../kaz-eng.autogen.bin > $TMPDIR/$DIR.tmp_testvoc4.txt
paste -d _ $TMPDIR/$DIR.tmp_testvoc1.txt $TMPDIR/$DIR.tmp_testvoc2.txt $TMPDIR/$DIR.tmp_testvoc3.txt $TMPDIR/$DIR.tmp_testvoc4.txt| $SED 's/\^.<sent>\$//g' | $SED 's/_/   --------->  /g'


else
	echo "bash inconsistency.sh <direction>";
fi

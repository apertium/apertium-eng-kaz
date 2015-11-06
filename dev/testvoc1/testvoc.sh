if [[ $1 = "kaz-eng" ]]; then
echo "==Kazakh->English===========================";
bash inconsistency.sh kaz-eng > /tmp/kaz-eng.testvoc; bash inconsistency-summary.sh /tmp/kaz-eng.testvoc kaz-eng
echo ""

fi

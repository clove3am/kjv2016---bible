kjv2016: kjv2016.sh kjv2016.awk kjv2016.tsv
	cat kjv2016.sh > $@

	echo 'exit 0' >> $@

	echo '#EOF' >> $@
	tar czf - kjv2016.awk kjv2016.tsv >> $@

	chmod +x $@

test: kjv2016.sh
	shellcheck -s sh kjv2016.sh

.PHONY: test

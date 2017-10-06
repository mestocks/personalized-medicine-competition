HOME = $(shell echo $$HOME)/
BASE = $(HOME)projects/cancer/

# In:
#	raw/stage12/test_text
# 	raw/stage12/test_variants
# 	raw/stage12/training_text
# 	raw/stage12/training_variants
#
# Out:
#	data/feat/mycvs.xw
#	data/feat/mytest.xw
#	data/feat/alltest.xw
#	data/feat/mytrain_ans.xw
#	data/feat/alltrain_ans.xw
#	data/feat/bi_uniq_word.txt
#
# Dependencies:
#	python2, numpy
#
# Scripts:
#	chargrok.c, mean.py, sigma.py,
#	subset.py, normalise_alt.py, pca.py

RAW = $(BASE)raw/
STG1 = $(RAW)stage1/
STG2 = $(RAW)stage2/
STG12 = $(RAW)stage12/
FLTR = $(RAW)filter/

DATA = $(BASE)data/
FEAT = $(DATA)feat/

pfx = pnc_pval_lwr_
datasets = training test
data-ids = $(addsuffix .ids,$(datasets))
data-text = $(addsuffix .text,$(datasets))
data-both = $(addsuffix .both,$(datasets))


.PHONY:	pca
pca:	$(FEAT)alltest.xw $(FEAT)alltrain_ans.xw $(FEAT)alltrain.xw $(FEAT)mytrain_ans.xw $(FEAT)mycvs_ans.xw $(FEAT)mytest_ans.xw $(FEAT)mytrain.xw $(FEAT)mycvs.xw $(FEAT)mytest.xw $(FEAT)alltrain.ans $(FEAT)mytrain.ans $(FEAT)mycvs.ans $(FEAT)mytest.ans $(FEAT)mytrain.vt $(FEAT)alltrain1_ans.xw $(FEAT)alltrain1.xw $(FEAT)alltrain2_ans.xw $(FEAT)alltrain2.xw

#pcplot.png:	training_ids.xw $(RAW)training_variants training.xw
#	Rscript $(SCR)pca.r $^ $@

$(FEAT)alltrain1_ans.xw:	$(FEAT)alltrain_ans.xw
	head -n 1951 $^ > $@

$(FEAT)alltrain1.xw:	$(FEAT)alltrain.xw
	head -n 1951 $^ > $@

$(FEAT)alltrain2_ans.xw:	$(FEAT)alltrain_ans.xw
	tail -n 1738 $^ > $@

$(FEAT)alltrain2.xw:	$(FEAT)alltrain.xw
	head -n 1738 $^ > $@


$(FEAT)%_ans.xw:	$(FEAT)%.xw $(FEAT)%.ans
	paste -d ' ' $^ > $@

$(FEAT)%.ans:	$(FEAT)pre_%.ans
	awk ' { sep=""; for (i=1; i<=9; i++) { a=0; if (i==$$1) a=1; printf sep""a; sep=" " } print "" } ' $^ > $@

$(FEAT)%.xw:	$(FEAT)%.nrm $(FEAT)mytrain.vt
	python ~/repos/pca/project.py $^ $@

$(FEAT)%.vt:	$(FEAT)%.nrm
	python ~/repos/pca/pca.py $^ $@ 0.95


.PHONY:	normalise
normalise:	$(FEAT)alltest.nrm $(FEAT)alltrain.nrm $(FEAT)mytrain.nrm $(FEAT)mycvs.nrm $(FEAT)mytest.nrm

$(FEAT)my%.nrm:	$(FEAT)my%.raw $(FEAT)mytrain.mu $(FEAT)mytrain.sigma
	python ~/repos/pca/normalise_alt.py $(word 1,$^) $(word 2,$^) $(word 3,$^) $@

$(FEAT)all%.nrm:	$(FEAT)all%.raw $(FEAT)mytrain.mu $(FEAT)mytrain.sigma
	python ~/repos/pca/normalise_alt.py $(word 1,$^) $(word 2,$^) $(word 3,$^) $@


.PHONY:	subset
subset:	$(FEAT)alltest.raw $(FEAT)alltrain.raw $(FEAT)mytrain.raw $(FEAT)mycvs.raw $(FEAT)mytest.raw

$(FEAT)%.raw:	$(FEAT)pre_%.raw $(FEAT)pre_mytrain.mu $(FEAT)pre_mytrain.sigma
	python ~/repos/pca/subset.py $^ $@ $(FEAT)$*.mu $(FEAT)$*.sigma



.PHONY:	mean-sigma
mean-sigma:	$(FEAT)pre_mytrain.mu $(FEAT)pre_mytrain.sigma

%.mu:	%.raw
	python ~/repos/pca/mean.py $^ $@

%.sigma:	%.raw
	python ~/repos/pca/sigma.py $^ $@


# ntrain = 3689
# train 2952 (80%): mytest 737 (20%)
# mytrain 2362 (80%): mycsv 590 (20%)

.PHONY:	data-split
data-split:	$(FEAT)pre_alltest.raw $(FEAT)pre_alltrain.raw $(FEAT)alltrain.ids $(FEAT)pre_alltrain.ans $(FEAT)pre_mytrain.raw $(FEAT)mytrain.ids $(FEAT)pre_mytrain.ans $(FEAT)pre_mycvs.raw $(FEAT)mycvs.ids $(FEAT)pre_mycvs.ans $(FEAT)pre_mytest.raw $(FEAT)mytest.ids $(FEAT)pre_mytest.ans

$(FEAT)pre_mytrain.raw:	$(FEAT)pre_training.raw
	head -n 2362 $^ > $@

$(FEAT)mytrain.ids:	$(FEAT)training.ids
	head -n 2362 $^ > $@

$(FEAT)pre_mytrain.ans:	$(FEAT)pre_training.ans
	head -n 2362 $^ > $@


$(FEAT)pre_mycvs.raw:	$(FEAT)pre_training.raw
	head -n 2952 $^ | tail -n 590 > $@

$(FEAT)mycvs.ids:	$(FEAT)training.ids
	head -n 2952 $^ | tail -n 590 > $@

$(FEAT)pre_mycvs.ans:	$(FEAT)pre_training.ans
	head -n 2952 $^ | tail -n 590 > $@


$(FEAT)pre_mytest.raw:	$(FEAT)pre_training.raw
	tail -n 737 $^ > $@

$(FEAT)mytest.ids:	$(FEAT)training.ids
	tail -n 737 $^ > $@

$(FEAT)pre_mytest.ans:	$(FEAT)pre_training.ans
	tail -n 737 $^ > $@


$(FEAT)pre_alltrain.raw:	$(FEAT)pre_training.raw
	cat $^ > $@

$(FEAT)alltrain.ids:	$(FEAT)training.ids
	cat $^ > $@

$(FEAT)pre_alltrain.ans:	$(FEAT)pre_training.ans
	cat $^ > $@


$(FEAT)pre_alltest.raw:	$(FEAT)pre_test.raw
	cat $^ > $@


.PHONY:	shuffle
shuffle:	$(FEAT)pre_test.raw $(FEAT)training_ans.uraw $(FEAT)pre_training.raw $(FEAT)training.ids $(FEAT)pre_training.ans

$(FEAT)pre_training.ans:	$(STG12)training_text $(FEAT)training_ans.uraw
	shuf --random-source=$(word 1,$^) $(word 2,$^) > $@

$(FEAT)pre_training.raw:	$(STG12)training_text $(FEAT)training.buraw
	shuf --random-source=$(word 1,$^) $(word 2,$^) > $@

$(FEAT)training.ids:	$(STG12)training_text $(FEAT)training.buids
	shuf --random-source=$(word 1,$^) $(word 2,$^) > $@

$(FEAT)training_ans.uraw:	$(STG12)training_variants
	grep "^ID" -v $^ | awk -F, ' { print $$NF } ' > $@

$(FEAT)pre_test.raw:	$(FEAT)test.buraw
	cat $^ > $@


############

raw-count = $(addprefix $(FEAT),$(addsuffix .uraw,$(datasets)))
ids-count = $(addprefix $(FEAT),$(addsuffix .uids,$(datasets)))
word-count = $(addprefix $(FEAT)$(pfx),$(addsuffix .count,$(datasets)))

raw-bcount = $(addprefix $(FEAT),$(addsuffix .buraw,$(datasets)))
ids-bcount = $(addprefix $(FEAT),$(addsuffix .buids,$(datasets)))
word-bcount = $(addprefix $(FEAT)$(pfx),$(addsuffix .bcount,$(datasets)))

.PHONY:	count
count:	$(word-count) $(ids-count) $(raw-count) $(word-bcount) $(ids-bcount) $(raw-bcount)

$(FEAT)%.uraw:	$(FEAT)uniq_words.txt $(FEAT)$(pfx)%.count
	~/repos/chargrok/bin/chargrok $^ > $@

$(FEAT)%.uids:	$(FEAT)$(pfx)%.count
	cut -d' ' -f 1 $^ | uniq > $@

$(FEAT)%.count:	$(FEAT)%.nline
	sort $^ | uniq -c | awk -F, ' { print $$1,$$2 } ' | awk ' { print $$3,$$2,$$1 } ' | sort -k1,1n -k2,2g > $@


$(FEAT)%.buraw:	$(FEAT)bi_uniq_words.txt $(FEAT)$(pfx)%.bcount
	~/repos/chargrok/bin/chargrok $^ > $@

$(FEAT)%.buids:	$(FEAT)$(pfx)%.bcount
	cut -d' ' -f 1 $^ | uniq > $@

$(FEAT)%.bcount:	$(FEAT)%.bline
	sort $^ | uniq -c | awk -F, ' { print $$1,$$2 } ' | awk ' { print $$3,$$2,$$1 } ' | sort -k1,1n -k2,2g > $@


############
# Word discovery
# && length($$1) > 4
.PHONY:	word-discovery
word-discovery:	$(FEAT)uniq_words.txt $(FEAT)bi_uniq_words.txt

$(FEAT)uniq_words.txt:	$(FEAT)$(pfx)training.nline stop_words.txt
	cut -d',' -f 1 $(word 1,$^) | grep "[^a-z]" -v | grep "[^actgu]" | grep -xvf $(word 2,$^) | awk ' { if (length($$1) < 20 && length($$1) > 3) print $$1 } ' | sort | uniq -c | awk ' { if ($$1 > 75) print $$2 }' > $@

$(FEAT)bi_uniq_words.txt:	$(FEAT)$(pfx)training.nline stop_words.txt academic_words.txt
	cut -d',' -f 1 $(word 1,$^) | grep "[^a-z]" -v | grep "[^actgu]" | grep -xvf $(word 2,$^) | grep -xvf $(word 3,$^) | awk ' { if (length($$1) < 20 && length($$1) > 3) print $$1 } ' | awk ' BEGIN { old="" }; { if (NR != 1) { if (old < $$1) print old"-"$$1; else print $$1"-"old } old=$$1 } ' | sort | uniq -c | awk ' { if ($$1 > 175) print $$2 }' > $@


nline-text = $(addprefix $(FEAT)$(pfx),$(subst .both,.nline,$(data-both)))
bline-text = $(addprefix $(FEAT)$(pfx),$(subst .both,.bline,$(data-both)))

.PHONY:	nline
nline:	$(nline-text) $(bline-text)

$(FEAT)%.nline:	$(FLTR)%.both
	awk ' { $$1=$$1; for (i=2; i<=NF; i++) print $$i","$$1 } ' $^ | tr -d '[:blank:]' > $@

$(FEAT)%.bline:	$(FLTR)%.both
	awk ' { $$1=$$1; if (NF < 3) { print "null-null,"$$1 } else {old=$$2; for (i=3; i<=NF; i++) { if (old < $$i) { bistr=old"-"$$i } else { bistr=$$i"-"old } print bistr","$$1; old=$$i } } } ' $^ | tr -d '[:blank:]' > $@


############
# Filtering

.PHONY:	rm-punc
rm-punc:	$(FLTR)pnc_pval_lwr_training.both $(FLTR)pnc_pval_lwr_test.both

$(FLTR)pnc_%.both:	$(FLTR)%.both
	tr '[\t()\.,;:{}*%~\"]' ' ' < $^ | tr -d '-' | tr -s ' ' > $@


.PHONY:	pval
pval:	$(FLTR)pval_lwr_training.both $(FLTR)pval_lwr_test.both

$(FLTR)pval_%.both:	$(FLTR)%.both
	sed -e 's/p-value/pvalue/g' < $^ | sed -e 's/p = /pvalue = /g' | sed -e 's/p=/pvalue=/g' | sed -e 's/pvalues/pvalue/g' | sed -e 's/pvalue < /pvalue</g' | sed -e 's/pvalue = /pvalue=/g' | sed -e 's/pvalue</pvalueless /g' | sed -e 's/pvalue=/pvalueequal /g' > $@


.PHONY:	to-lower
to-lower:	$(FLTR)lwr_training.both $(FLTR)lwr_test.both

$(FLTR)lwr_%.both:	$(FLTR)raw_%.both
	tr '[:upper:]' '[:lower:]' < $^ > $@


############

split-both = $(addprefix $(FLTR)raw_,$(data-both))
split-ids = $(addprefix $(FLTR)raw_,$(data-ids))
split-text = $(addprefix $(FLTR)raw_,$(data-text))

.PHONY:	split-cols
split-cols:	$(split-ids) $(split-text) $(split-both)

$(FLTR)raw_%.both:	$(STG12)%_text
	awk -F"[|][|]" ' { if (NR != 1) print $$1,$$2 } ' $^ > $@

$(FLTR)raw_%.ids:	$(STG12)%_text
	awk -F"[|][|]" ' { if (NR != 1) print $$1 } ' $^ > $@

$(FLTR)raw_%.text:	$(STG12)%_text
	awk -F"[|][|]" ' { if (NR != 1) print $$2 } ' $^ > $@

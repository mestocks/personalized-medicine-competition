HOME = $(shell echo $$HOME)/
BASE = $(HOME)projects/cancer/

RAW = $(BASE)raw/
STG1 = $(RAW)stage1/
STG2 = $(RAW)stage2/
STG12 = $(RAW)stage12/
FLTR = $(RAW)filter/

DATA = $(BASE)data/
FEAT = $(DATA)feat/

pfx = pnc_pval_lwr_
datasets = training
data-ids = $(addsuffix .ids,$(datasets))
data-text = $(addsuffix .text,$(datasets))
data-both = $(addsuffix .both,$(datasets))


.PHONY:	pca
pca:	$(FEAT)mytrain_ans.xw $(FEAT)mycvs_ans.xw $(FEAT)mytest_ans.xw $(FEAT)mytrain.xw $(FEAT)mycvs.xw $(FEAT)mytest.xw $(FEAT)mytrain.ans $(FEAT)mycvs.ans $(FEAT)mytest.ans

#pcplot.png:	training_ids.xw $(RAW)training_variants training.xw
#	Rscript $(SCR)pca.r $^ $@

$(FEAT)%_ans.xw:	$(FEAT)%.xw $(FEAT)%.ans
	paste -d ' ' $^ > $@

$(FEAT)%.ans:	$(FEAT)pre_%.ans
	awk ' { sep=""; for (i=1; i<=9; i++) { a=0; if (i==$$1) a=1; printf sep""a; sep=" " } print "" } ' $^ > $@

$(FEAT)%.xw:	$(FEAT)%.nrm $(FEAT)mytrain.vt
	python ~/repos/pca/project.py $^ $@

$(FEAT)%.vt:	$(FEAT)%.nrm
	python ~/repos/pca/pca.py $^ $@ 0.95


.PHONY:	normalise
normalise:	$(FEAT)mytrain.nrm $(FEAT)mycvs.nrm $(FEAT)mytest.nrm

$(FEAT)my%.nrm:	$(FEAT)my%.raw $(FEAT)mytrain.mu $(FEAT)mytrain.sigma
	python ~/repos/pca/normalise_alt.py $(word 1,$^) $(word 2,$^) $(word 3,$^) $@


.PHONY:	subset
subset:	$(FEAT)mytrain.raw $(FEAT)mycvs.raw $(FEAT)mytest.raw

$(FEAT)%.raw:	$(FEAT)pre_%.raw $(FEAT)pre_mytrain.mu $(FEAT)pre_mytrain.sigma
	python ~/repos/pca/subset.py $^ $@ $(FEAT)$*.mu $(FEAT)$*.sigma



.PHONY:	mean-sigma
mean-sigma:	$(FEAT)pre_mytrain.mu $(FEAT)pre_mytrain.sigma

%.mu:	%.raw
	python ~/repos/pca/mean.py $^ $@

%.sigma:	%.raw
	python ~/repos/pca/sigma.py $^ $@


# ntrain = 3690
# train 2952 (80%): mytest 738 (20%)
# mytrain 2362 (80%): mycsv 590 (20%)

.PHONY:	data-split
data-split:	$(FEAT)pre_mytrain.raw $(FEAT)mytrain.ids $(FEAT)pre_mytrain.ans $(FEAT)pre_mycvs.raw $(FEAT)mycvs.ids $(FEAT)pre_mycvs.ans $(FEAT)pre_mytest.raw $(FEAT)mytest.ids $(FEAT)pre_mytest.ans

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
	tail -n 738 $^ > $@

$(FEAT)mytest.ids:	$(FEAT)training.ids
	tail -n 738 $^ > $@

$(FEAT)pre_mytest.ans:	$(FEAT)pre_training.ans
	tail -n 738 $^ > $@


.PHONY:	shuffle
shuffle:	$(FEAT)pre_training.raw $(FEAT)training.ids $(FEAT)pre_training.ans

$(FEAT)pre_training.ans:	$(STG12)training_text $(FEAT)training_ans.uraw
	shuf --random-source=$(word 1,$^) $(word 2,$^) > $@

$(FEAT)pre_training.raw:	$(STG12)training_text $(FEAT)training.buraw
	shuf --random-source=$(word 1,$^) $(word 2,$^) > $@

$(FEAT)training.ids:	$(STG12)training_text $(FEAT)training.buids
	shuf --random-source=$(word 1,$^) $(word 2,$^) > $@

$(FEAT)training_ans.uraw:	$(STG12)training_variants
	grep "^ID" -v $^ | awk -F, ' { print $$NF } ' > $@


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

$(FEAT)uniq_words.txt:	$(FEAT)$(pfx)training.nline $(FEAT)stop_words.txt
	cut -d',' -f 1 $(word 1,$^) | grep "[^a-z]" -v | grep "[^actgu]" | grep -xvf $(word 2,$^) | awk ' { if (length($$1) < 20 && length($$1) > 3) print $$1 } ' | sort | uniq -c | awk ' { if ($$1 > 75) print $$2 }' > $@

$(FEAT)bi_uniq_words.txt:	$(FEAT)$(pfx)training.nline $(FEAT)stop_words.txt $(FEAT)academic_words.txt
	cut -d',' -f 1 $(word 1,$^) | grep "[^a-z]" -v | grep "[^actgu]" | grep -xvf $(word 2,$^) | grep -xvf $(word 3,$^) | awk ' { if (length($$1) < 20 && length($$1) > 3) print $$1 } ' | awk ' BEGIN { old="" }; { if (NR != 1) { if (old < $$1) print old"-"$$1; else print $$1"-"old } old=$$1 } ' | sort | uniq -c | awk ' { if ($$1 > 175) print $$2 }' > $@


nline-text = $(addprefix $(FEAT)$(pfx),$(subst .both,.nline,$(data-both)))
bline-text = $(addprefix $(FEAT)$(pfx),$(subst .both,.bline,$(data-both)))

.PHONY:	nline
nline:	$(nline-text) $(bline-text)

$(FEAT)%.nline:	$(FLTR)%.both
	awk ' { $$1=$$1; for (i=2; i<=NF; i++) print $$i","$$1 } ' $^ | tr -d '[:blank:]' > $@

$(FEAT)%.bline:	$(FLTR)%.both
	awk ' { $$1=$$1; n=1; for (i=2; i<=NF; i++) { if (n != 1) { if (old < $$i) bistr=old"-"$$i; else bistr=$$i"-"old; print bistr","$$1 } n++; old=$$i } } ' $^ | tr -d '[:blank:]' > $@


############
# Filtering

.PHONY:	rm-punc
rm-punc:	$(FLTR)pnc_pval_lwr_training.both

$(FLTR)pnc_%.both:	$(FLTR)%.both
	tr '[\t()\.,;:{}*%~\"]' ' ' < $^ | tr -d '-' | tr -s ' ' > $@


.PHONY:	pval
pval:	$(FLTR)pval_lwr_training.both

$(FLTR)pval_%.both:	$(FLTR)%.both
	sed -e 's/p-value/pvalue/g' < $^ | sed -e 's/p = /pvalue = /g' | sed -e 's/p=/pvalue=/g' | sed -e 's/pvalues/pvalue/g' | sed -e 's/pvalue < /pvalue</g' | sed -e 's/pvalue = /pvalue=/g' | sed -e 's/pvalue</pvalueless /g' | sed -e 's/pvalue=/pvalueequal /g' > $@


.PHONY:	to-lower
to-lower:	$(FLTR)lwr_training.both

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

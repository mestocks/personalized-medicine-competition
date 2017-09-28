HOME = $(shell echo $$HOME)/
BASE = $(HOME)projects/cancer/

RAW = raw/
SCR = scripts/
SUB = submissions/

comma := ,
ARCH=944,100,100,9
ARCHX=$(subst $(comma),x,$(ARCH))
NEPOCHS=1000

# 300 300 1.718
# 100x100 300 0.2980

pfx = pnc_pval_lwr_
datasets = test training
data-ids = $(addsuffix .ids,$(datasets))
data-text = $(addsuffix .text,$(datasets))
data-both = $(addsuffix .both,$(datasets))

############

.PHONY:	submit
submit:	test_1338x100x100x9-1-1-0-5_ids.sub

test_1338x100x100x9-1-1-0-5_ids.sub:	test_1338x100x100x9-1-1-0-5_ids.slv
	awk ' BEGIN { OFS=","; print "ID,class1,class2,class3,class4,class5,class6,class7,class8,class9" }; { $$1=$$1; print $$0 } ' $^ > $@ 


############

slv-sets = mycvs test
slv-ans-sets = mycvs
slv-idx-sets = mycvs
ext = 1338x100x100x9-1-1-0-5

SLV-SETS = $(addsuffix _$(ext).slv,$(slv-sets))
SLV-ANS-SETS = $(addsuffix _$(ext)_ans.slv,$(slv-ans-sets))
ANS-IDX-SETS = $(addsuffix _$(ext)_index.ans,$(slv-ans-sets))
SLV-IDX-SETS = $(addsuffix _$(ext)_index.slv,$(slv-ans-sets))

SLV = $(SLV-SETS) $(SLV-ANS-SETS) $(ANS-IDX-SETS) $(SLV-IDX-SETS) test_$(ext)_ids.slv

.PHONY:	solve
solve:	$(SLV)

%_$(ext)_index.ans:	%.ans
	awk ' { max=0; maxi=1; for (i=1; i<=NF; i++) { if ($$i > max) { max=$$i; maxi=i } } print maxi } ' $^ > $@

%_index.slv:	%.slv
	awk ' { max=0; maxi=1; for (i=1; i<=NF; i++) { if ($$i > max) { max=$$i; maxi=i } } print maxi } ' $^ > $@

%_$(ext)_ans.slv:	%.ans %_$(ext).slv
	paste -d' ' $^ > $@

%_ids.slv:	%.ids %.slv
	paste -d' ' $^ > $@

test_%.ids:	test_variants
	awk -F, ' { if (NR != 1) print $$1 } ' $^ > $@

mycvs_%.slv:	mytrain_%.wts mycvs.xw
	neunet solve $(ARCH) --weights=$(word 1,$^) $(word 2,$^) > $@

test_%.slv:	alltrain_%.wts test.xw
	neunet solve $(ARCH) --weights=$(word 1,$^) $(word 2,$^) > $@

############

# $(ARCH)-$(LAMBDA)-$(LRATE)-$(REG)-$(BSIZE)

NINPUTS = 1338
NOUTPUTS = 9
ARCHS = 30 30x30 100 100x100
LAMBDAS = 
LRATES = 0.1 1 10

ARCH-ARRAY = $(addprefix $(NINPUTS)x,$(addsuffix x$(NOUTPUTS),$(ARCHS)))

solve-pfx = \
mytrain_$(ARCHX)-05-1-1-50\
mytrain_$(ARCHX)-05-1-1-100\
mytrain_$(ARCHX)-15-1-1-50\
mytrain_$(ARCHX)-15-1-1-100\
mytrain_$(ARCHX)-1-1-0-50\
mytrain_$(ARCHX)-1-1-0-100\
mytrain_944x300x300x9-1-1-0-50\
mytrain_944x100x100x100x9-1-1-0-50\
mytrain_944x100x100x100x9-1-2-0-50

OBS = $(addsuffix .obs,$(solve-pfx))
COMB = $(addsuffix .comb,$(solve-pfx))
PROB = $(addsuffix .prob,$(solve-pfx))

.PHONY:	solve2
solve2:	$(OBS) $(COMB) $(PROB)


%.prob:	%.comb
	awk ' { if ($$1==$$2) a++; n++ }; END { print a,n,a/n } ' $^ > $@

%.comb:	%.ibs pre_mycvs.ans
	paste -d' ' $^ > $@

%.ibs:	%.obs
	awk ' { M=0; MAX=0.0; for (i=1; i<=9; i++) { if ($$i > MAX) { MAX=$$i; M=i } } print M } ' $^ > $@


mytrain_$(ARCHX)-05-1-1-50.obs:	mytrain_$(ARCHX)-05-1-1-50.wts mycvs.xw
	neunet solve $(ARCH) --weights=$(word 1,$^) $(word 2,$^) > $@

mytrain_$(ARCHX)-05-1-1-100.obs:	mytrain_$(ARCHX)-05-1-1-100.wts mycvs.xw
	neunet solve $(ARCH) --weights=$(word 1,$^) $(word 2,$^) > $@

mytrain_$(ARCHX)-15-1-1-50.obs:	mytrain_$(ARCHX)-15-1-1-50.wts mycvs.xw
	neunet solve $(ARCH) --weights=$(word 1,$^) $(word 2,$^) > $@

mytrain_$(ARCHX)-15-1-1-100.obs:	mytrain_$(ARCHX)-15-1-1-100.wts mycvs.xw
	neunet solve $(ARCH) --weights=$(word 1,$^) $(word 2,$^) > $@


mytrain_$(ARCHX)-1-1-0-50.obs:	mytrain_$(ARCHX)-1-1-0-50.wts mycvs.xw
	neunet solve $(ARCH) --weights=$(word 1,$^) $(word 2,$^) > $@

mytrain_$(ARCHX)-1-1-0-100.obs:	mytrain_$(ARCHX)-1-1-0-100.wts mycvs.xw
	neunet solve $(ARCH) --weights=$(word 1,$^) $(word 2,$^) > $@


mytrain_944x300x300x9-1-1-0-50.obs:	mytrain_944x300x300x9-1-1-0-50.wts mycvs.xw
	neunet solve 944,300,300,9 --weights=$(word 1,$^) $(word 2,$^) > $@


mytrain_944x100x100x100x9-1-1-0-50.obs:	mytrain_944x100x100x100x9-1-1-0-50.wts mycvs.xw
	neunet solve 944,100,100,100,9 --weights=$(word 1,$^) $(word 2,$^) > $@

mytrain_944x100x100x100x9-1-2-0-50.obs:	mytrain_944x100x100x100x9-1-2-0-50.wts mycvs.xw
	neunet solve 944,100,100,100,9 --weights=$(word 1,$^) $(word 2,$^) > $@


WTS = $(addsuffix .wts,$(solve-pfx))

.PHONY:	learn
learn:	$(WTS)

mytrain_$(ARCHX)-05-1-1-50.wts:	mytrain_ans.xw
	neunet learn $(ARCH) --weights=rSQRT --nepochs=2400 --bsize=50 --lrate=1 --lambda=0.5 --reg=1 $^ 2> mytrain_$(ARCHX)-05-1-1-50.err > $@

mytrain_$(ARCHX)-05-1-1-100.wts:	mytrain_ans.xw
	neunet learn $(ARCH) --weights=rSQRT --nepochs=1200 --bsize=100 --lrate=1 --lambda=0.5 --reg=1 $^ 2> mytrain_$(ARCHX)-05-1-1-100.err > $@

mytrain_$(ARCHX)-15-1-1-50.wts:	mytrain_ans.xw
	neunet learn $(ARCH) --weights=rSQRT --nepochs=2400 --bsize=50 --lrate=1 --lambda=1.5 --reg=1 $^ 2> mytrain_$(ARCHX)-15-1-1-50.err > $@

mytrain_$(ARCHX)-15-1-1-100.wts:	mytrain_ans.xw
	neunet learn $(ARCH) --weights=rSQRT --nepochs=1200 --bsize=100 --lrate=1 --lambda=1.5 --reg=1 $^ 2> mytrain_$(ARCHX)-15-1-1-100.err > $@


mytrain_$(ARCHX)-1-1-0-50.wts:	mytrain_ans.xw
	neunet learn $(ARCH) --weights=rSQRT --nepochs=2400 --bsize=50 --lrate=1 --lambda=1 --reg=0 $^ 2> mytrain_$(ARCHX)-1-1-0-50.err > $@

mytrain_$(ARCHX)-1-1-0-100.wts:	mytrain_ans.xw
	neunet learn $(ARCH) --weights=rSQRT --nepochs=1200 --bsize=100 --lrate=1 --lambda=1 --reg=0 $^ 2> mytrain_$(ARCHX)-1-1-0-100.err > $@


mytrain_944x300x300x9-1-1-0-50.wts:	mytrain_ans.xw
	neunet learn 944,300,300,9 --weights=rSQRT --nepochs=2400 --bsize=50 --lrate=1 --lambda=1 --reg=0 $^ 2> mytrain_944x300x300x9-1-1-0-50.err > $@


mytrain_944x100x100x100x9-1-1-0-50.wts:	mytrain_ans.xw
	neunet learn 944,100,100.100.9 --weights=rSQRT --nepochs=2400 --bsize=50 --lrate=1 --lambda=1 --reg=0 $^ 2> mytrain_944x100x100x100x9-1-1-0-50.err > $@

mytrain_944x100x100x100x9-1-2-0-50.wts:	mytrain_ans.xw
	neunet learn 944,100,100.100.9 --weights=rSQRT --nepochs=2400 --bsize=50 --lrate=2 --lambda=1 --reg=0 $^ 2> mytrain_944x100x100x100x9-1-2-0-50.err > $@

############

.PHONY:	pca2
pca2:	test.xw mytrain_ans.xw mycvs_ans.xw mytest_ans.xw mytrain.xw mycvs.xw mytest.xw pcplot.png mytrain.ans mycvs.ans mytest.ans

#pcplot.png:	training_ids.xw $(RAW)training_variants training.xw
#	Rscript $(SCR)pca.r $^ $@

%_ans.xw:	%.xw %.ans
	paste -d ' ' $^ > $@

%.ans:	pre_%.ans
	awk ' { sep=""; for (i=1; i<=9; i++) { a=0; if (i==$$1) a=1; printf sep""a; sep=" " } print "" } ' $^ > $@

%.xw:	%.nrm mytrain.vt
	python ~/repos/pca/project.py $^ $@

%.vt:	%.nrm
	python ~/repos/pca/pca.py $^ $@ 0.95

############

.PHONY:	normalise
normalise:	test.nrm mytrain.nrm mycvs.nrm mytest.nrm

#training.nrm:	training.raw training.mu training.sigma
#	python ~/repos/pca/normalise_alt.py $(word 1,$^) $(word 2,$^) $(word 3,$^) $@

test.nrm:	test.raw mytrain.mu mytrain.sigma
	python ~/repos/pca/normalise_alt.py $(word 1,$^) $(word 2,$^) $(word 3,$^) $@

my%.nrm:	my%.raw mytrain.mu mytrain.sigma
	python ~/repos/pca/normalise_alt.py $(word 1,$^) $(word 2,$^) $(word 3,$^) $@


.PHONY:	subset
subset:	test.raw training.raw mytrain.raw mycvs.raw mytest.raw

%.raw:	pre_%.raw pre_mytrain.mu pre_mytrain.sigma
	python ~/repos/pca/subset.py $^ $@ $*.mu $*.sigma

test.raw:	test.uraw pre_mytrain.mu pre_mytrain.sigma
	python ~/repos/pca/subset.py $^ $@ test.mu test.sigma


.PHONY:	mean-sigma
mean-sigma:	training.mu training.sigma mytrain.mu mytrain.sigma pre_mytrain.mu pre_mytrain.sigma

%.mu:	%.raw
	python ~/repos/pca/mean.py $^ $@

%.sigma:	%.raw
	python ~/repos/pca/sigma.py $^ $@


.PHONY:	data-split
data-split:	pre_mytrain.raw mytrain.ids pre_mytrain.ans pre_mycvs.raw mycvs.ids pre_mycvs.ans pre_mytest.raw mytest.ids pre_mytest.ans

pre_mytrain.raw:	pre_training.raw
	head -n 1993 $^ > $@

mytrain.ids:	training.ids
	head -n 1993 $^ > $@

pre_mytrain.ans:	pre_training.ans
	head -n 1993 $^ > $@

pre_mycvs.raw:	pre_training.raw
	head -n 2657 $^ | tail -n 664 > $@

mycvs.ids:	training.ids
	head -n 2657 $^ | tail -n 664 > $@

pre_mycvs.ans:	pre_training.ans
	head -n 2657 $^ | tail -n 664 > $@

pre_mytest.raw:	pre_training.raw
	tail -n 664 $^ > $@

mytest.ids:	training.ids
	tail -n 664 $^ > $@

pre_mytest.ans:	pre_training.ans
	tail -n 664 $^ > $@


.PHONY:	shuffle
shuffle:	pre_training.raw training.ids pre_training.ans

pre_training.ans:	$(RAW)training_text training_ans.uraw
	shuf --random-source=$(word 1,$^) $(word 2,$^) > $@

pre_training.raw:	$(RAW)training_text training.uraw
	shuf --random-source=$(word 1,$^) $(word 2,$^) > $@

training.ids:	$(RAW)training_text training.uids
	shuf --random-source=$(word 1,$^) $(word 2,$^) > $@

training_ans.uraw:	$(RAW)training_variants
	grep "^ID" -v $^ | awk -F, ' { print $$NF } ' > $@

############

raw-count = $(addsuffix .uraw,$(datasets))
ids-count = $(addsuffix .uids,$(datasets))
word-count = $(addprefix $(pfx),$(addsuffix .count,$(datasets)))

.PHONY:	count
count:	$(word-count) $(ids-count) $(raw-count)

%.uraw:	uniq_words.txt $(pfx)%.count
	~/repos/chargrok/bin/chargrok $^ > $@

%.uids:	$(pfx)%.count
	cut -d' ' -f 1 $^ | uniq > $@

%.count:	%.nline
	sort $^ | uniq -c | awk -F, ' { print $$1,$$2 } ' | awk ' { print $$3,$$2,$$1 } ' | sort -k1,1n -k2,2g > $@


############

.PHONY:	word-discovery
word-discovery:	uniq_words.txt

uniq_words.txt:	$(pfx)training.nline
	cut -d',' -f 1 $^ | grep "[^a-z]" -v | grep "[^actgu]" | awk ' { if (length($$1) < 20 && length($$1) > 4) print $$1 } ' | sort | uniq -c | awk ' { if ($$1 > 75) print $$2 }' > $@


############

nline-text = $(addprefix $(pfx),$(subst .both,.nline,$(data-both)))

.PHONY:	nline
nline:	$(nline-text)

%.nline:	%.both
	awk ' { $$1=$$1; for (i=2; i<=NF; i++) print $$i","$$1 } ' $^ | tr -d '[:blank:]' > $@


############

filtered-text = $(addprefix $(pfx),$(data-both))

.PHONY:	text-filter
text-filter:	$(filtered-text)

pnc_%.both:	%.both
	tr '[\t()\.,;:{}*%~\"]' ' ' < $^ | tr -s ' ' > $@

pval_%.both:	%.both
	sed -e 's/p-value/pvalue/g' < $^ | sed -e 's/pvalues/pvalue/g' | sed -e 's/pvalue < /pvalue</g' | sed -e 's/pvalue = /pvalue=/g' | sed -e 's/pvalue</pvalueless /g' | sed -e 's/pvalue=/pvalueequal /g' > $@

lwr_%.both:	raw_%.both
	tr '[:upper:]' '[:lower:]' < $^ > $@


############

split-both = $(addprefix raw_,$(data-both))
split-ids = $(addprefix raw_,$(data-ids))
split-text = $(addprefix raw_,$(data-text))

.PHONY:	split-cols
split-cols:	$(split-ids) $(split-text) $(split-both)

raw_%.both:	$(RAW)%_text
	awk -F"[|][|]" ' { if (NR != 1) print $$1,$$2 } ' $^ > $@

raw_%.ids:	$(RAW)%_text
	awk -F"[|][|]" ' { if (NR != 1) print $$1 } ' $^ > $@

raw_%.text:	$(RAW)%_text
	awk -F"[|][|]" ' { if (NR != 1) print $$2 } ' $^ > $@

HOME = $(shell echo $$HOME)/
BASE = $(HOME)projects/cancer/

# In:
#	data/feat/mycvs.xw
#	data/feat/mytest.xw
#	data/feat/alltest.xw
#	data/feat/pre_mycvs.ans
#	data/feat/pre_mytest.ans
#	data/feat/mytrain_ans.xw
#	data/feat/alltrain_ans.xw
#	raw/stage12/test_variants
#
# Out:
#	data/output/mytrain_*.wts
#	data/output/alltrain_*.wts
#
#	data/output/mycvs_*.obs
#	data/output/mytest_*.obs
#	data/output/alltest_*.obs
#
#	data/output/mycvs_*.ibs
#	data/output/mytest_*.ibs
#	data/output/alltest_*.ibs
#
#	data/output/mycvs_*.log
#	data/output/mycvs_*.prob
#
#	data/output/mytest_*.log
#	data/output/mytest_*.prob
#
#	data/output/alltest_*.sub
#
# Dependencies:
#	neunet ('https://github.com/mspopgen/neunet'), python2
#
# Scripts:
#	logcalc.py

DATA = $(BASE)data/
RAW = $(BASE)raw/
SCR = $(BASE)scripts/
SUB = $(BASE)submissions/

STG12 = $(RAW)stage12/

FEAT = $(DATA)feat/
WTS = $(DATA)wts/
SLV = $(DATA)output/

############

comma := ,

HYPER = \
-1-1-0-100\
-1-1-1-100\
-10-1-1-100\
-20-1-1-100

ARCH = \
1085,50,50,50,9\
1085,100,100,9\
1085,100,50,30,9\
1085,100,50,50,9\
1085,300,50,30,9
#1085,300,300,9

ARCHX = $(subst $(comma),x,$(ARCH))
HYPERX = $(foreach arch,$(ARCHX),$(addprefix $(arch),$(HYPER)))

############

ALLTEST-SUB = $(addprefix $(SUB)alltest_,$(addsuffix _ids.sub,$(HYPERX)))

.PHONY:	submit
submit:	$(ALLTEST-SUB)

$(SUB)alltest_%_ids.sub:	$(SLV)alltest_%_ids.obs
	awk ' BEGIN { OFS=","; print "ID,class1,class2,class3,class4,class5,class6,class7,class8,class9" }; { $$1=$$1; print $$0 } ' $^ > $@

$(SLV)alltest_%_ids.obs:	$(SLV)alltest_%.ids $(SLV)alltest_%.obs
	paste -d, $^ > $@

$(SLV)alltest_%.ids:	$(STG12)test_variants
	awk -F, ' { if (NR != 1) print $$1 } ' $^ > $@


############

MYCVS-IBS = $(addprefix $(SLV)mycvs_,$(addsuffix .ibs,$(HYPERX)))
MYCVS-COMB = $(addprefix $(SLV)mycvs_,$(addsuffix .comb,$(HYPERX)))
MYCVS-PROB = $(addprefix $(SLV)mycvs_,$(addsuffix .prob,$(HYPERX)))
MYCVS-LOG = $(addprefix $(SLV)mycvs_,$(addsuffix .log,$(HYPERX)))

.PHONY:	assess
assess:	$(MYCVS-IBS) $(MYCVS-COMB) $(MYCVS-PROB) $(MYCVS-LOG) $(SLV)mytest_1085x100x50x30x9-10-1-1-100.log $(SLV)mytest_1085x100x50x50x9-10-1-1-100.log $(SLV)mytest_1085x100x100x9-10-1-1-100.log $(SLV)mytest_1085x100x100x9-20-1-1-100.log $(SLV)mytest_1085x100x50x30x9-20-1-1-100.log $(SLV)mytest_1085x300x300x9-10-1-1-100.log $(SLV)mytest_1085x300x50x30x9-10-1-1-100.log

$(SLV)%.prob:	$(SLV)%.comb
	awk ' { if ($$1==$$2) a++; n++ }; END { print a,n,a/n } ' $^ > $@

$(SLV)mycvs_%.comb:	$(SLV)mycvs_%.ibs $(FEAT)pre_mycvs.ans
	paste -d' ' $^ > $@

$(SLV)mytest_%.comb:	$(SLV)mytest_%.ibs $(FEAT)pre_mytest.ans
	paste -d' ' $^ > $@

$(SLV)%.ibs:	$(SLV)%.obs
	awk ' { M=0; MAX=0.0; for (i=1; i<=9; i++) { if ($$i > MAX) { MAX=$$i; M=i } } print M } ' $^ > $@

$(SLV)%.log:	$(SLV)%.expobs
	python $(SCR)logcalc.py $^ > $@

$(SLV)mycvs_%.expobs:	$(FEAT)mycvs.ans $(SLV)mycvs_%.obs
	paste -d' ' $^ > $@

$(SLV)mytest_%.expobs:	$(FEAT)mytest.ans $(SLV)mytest_%.obs
	paste -d' ' $^ > $@

############

MYCVS-OBS = $(addprefix $(SLV)mycvs_,$(addsuffix .obs,$(HYPERX)))
MYTEST-OBS = $(addprefix $(SLV)mytest_,$(addsuffix .obs,$(HYPERX)))
ALLTEST-OBS = $(addprefix $(SLV)alltest_,$(addsuffix .obs,$(HYPERX)))

.PHONY:	solve
solve:	$(MYCVS-OBS) $(MYTEST-OBS) $(ALLTEST-OBS)

$(SLV)mycvs_%-1-1-0-100.obs:	$(WTS)mytrain_%-1-1-0-100.wts $(FEAT)mycvs.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@

$(SLV)mycvs_%-1-1-1-100.obs:	$(WTS)mytrain_%-1-1-1-100.wts $(FEAT)mycvs.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@

$(SLV)mycvs_%-10-1-1-100.obs:	$(WTS)mytrain_%-10-1-1-100.wts $(FEAT)mycvs.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@

$(SLV)mycvs_%-20-1-1-100.obs:	$(WTS)mytrain_%-20-1-1-100.wts $(FEAT)mycvs.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@

$(SLV)mycvs_%-50-1-1-100.obs:	$(WTS)mytrain_%-50-1-1-100.wts $(FEAT)mycvs.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@


$(SLV)mytest_%-1-1-0-100.obs:	$(WTS)mytrain_%-1-1-0-100.wts $(FEAT)mytest.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@

$(SLV)mytest_%-1-1-1-100.obs:	$(WTS)mytrain_%-1-1-1-100.wts $(FEAT)mytest.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@

$(SLV)mytest_%-10-1-1-100.obs:	$(WTS)mytrain_%-10-1-1-100.wts $(FEAT)mytest.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@

$(SLV)mytest_%-20-1-1-100.obs:	$(WTS)mytrain_%-20-1-1-100.wts $(FEAT)mytest.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@

$(SLV)mytest_%-50-1-1-100.obs:	$(WTS)mytrain_%-50-1-1-100.wts $(FEAT)mytest.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@


$(SLV)alltest_%-1-1-0-100.obs:	$(WTS)alltrain_%-1-1-0-100.wts $(FEAT)alltest.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@

$(SLV)alltest_%-1-1-1-100.obs:	$(WTS)alltrain_%-1-1-1-100.wts $(FEAT)alltest.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@

$(SLV)alltest_%-10-1-1-100.obs:	$(WTS)alltrain_%-10-1-1-100.wts $(FEAT)alltest.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@

$(SLV)alltest_%-20-1-1-100.obs:	$(WTS)alltrain_%-20-1-1-100.wts $(FEAT)alltest.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@

$(SLV)alltest_%-50-1-1-100.obs:	$(WTS)alltrain_%-50-1-1-100.wts $(FEAT)alltest.xw
	neunet solve $(subst x,$(comma),$*) --weights=$(word 1,$^) $(word 2,$^) > $@



############

MYTRAIN-WTS = $(addprefix $(WTS)mytrain_,$(addsuffix .wts,$(HYPERX)))
ALLTRAIN-WTS = $(addprefix $(WTS)alltrain_,$(addsuffix .wts,$(HYPERX)))

.PHONY:	learn
learn:	$(MYTRAIN-WTS) $(ALLTRAIN-WTS)

$(WTS)mytrain_%-1-1-0-100.wts:	$(FEAT)mytrain_ans.xw
	neunet learn $(subst x,$(comma),$*) --weights=rSQRT --nepochs=2400 --bsize=100 --lrate=1 --lambda=1 --reg=0 $^ 2> $(subst .wts,.err,$@) > $@

$(WTS)mytrain_%-1-1-1-100.wts:	$(FEAT)mytrain_ans.xw
	neunet learn $(subst x,$(comma),$*) --weights=rSQRT --nepochs=2400 --bsize=100 --lrate=1 --lambda=1 --reg=1 $^ 2> $(subst .wts,.err,$@) > $@

$(WTS)mytrain_%-10-1-1-100.wts:	$(FEAT)mytrain_ans.xw
	neunet learn $(subst x,$(comma),$*) --weights=rSQRT --nepochs=2400 --bsize=100 --lrate=1 --lambda=10 --reg=1 $^ 2> $(subst .wts,.err,$@) > $@

$(WTS)mytrain_%-20-1-1-100.wts:	$(FEAT)mytrain_ans.xw
	neunet learn $(subst x,$(comma),$*) --weights=rSQRT --nepochs=2400 --bsize=100 --lrate=1 --lambda=20 --reg=1 $^ 2> $(subst .wts,.err,$@) > $@

$(WTS)mytrain_%-50-1-1-100.wts:	$(FEAT)mytrain_ans.xw
	neunet learn $(subst x,$(comma),$*) --weights=rSQRT --nepochs=2400 --bsize=100 --lrate=1 --lambda=50 --reg=1 $^ 2> $(subst .wts,.err,$@) > $@


$(WTS)alltrain_%-1-1-0-100.wts:	$(FEAT)alltrain_ans.xw
	neunet learn $(subst x,$(comma),$*) --weights=rSQRT --nepochs=2400 --bsize=100 --lrate=1 --lambda=1 --reg=0 $^ 2> $(subst .wts,.err,$@) > $@

$(WTS)alltrain_%-1-1-1-100.wts:	$(FEAT)alltrain_ans.xw
	neunet learn $(subst x,$(comma),$*) --weights=rSQRT --nepochs=2400 --bsize=100 --lrate=1 --lambda=1 --reg=1 $^ 2> $(subst .wts,.err,$@) > $@

$(WTS)alltrain_%-10-1-1-100.wts:	$(FEAT)alltrain_ans.xw
	neunet learn $(subst x,$(comma),$*) --weights=rSQRT --nepochs=2400 --bsize=100 --lrate=1 --lambda=10 --reg=1 $^ 2> $(subst .wts,.err,$@) > $@

$(WTS)alltrain_%-20-1-1-100.wts:	$(FEAT)alltrain_ans.xw
	neunet learn $(subst x,$(comma),$*) --weights=rSQRT --nepochs=2400 --bsize=100 --lrate=1 --lambda=20 --reg=1 $^ 2> $(subst .wts,.err,$@) > $@

$(WTS)alltrain_%-50-1-1-100.wts:	$(FEAT)alltrain_ans.xw
	neunet learn $(subst x,$(comma),$*) --weights=rSQRT --nepochs=2400 --bsize=100 --lrate=1 --lambda=50 --reg=1 $^ 2> $(subst .wts,.err,$@) > $@

HOME = $(shell echo $$HOME)/
BASE = $(HOME)projects/cancer/

# In:
# 	raw/stage1/test_text.zip
#	raw/stage1/test_variants.zip
# 	raw/stage1/training_text.zip
#	raw/stage1/training_variants.zip
#
#	raw/stage2/stage2_test_text.csv.7z
#	raw/stage2/stage2_test_variants.csv.7z
#	raw/stage2/stage1_solution_filtered.csv.7z
#	raw/stage2/stage2_sample_submission.csv.7z
#
# Out:
#	raw/stage12/test_text
# 	raw/stage12/test_variants
# 	raw/stage12/training_text
# 	raw/stage12/training_variants
#
# Dependencies:
#	zip, 7za

RAW = $(BASE)raw/
STG1 = $(RAW)stage1/
STG2 = $(RAW)stage2/
STG12 = $(RAW)stage12/

datasets = test training

############
# Merge in new data revealed in stage2

# just double check that the _variants and the _text files of the
# new data are in the same order. [OK]

.PHONY:	combine-stage12
combine-stage12:	$(STG12)training_variants $(STG12)training_text $(STG12)test_variants $(STG12)test_text

$(STG12)training_variants:	$(STG1)training_variants $(STG2)extra_training_variants
	cat $^ > $@

$(STG12)training_text:	$(STG1)training_text $(STG2)extra_training_text
	cat $^ > $@


$(STG12)test_variants:	$(STG2)stage2_test_variants.csv
	cat $^ > $@

$(STG12)test_text:	$(STG2)stage2_test_text.csv
	cat $^ > $@


.PHONY:	stage2-reveal
stage2-reveal:	$(STG2)extra_training_variants $(STG2)extra_training_text

$(STG2)extra_training_text:	$(STG2)extra_training.text
	awk -F"[|][|]" ' BEGIN { n=3321 }; { print n"||"$$2; n++ } ' $^ > $@

$(STG2)extra_training_variants:	$(STG2)stage1_solution_filtered.class $(STG1)test_variants
	awk -F, ' BEGIN { OFS="," }; NR==FNR { A[$$1]=$$2; n=3321; next }; { if ($$1 in A) { print n,$$2,$$3,A[$$1]; n++ } } ' $^ > $@

$(STG2)stage1_solution_filtered.class:	$(STG2)stage1_solution_filtered.csv
	awk -F, ' { if (NR != 1) { m=0; for (i=2; i<=NF; i++) { if ($$i==1) m=(i-1); } print $$1","m } } ' $^ > $@

$(STG2)extra_training.var:	$(STG2)extra_training.vrgx $(STG1)test_variants
	grep -f $(word 1,$^) $(word 2,$^) > $@

$(STG2)extra_training.text:	$(STG2)extra_training.trgx $(STG1)test_text
	grep -f $(word 1,$^) $(word 2,$^) > $@

$(STG2)extra_training.vrgx:	$(STG2)stage1_solution_filtered.csv
	grep "^ID" -v $^ | cut -d',' -f 1 | awk ' { print "^"$$0"," } ' > $@

$(STG2)extra_training.trgx:	$(STG2)stage1_solution_filtered.csv
	grep "^ID" -v $^ | cut -d',' -f 1 | awk ' { print "^"$$0"||" } ' > $@


############
# Decompress

raw-text = $(addprefix $(STG1),$(addsuffix _text,$(datasets)))
raw-variants = $(addprefix $(STG1),$(addsuffix _variants,$(datasets)))

.PHONY:	decompress1
decompress1:	$(raw-text) $(raw-variants)

%:	%.zip
	unzip -p $^ > $@


stage2-files = \
stage1_solution_filtered\
stage2_sample_submission\
stage2_test_text\
stage2_test_variants

raw-stage2 = $(addprefix $(STG2),$(addsuffix .csv,$(stage2-files)))

.PHONY:	decompress2
decompress2:	$(raw-stage2)

%.csv:	%.csv.7z
	7za e -so $^ > $@

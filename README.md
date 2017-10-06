# Kaggle Competition - Personalized Medicine: Redefining Cancer Treatment

## Summary

*"Predict the effect of Genetic Variants to enable Personalized Medicine"*

The training data consisted of 3690 scientific manuscripts that had been assigned a mutation 
type (integers 1-9) by members in the scientific community. The goal of the competition was to 
process the text in the manuscripts and train an algorithm that assigns a mutation type to each 
manuscript such that the log loss is minimised. I opted for a "*bag of words*" technique on bigram 
adjacent words, PCA to reduce the dimensions of the feature set, and a neural network with 
mini-batch stochastic gradient descent and L2 regularization to train the model. Here are some more 
details:


### Filtering (see B_getfeat/Makefile for details)

- Convert upper -> lower
- Collapse "pvalue = " & "pvalue < " variations into "pvalueequal" & "pvalueless"
- Remove punctuation and collapse whitespace to single space
- Remove words that contain letters that are not a-z
- Remove words that contain only a, t, g, c, or u
- Keep only words with length > 3 && < 20
- Order adjacent words alphabetically and concatenate separated by dash
  ("significant result" -> "result-significant") to create word bigrams
- Keep only pairs of words that occur > 175 times in total accross all manuscripts

### Obtain features (see B_getfeat/Makefile for details)

- Count number of occurances of each bigram in each training example (manuscript)
- Shuffle training set and split into training (80%) and test (20%) datasets,
  then split training once again into training (80%) and cross-validation (20%).
  This gives three datasets called "mytrain", "mycvs" and "mytest" with 2952, 590
  and 737 examples in each
- Calculate the mean and standard deviation of "mytrain"
- Filter out features in mytrain, mycvs and mytest where the standard deviation
  is zero
- Normalise mytrain, mycvs and mytest using the mean and standard deviation of
  mytrain
- Perform PCA on mytrain and use this to project mycvs and mytest onto the mytrain
  vector space to get the features for each dataset (giving 1086 features covering 
  95% of the variation)
- Check that all three datasets have been projected into the same vector space:

![](pca_check.png)

*First 8 principal components for mytrain (dark grey), mycvs (red) and mytest (blue)*

### Training (see C_train/Makefile for details)

- Neural networks using mini-batch stochastic gradient descent and L2 normalisation
- Most architures seemed to be converging on a common training set error rate:

![](archerr.png)

*Decrease in training error for 6 different network architectures as a function of the number of epochs*

- Most architectures gave a CVS log loss in a range of 1-2
- Using regularization tended to reduce the log loss in the CVS and test datasets
- There was, however, an optimal value of lambda for each architecture (lambda = 50 was tested and generalized much worse)
- Arch 100,100 with lambda=20 was chosen as it gave consistently low log losses for both validation sets
- Arch 100,50,30 with lambda=10 also performed consistently and was also selected

*Optimizing architecture and regularization (bold type indicates the final two submissions)*

Arch | lambda | prob | cvs log loss | test log loss
--- | --- | --- | --- | ---
100,100 | NA | 0.636 | 1.93 | - 
100,100 | 10 | 0.631 | 1.23 | 1.30
**100,100** | **20** | **0.605** | **1.19** | **1.18**
300,300 | NA | 0.625 | 1.80 | - 
300,300 | 10 | 0.624 | 1.24 | 1.35
300,300 | 20 | 0.591 | 1.20 | -
50,50,50 | NA | 0.617 | 1.82 | - 
50,50,50 | 10 | 0.615 | 1.25 | - 
50,50,50 | 20 | 0.453 | 1.47 | - 
100,50,30 | NA | 0.641 | 1.86 | 
**100,50,30** | **10** | **0.653** | **1.12** | **1.26**
100,50,30 | 20 | 0.247 | 1.12 | 1.84

### Conclusions

- It seems like I was unable to optimize the neural network parameters much more and that 
  I likely reached an information limit imposed either by the underlying the data (i.e. 
  there just isn't enough information in a manuscript to progress further) or with my approach
- It is likely that processing the text in a more context aware manner would lead to better results
- It is also possible that stacking machine learning models would yield better results, although 
  it is unclear whether the text processing step would ultimately limit improvements
- Would a PCA + kmeans approach work equally well? The number of dimensions may hinder kmeans but 
  it would be interesting to pursue whether this approach would do as well as the neural network 
  approach I went for





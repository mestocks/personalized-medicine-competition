import sys
import numpy

fname = sys.argv[1]
fmu = sys.argv[2]
fsigma = sys.argv[3]

fnameout = sys.argv[4]
fmuout = sys.argv[5]
fsigmaout = sys.argv[6]

digits = numpy.loadtxt(fname)
mu = numpy.loadtxt(fmu)
sigma = numpy.loadtxt(fsigma)
equal_zero = sigma != 0



new_mu = mu[equal_zero]
new_sigma = sigma[equal_zero]
print digits
print ""
print equal_zero
new_digits = digits[:,equal_zero]
print new_digits
numpy.savetxt(fnameout, new_digits, fmt = "%.5f", delimiter = " ")
numpy.savetxt(fmuout, new_mu, fmt = "%.5f", delimiter = " ")
numpy.savetxt(fsigmaout, new_sigma, fmt = "%.5f", delimiter = " ")

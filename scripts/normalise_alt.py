import sys
import numpy

fname = sys.argv[1]
fmu = sys.argv[2]
fsigma = sys.argv[3]
fout = sys.argv[4]

digits = numpy.loadtxt(fname)
mu = numpy.loadtxt(fmu)
sigma = numpy.loadtxt(fsigma)

digits = digits - mu
digits = digits / sigma

numpy.savetxt(fout, digits, fmt = "%.5f", delimiter = " ")


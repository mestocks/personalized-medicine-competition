import sys
import numpy

fname = sys.argv[1]
fout = sys.argv[2]

digits = numpy.loadtxt(fname)
sigma = numpy.std(digits, axis = 0)
numpy.savetxt(fout, sigma, fmt = "%.5f", delimiter = " ")

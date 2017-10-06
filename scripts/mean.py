import sys
import numpy

fname = sys.argv[1]
fout = sys.argv[2]

digits = numpy.loadtxt(fname)
mu = numpy.mean(digits, axis = 0)
numpy.savetxt(fout, mu, fmt = "%.5f", delimiter = " ")

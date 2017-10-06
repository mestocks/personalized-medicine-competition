import sys
import numpy

fname = sys.argv[1]
fvt = sys.argv[2]
fout = sys.argv[3]

Vt = numpy.loadtxt(fvt)
print "Vt:", Vt.shape

digits = numpy.loadtxt(fname)
print "New:", digits.shape

ndata = numpy.dot(digits, Vt.T)
print "New data:", ndata.shape

print "Writing data to", fout
numpy.savetxt(fout, ndata, fmt = "%.5f", delimiter = " ")

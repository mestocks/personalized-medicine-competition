import sys
import numpy
from scipy import linalg

fname = sys.argv[1]
fout = sys.argv[2]
pvar = float(sys.argv[3])

print "loading digits..."
digits = numpy.loadtxt(fname)
print digits.shape

print "performing svd..."
U, s, Vt = linalg.svd(digits, full_matrices = False, overwrite_a = True)
print U.shape
print s.shape
print Vt.shape

c = 0
csum = 0.0
while csum < pvar:
    csum += (s[c] / sum(s))
    print c,s[c] / sum(s), csum
    c+=1

print "writing data..."
numpy.savetxt(fout, Vt[:c, :], fmt = "%.5f", delimiter = " ")

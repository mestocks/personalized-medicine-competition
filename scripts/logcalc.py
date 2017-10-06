import sys
import numpy

data = numpy.loadtxt(sys.argv[1])

N = len(data[:, 0])
exp = data[:, :9]
obs = data[:, 9:]

obs[obs == 0] = 0.000000000000001
sumobs = numpy.sum(obs, axis = 1)

for i in range(len(sumobs)):
    obs[i, :] = numpy.log(obs[i, :] / sumobs[i])


ndata = exp * obs
print -(1 / float(N)) * numpy.sum(ndata)


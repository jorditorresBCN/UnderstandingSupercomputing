from pycompss.api.task import task
from pycompss.api.parameter import *
import numpy as np


def initialize_variables():
    for matrix in [A, B]:
        for i in range(MSIZE):
            matrix.append([])
            for j in range(MSIZE):
                mb = createBlock(BSIZE)
                matrix[i].append(mb)
    for i in range(MSIZE):
        C.append([])
        for j in range(MSIZE):
            mb = createBlock(BSIZE, True)
            C[i].append(mb)


@task(returns=list)
def createBlock(BSIZE, res=False):
    if res:
        block = np.array(np.zeros((BSIZE, BSIZE)), dtype=np.double, copy=False)
    else:
        block = np.array(np.random.random((BSIZE, BSIZE)), dtype=np.double,
                         copy=False)
    mb = np.matrix(block, dtype=np.double, copy=False)
    return mb


@task(c=INOUT)
def multiply(a, b, c):
    c += a * b


if __name__ == "__main__":
    import sys
    import time
    from pycompss.api.api import compss_wait_on

    args = sys.argv[1:]

    MSIZE = int(args[0])
    BSIZE = int(args[1])

    A = []
    B = []
    C = []

    st = time.time()
    initialize_variables()
    eti = time.time()

    for i in range(MSIZE):
        for j in range(MSIZE):
            for k in range(MSIZE):
                multiply(A[i][k], B[k][j], C[i][j])

    #C = compss_wait_on(C)
    #print "Compute Time {} s".format(time.time() - eti)

    print "PARAMS:------------------"
    print "MSIZE: {}, BSIZE: {}".format(MSIZE, BSIZE)


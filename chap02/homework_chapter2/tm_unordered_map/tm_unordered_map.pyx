# distutils: language=c++
import cython
import numpy as np
cimport numpy as cnp
from libcpp.unordered_map cimport unordered_map

def hello():
    print("hello")


def target_mean_v2(data, y_name, x_name):
    result = np.zeros(data.shape[0])
    value_dict = dict()
    count_dict = dict()
    for i in range(data.shape[0]):
        if data.loc[i, x_name] not in value_dict.keys():
            value_dict[data.loc[i, x_name]] = data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] = 1
        else:
            value_dict[data.loc[i, x_name]] += data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] += 1
    for i in range(data.shape[0]):
        result[i] = (value_dict[data.loc[i, x_name]] - data.loc[i, y_name]) / (count_dict[data.loc[i, x_name]] - 1)
    return result

@cython.boundscheck(False)
@cython.wraparound(False)
cpdef target_mean_v3(data, str y_name, str x_name):
    cdef long nrow = data.shape[0]
    cdef cnp.ndarray[double] result = np.asfortranarray(np.zeros(nrow), dtype=np.float64)
    cdef cnp.ndarray[int] y = np.asfortranarray(data[y_name], dtype=np.int32)
    cdef cnp.ndarray[int] x = np.asfortranarray(data[x_name], dtype=np.int32)

    target_mean_v3_impl(result, y, x, nrow)
    return result

cdef void target_mean_v3_impl(double[:] result, int[:] y, int[:] x, const long nrow):
    cdef unordered_map[int, int] value_map
    cdef unordered_map[int, int] count_map

    cdef long i
    for i in range(nrow):
		
        if not value_map.count(x[i]):
            value_map[x[i]] = y[i]
            count_map[x[i]] = 1
        else:
            value_map[x[i]] += y[i]
            count_map[x[i]] += 1

    i=0
    for i in range(nrow):
        result[i] = (value_map[x[i]] - y[i])/(count_map[x[i]]-1 +0.00001)

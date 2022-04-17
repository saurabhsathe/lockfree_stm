# Cython basic example where we look at creating the same behavior as our add example (pybind11, swig)
#
# For the first example, we have simplified the code to work with only C. Note the 'int' and 'cpdef' 
# qualifiers.

# add two numbers
cpdef add(int x, int y):
  cdef int r = x + y
  return r

# subtract two numbers
cpdef subtract(int x, int y):
  cdef int r = x - y
  return r

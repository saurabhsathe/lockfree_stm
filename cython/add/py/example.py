# Cython basic example where we look at creating the same behavior as our add example (pybind11, swig)

class Calc:

  def __init__(self):
    pass

  # add two numbers
  def add(self, x, y):
    #cdef int r = x + y
    r = x + y
    return r

  # subtract two numbers
  def subtract(self, x, y):
    x - y

# ANDxorOR
[Challenge formulation](TBD)

## Expression simplification

We can try to simplify the expression either by hand or use some advance CAS as
SymPy. I choose the latter and here is how.

```python
from sympy.logic import simplify_logic
from sympy.abc import x,y,z
from sympy import S

e1 = x & y               # M1 and M2
e2 = x | y               # M1 or M2
e  = (e1 ^ e2) & (x ^ y) # S_i expression
simpify_logic(e)         # outputs (x and not y) or (y not x)
                         # which is the same as x xor y
                         # thus S_i simplifies to x ^ y
```

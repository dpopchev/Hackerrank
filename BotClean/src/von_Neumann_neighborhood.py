https://stackoverflow.com/a/11210728
In [1]: def von(r):
   ...:     for x in range(-r, r+1, 1):
   ...:         r_x = r - abs(x)
   ...:         for y in range(-r_x, r_x+1, 1):
   ...:             print(x, y)
   ...:

# Array Manipulation
[Challenge formulation](https://www.hackerrank.com/challenges/crush/problem)

# Discussion

Since all work was done in the Hackerrank environment, I did not create any
test cases.
Here you can find the function implementation only.

## Trivial solution
```python
# Complete the arrayManipulation function below.
# direct implementation of the algorithm
def arrayManipulation(n, queries):

    arr = [ 0 for _ in range(n) ]

    while(queries):
        # parse the query
        query_begin, query_end, query_val = queries.pop(0)

        # adjust the indexing to 1 indexed array
        query_begin-=1

        # python slicing includes the start index,
        # but does not include the end one -- this is way the end index needs no
        # adjusting
        # add the query value to each element
        arr[query_begin:query_end] = map(lambda x: x + query_val, arr[query_begin:query_end])

    # go through the array and return the maximum
    return max(arr)

```

## Optimal solution
TODO: poor comments, examples should be added later
```python
# Complete the arrayManipulation function below.
def arrayManipulation(n, queries):

    # the ranges will be filled in dictionary using the indexes as keys
    # the indexing defines regions of increment of the values
    # we need to keep track only of the start/end of region to know how much the
    # max value would be increment inside or would not be outside
    ranges = {}

    while(queries):
        # parse te query
        query_first, query_last, query_val = queries.pop(0)

        # if the index was not already encountered, add it to the dictionary with initial value 0
        # after that add/subtract the query value, depending on interval end
        ranges[query_first] = ranges.setdefault(query_first, 0) + query_val
        ranges[query_last+1] = ranges.setdefault(query_last+1, 0) - query_val

    maxval = 0
    runnigval = 0
    # sort all keys and seek the highes elevation
    for range in sorted(ranges):
        runnigval += ranges[range]
        maxval = maxval if maxval > runnigval else runnigval

    return maxval
```

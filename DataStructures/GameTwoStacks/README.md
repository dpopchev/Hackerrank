# Array Manipulation
[Challenge formulation](https://www.hackerrank.com/challenges/game-of-two-stacks/problem)

# Discussion

Since all work was done in the Hackerrank environment, I did not create any
test cases.
Here you can find the function implementation only.

## Solution algorithm

The following example will use the following two stacks:
- `stack_A` 19 9 8 13 1 7 10 20
- `stack_B` 3 5 14 19 19 15 22

1. Draw as many integers form stack A, e.g. `15 5 18 19`

1. Calculate the residue `R`, i.e. `sum_max - sum_A = 7`

1. Assume moves done on stack A is the maximum amount needed, e.g. `moves_max = moves_A`

1. Try to fit `R` into `stack_B`, add up the moves to current max moves and
calculate new `R`, e.g.  `3` is drawn from `stack_B`, update `moves_max += 1`
and `R = 4`.

1. In reverse order return all integers into `stack_A`, e.g. first will be `19`,
next will be `18` and so on to `15`

  - increase the residue with each integer `R += last_drawn_element_A`, e.g.
  `R += 19`

  - try to fit the `R = 23` into remaining `stack_B` and calculate new `R`, e.g.
  `R -= 5+14 = 4`

  - decrease `max_moves -= 1` as we have returned an element in to `stack_A`

  - increase with moves achieved by fitting `R` into `stack_B`,
  e.g. `moves_max += 2`

  - check if `move_max` is new maximum, if so save and continue

## Solution in `Perl`

```perl
#!/usr/bin/perl

sub twoStacks {

    # parse the input
    my $sum_max = shift;
    my $stack_A = shift;
    my $stack_B = shift;

    my $moves_max = 0;

    # take as many integers as possible form stack A
    my $moves_A = 0;
    my $sum_A = 0;
    for (@$stack_A){
        last if $sum_max - $sum_A - $_ < 0;

        $sum_A += $_;
        $moves_A += 1;
    }

    # presume stack A is sufficient
    my $cur_moves_max = $moves_A;

    # residue of stack A
    my $R = $sum_max - $sum_A;

    # all moves done on stack B
    my ($moves_B) = (0);
    for my $move_A (reverse 0..$moves_A){
        $R += $stack_A->[$move_A] if $move_A < $moves_A;

        my $local_moves_B = $moves_B;
        # slicing the array creates a new copy and the script bottlenecks
        # for large arrays
        # on other hand, shifting the first element and calculating size of array is O(1)
        # in contrast Python del 1 is with O(n)

        # not optimal foreach into slice of not drawn stack_B elements
        #for (@$stack_B[$moves_B..$stack_B_size-1]){

        # scalar and shift on array are O(1) in Perl
        while (scalar @$stack_B > 0){
            last if $R - $stack_B->[0] < 0;

            $cur_moves_max += 1;
            $moves_B += 1;
            $R -= shift @$stack_B;
        }

        $cur_moves_max -= 1 if $move_A < $moves_A;
        $moves_max = max($moves_max, $cur_moves_max);
    }

    return max($moves_max, $moves_A);
}
```

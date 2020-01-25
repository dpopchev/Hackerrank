#!/usr/bin/python

# Head ends here
BOARD_SIZE = 5

def create_distance_matrix(y, x, board):
    distance_matrix = []
    for r, row in enumerate(board):
        if 'd' in row:
            for c, col in enumerate(row):
                if col == 'd':
                    #if not (abs(r-y) + abs(c-x)) == 0:
                    distance_matrix.append([r-y,c-x,abs(r-y)+abs(c-x)])

    if distance_matrix:
        return sorted(distance_matrix, key=lambda _: _[-1]).pop(0)
    else:
        return distance_matrix

def next_move(posr, posc, board):

    direction = create_distance_matrix(posr, posc, board)
    if direction == None:
        pass

    leftright = lambda _: 'RIGHT' if _ > 0 else 'LEFT'
    updown = lambda _: 'DOWN' if _ > 0 else 'UP'

    if(
        ( direction[1] != 0
            and abs(direction[1]) < abs(direction[0]))
        or
        ( direction[1] != 0 and direction[2] != 0 )
    ):

        print(leftright(direction[1]))

    elif(
        ( direction[0] != 0
            and abs(direction[0]) < abs(direction[1]))
        or
        (direction[0] != 0 and direction[2] != 0)
    ):

        print(updown(direction[0]))

    else:
        print('CLEAN')

# Tail starts here

if __name__ == "__main__":
    pos = [int(i) for i in input().strip().split()]
    board = [[j for j in input().strip()] for i in range(BOARD_SIZE)]
    next_move(pos[0], pos[1], board)

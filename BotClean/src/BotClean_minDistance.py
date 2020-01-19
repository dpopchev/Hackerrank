#!/usr/bin/env python3

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

def seek_dirt(y, x, distance, direction, board):
    ''' check w.r.t. position (y, x) on board if there is a dirty spot to clean
    in provided direction at distance
    
    parameters:
        y, x:  int
            position on board w.r.t. to look towards direction

        distance: int
            maximum distance w.r.t. current position to look in to

        direction: str
            any valid direction 'n' for north, 's' for south, 'ns' for
            northsouth, etc

        board: nested list
            the board itself

    returns
        : tuple
        the coordinates of the first dirty at distance spot as a tuple
        or 
    '''

    # function to calculate the distance components  w.r.t. current position
    # NOTE: we are wokring with Taxicab geometry and corresponding equation of a circle
    radii = lambda R, _: abs(R) - abs(_)
    r_y = radii(distance, y)
    r_x = radii(distance, x)

    direction_valid = {
            'n': lambda d, p: abs(d) - abs(p) if abs(d) - abs(p) > 0 else None
            's': lambda d, p: abs(p) - abs(d) if abs(p) - abs(d) > 0 else None
            'e': lambda d, p: abs(d) - abs(p) if abs(d) - abs(p) > 0 else None
            'w': lambda d, p: abs(p) - abs(d) if abs(p) - abs(d) > 0 else None
            }
    




def seek_nearest(y, x, board):
    # seek the nearest spot to clean by iterating the distance from current position

    
    h = 1       # vertical/horizontal step
    h_diag = 0  # diagonal step
    
    distance = {
            'n': 1
            's': -1
            'ns': 
            }

    found = False
    while not found:






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

    return 0

if __name__ == "__main__":
    pos = [int(i) for i in input().strip().split()]
    board = [[j for j in input().strip()] for i in range(5)]
    next_move(pos[0], pos[1], board)

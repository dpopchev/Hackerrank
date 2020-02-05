#!/usr/bin/python

# may miss dirty spots if are outside of the circle, e.g.
#--------dd
#----------
#----------
#----------
#----------
#----------
#----------
#----------
#----b-----
#----------
def seek_closest_dirt(r):
    ''' generate the von Neumann neighborhood with radius r
    w.r.t. the current position
    '''
    for x in range(-r, r+1, 1):
        r_x = r - abs(x)
        # fault for failing corner cases
        #for y in range(-r_x, r_x+1, 1):
        for y in range(-r, r+1, 1):
            # no need to yeild the current position
            if not ( x == 0 and y == 0):
                yield (y, x)

#def update_board_memory(board):
#
#    fname = 'dpbotclean'
#
#    mem_dirty_points = []
#    # read the last saved state and filter 
#    with open(fname, 'r') as fp:
#        for line in fp:
#            mem_dirty_points.append([ int(_) for _ in line.strip().split()])
#
def update_distance_matrix(r, c, board):
    ''' for the current state of the board and bot position,
    update the distance matrix and return it sorted w.r.t. the relative distance

    parameters:
        r, c:   int
            row and column of bot position

        board:  nested list
            the board presenting the current state

    return:
        : list
            distance matrix consisted of
                [ position_row, position_col, distanse w.r.t. bot position ]
    '''

    # file name for intermediate board state saves
    fboard = 'dp_board_state'

    # define a metric function in the sake of generality 
    metric = lambda x1, x2, y1, y2: abs(x1-x2) + abs(y1-y2)

    # take a look for dirt on the board and save their position 
    # and relative distance from current bot position
    _distance_matrix = []
    for _r, row in enumerate(board):
        for _c, cell in enumerate(row):
            if cell == 'd':
                _distance_matrix.append([_r, _c, metric(_r, r, _c, c)])

    # sort the distance matrix w.r.t. dirt distance
    _distance_matrix.sort(key=lambda _: _[-1])

    # update the board state with the previous one
    # if no previous state is saved, save the current one
    dirt_present = [ _[:2] for _ in _distance_matrix ]
    try:
        with open(fboard, 'r') as fb:
            for dirt_saved_str in fb:
                dirt_saved = [ int(_) for _ in dirt_saved_str.strip().split() ]
                if not dirt_saved[:2] in dirt_present:
                    _distance_matrix.append( [ 
                                              dirt_saved[0], dirt_saved[1],
                                              metric( dirt_saved[0], r,
                                                      dirt_saved[1], c
                                                    )
                                            ] )
    except IOError:
        pass

    # after local distance matrix has been refreshed with current bot position
    # we should save it for next step
    with open(fboard, 'w') as fb:
        for dirt in _distance_matrix:
            fb.write(' '.join([ str(_) for _ in dirt]) + '\n')

    _distance_matrix = [ [ _r - r, _c - c, _ ] for _r, _c, _ in _distance_matrix ] 
    return sorted( _distance_matrix, key = lambda _: _[-1])

def next_move(posr, posc, board):

    leftright = lambda _: 'RIGHT' if _ > 0 else 'LEFT'
    updown    = lambda _: 'DOWN' if _ > 0 else 'UP'

    clean_step = False

    if board[posr][posc] == 'd':
        print('CLEAN')
        clean_step = True

    if not clean_step:
        distance_matrix = update_distance_matrix(posr, posc, board)

    # if any dirty spots found, go towards the closest
    # else go either right, down, left, up, in that order
    if not clean_step and len(distance_matrix):

        r, c, _ = distance_matrix[0]

        if r != 0 and c != 0: 
            print( updown(r) 
                    if abs(r) <= abs(c)
                    else leftright(c)
                    )
        elif r != 0:
            print(updown(r))
        elif c != 0:
            print(leftright(c))

    elif not clean_step:
        # worst case bot is seen a square around himself
        max_offset = 2

        # if not exceeding board borders to the right
        if posc + max_offset < len(board[0]):
            print('RIGHT')
        # or down
        elif posr + max_offset < len(board):
            print('DOWN')
        # or left
        elif posc - max_offset < 0:
            print('LEFT')
        elif posr + max_offset < 0:
            print('UP')

    return 0

if __name__ == "__main__":
    pos = [int(i) for i in input().strip().split()]
    board = [[j for j in input().strip()] for i in range(5)]
    next_move(pos[0], pos[1], board)

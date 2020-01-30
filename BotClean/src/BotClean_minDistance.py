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
    update the distance matrix and return it
    parameters:
        r, c:   int
            row and column of bot position

        board:  nested list
            the board presenting the current state
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

    # try to update the previous board state with the current one
    # TODO look up if a pairs in present baord state are already in previus
    try:
        with open(fboard, 'r') as fb:
            for line in fb:

             




def get_closest_dirt(posr, posc, board):

    distance_matrix = update_distance_mmatrix(posr, posc, board)

def next_move(posr, posc, board):

    r, c = get_closest_dirt(posr, posc, board)
    
    import random

    # take notes on found dirty cells here
    #board = update_bord_knownledge(board)
    
    dirt_found      = False    # track if dirt has been located
                               # they are marked with 'd'
    unknown_found   = False    # track if we have unobservable cells nearby
                               # they are marked with 'o'
    action_taken    = False    # track if action has been taken

    valid_moves     = set(['UP', 'DOWN', 'LEFT', 'RIGHT'])

    board_overshoot = set([])  # the board can be overshoot in 4 directions 
                               # Up, Down, Left, Right
    # neat way to check for overshooting
    overshoot = lambda pos, step, lim: True if pos + step >= lim or pos + step < 0 else False
    leftright = lambda _: 'RIGHT' if _ > 0 else 'LEFT'
    updown    = lambda _: 'DOWN' if _ > 0 else 'UP'

    # if we are sitting on dirty cell lets clean it and call it over 
    if board[posr][posc] == 'd':
        print('CLEAN')
        dirt_found = True
        action_taken = True

    r = 0       # max step to make
    step_posr = step_posc = 0   # steps in y and x direction needed to find dirt cell
    # if we are not on dirty cell lets search for the nearest dirt
    while not dirt_found and len(board_overshoot) < 4:
        r += 1
        for y, x in seek_closest_dirt(r):
        #for y, x in seek_closest_dirt(r, board):
            overshoot_y, overshoot_x = \
                    map(overshoot, [posr, posc],
                                   [y, x], 
                                   [len(board), len(board[0])]
                        )

            # if we are not overshooting in either x or y we can check for dirt
            if not overshoot_y and not overshoot_x and board[posr+y][posc+x] == 'd':
                step_posr, step_posc = y, x
                dirt_found = True
                break
            if not overshoot_y and not overshoot_x and board[posr+y][posc+x] == 'o':
                step_posr, step_posc = y, x
                unknown_found = True
            elif not dirt_found and overshoot_y:
                board_overshoot.update([updown(y)])
            elif not dirt_found and overshoot_x:
                board_overshoot.update([leftright(x)])
    
    # if we have found a dirt spot, move towards it 
    # otherwise try a random valid direction
    if dirt_found and step_posr != 0 and step_posc != 0:
        print( updown(step_posr) 
                if abs(step_posr) <= abs(step_posc)
                else leftright(step_posc)
                )
    elif dirt_found and step_posr != 0 and step_posc == 0:
        print(updown(step_posr))
    elif dirt_found and  step_posc != 0 and step_posr == 0:
        print(leftright(step_posc))
    elif not action_taken:
        choose_from = valid_moves.difference(board_overshoot) \
                if valid_moves.difference(board_overshoot) \
                else valid_moves
        print(random.choice(tuple(choose_from)))

    return

if __name__ == "__main__":
    pos = [int(i) for i in input().strip().split()]
    board = [[j for j in input().strip()] for i in range(5)]
    next_move(pos[0], pos[1], board)

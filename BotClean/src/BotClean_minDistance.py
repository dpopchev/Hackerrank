#!/usr/bin/env python3

import random

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

    # take a look for dirt on the board and save their absolute position
    # i.g. (0, 0) cell following the matrix notation for the board itself
    _distance_matrix = []
    for _r, row in enumerate(board):
        for _c, cell in enumerate(row):
            if cell == 'd':
                _distance_matrix.append([_r, _c, metric(_r, r, _c, c)])

    # updated distance matrix with missing dirt spots from previous state
    # do not update if now the bot is at the same position as saved dirt
    dirt_present = [ _[:2] for _ in _distance_matrix ]
    try:
        with open(fboard, 'r') as fb:
            for dirt_saved_str in fb:
                dirt_saved = [ int(_) for _ in dirt_saved_str.strip().split() ]
                if not dirt_saved[:2] in dirt_present \
                        and ( dirt_saved[0] != r or dirt_saved[1] != c ):
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

    # lambda functions to decide which way to go based on distance_matrix input
    leftright = lambda _: 'RIGHT' if _ > 0 else 'LEFT'
    updown    = lambda _: 'DOWN' if _ > 0 else 'UP'

    # easy access to prevent bot staying at one place after consecutive moves
    # , e.g. up-down or left-right etc.
    opposite_direction = {
            'RIGHT' : 'LEFT',
            'LEFT'  : 'RIGHT',
            'UP'    : 'DOWN',
            'DOWN'  : 'UP'
            }

    move_previous   = None
    # for next iteration, save our move here
    fmove           = 'dp_move_state'

    # our final next move
    move_next       = ''

    directions_valid = [ 'RIGHT', 'LEFT', 'UP', 'DOWN' ]

    # if this is not our first step, get what was the previous move
    # to prevent a stand still
    try:
        with open(fmove, 'r') as fm:
            move_previous = fm.readline().strip()
    except IOError:
        move_previous = None
        pass

    clean_step = False

    if board[posr][posc] == 'd':
        move_next = 'CLEAN'
        clean_step = True

    # update the dirt distribution if present step was to clean
    if not clean_step:
        distance_matrix = update_distance_matrix(posr, posc, board)

    # if any dirty spots found, go towards the closest
    # else go either in any direction which is not opposing our last move
    if not clean_step and len(distance_matrix) > 0:

        r, c, _ = distance_matrix[0]

        if r != 0 and c != 0:
            move_next = updown(r) if abs(r) <= abs(c) else leftright(c)
        elif r != 0:
            move_next = updown(r)
        elif c != 0:
            move_next = leftright(c)

    elif not clean_step and len(distance_matrix) == 0:
        # worst case bot is seen a square around himself
        max_offset = 2

        # if previous step was not clean, remove the opposite direction
        if move_previous != None and move_previous != 'CLEAN':
            directions_valid.remove(opposite_direction[move_previous])

        # if not exceeding board borders to the right
        try:
            if posc + max_offset >= len(board[0]):
                directions_valid.remove('RIGHT')
        except ValueError:
            pass

        # or down
        try:
            if posr + max_offset >= len(board):
                directions_valid.remove('DOWN')
        except ValueError:
            pass

        # or left
        try:
            if posc - max_offset < 0:
                directions_valid.remove('LEFT')
        except ValueError:
            pass

        # or up
        try:
            if posr - max_offset < 0:
                directions_valid.remove('UP')
        except ValueError:
            pass

        move_next = random.choice(directions_valid)

    # save current move
    with open(fmove, 'w') as fm:
        fm.write(move_next)

    print(move_next)
    return move_next

if __name__ == "__main__":
    pos = [int(i) for i in input().strip().split()]
    board = [[j for j in input().strip()] for i in range(5)]
    next_move(pos[0], pos[1], board)

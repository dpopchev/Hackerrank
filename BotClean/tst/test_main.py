#!/usr/bin/env python3

import unittest
import sys

# for debuging place pdb.set_trace() anywhere to create a breka point
import pdb

from bin.main import next_move
from bin.main import update_distance_matrix

# IO catch is based on https://stackoverflow.com/a/31281467

class test_BasicMovement(unittest.TestCase):

    def setUp(self):
        self.posr = 0
        self.posc = 0
        self.standart_board = [
                [ '-', '-', '-', '-', 'd' ],
                [ '-', 'd' ,'-' ,'-' ,'d' ],
                [ '-', '-' ,'d' ,'d' ,'-' ],
                [ '-', '-' ,'d' ,'-' ,'-' ],
                [ '-', '-' ,'-' ,'-' ,'d' ]
                ]
        self.fboard = 'dp_board_state'
        self.fmove  = 'dp_move_state'

        return

    def tearDown(self):

        import os

        # remove temp file for intermidate board states, if exists
        if os.path.exists(self.fboard):
            os.remove(self.fboard)

        if os.path.exists(self.fmove):
            os.remove(self.fmove)

        return

    def test_next_move_right(self):

        from io import StringIO
        from unittest.mock import patch

        board = self.standart_board.copy()

        self.posr = 0
        self.posc = 0

        board[0] = [ _ for _ in '-d---' ]
        board[1] = [ _ for _ in '-d---' ]

        with patch('sys.stdout', new=StringIO()) as fakeOutput:

            r = next_move(self.posr, self.posc, board)
            o = fakeOutput.getvalue().strip()

        self.assertEqual(o, 'RIGHT')

        return

    def test_next_move_left(self):

        from io import StringIO
        from unittest.mock import patch

        board = self.standart_board.copy()

        self.posr = 0
        self.posc = 2

        board[0] = [ _ for _ in '-d---' ]
        board[1] = [ _ for _ in '-d-d-' ]

        #pdb.set_trace()
        with patch('sys.stdout', new=StringIO()) as fakeOutput:

            r = next_move(self.posr, self.posc, board)
            o = fakeOutput.getvalue().strip()

        self.assertEqual(o, 'LEFT')

        return

    def test_next_move_up(self):

        from io import StringIO
        from unittest.mock import patch

        board = self.standart_board.copy()

        self.posr = 1
        self.posc = 1

        board[0] = [ _ for _ in 'ddd--' ]
        board[1] = [ _ for _ in '-----' ]

        with patch('sys.stdout', new=StringIO()) as fakeOutput:

            r = next_move(self.posr, self.posc, board)
            o = fakeOutput.getvalue().strip()

        self.assertEqual(o, 'UP')

        return

    def test_next_move_down(self):

        from io import StringIO
        from unittest.mock import patch

        board = self.standart_board.copy()

        self.posr = 0
        self.posc = 1

        board[0] = [ _ for _ in '-----' ]
        board[1] = [ _ for _ in 'ddd--' ]

        with patch('sys.stdout', new=StringIO()) as fakeOutput:

            r = next_move(self.posr, self.posc, board)
            o = fakeOutput.getvalue().strip()

        self.assertEqual(o, 'DOWN')

        return

    def test_next_move_clean(self):

        from io import StringIO
        from unittest.mock import patch

        board = self.standart_board.copy()

        self.posr = 0
        self.posc = 1

        board[0] = [ _ for _ in '-d---' ]
        board[1] = [ _ for _ in '-----' ]

        #pdb.set_trace()
        with patch('sys.stdout', new=StringIO()) as fakeOutput:

            r = next_move(self.posr, self.posc, board)
            o = fakeOutput.getvalue().strip()

        self.assertEqual(o, 'CLEAN')

        return

    def test_partially_observable_corner_NotDown_1(self):

        from io import StringIO
        from unittest.mock import patch

        board = self.standart_board.copy()

        self.posr = 4
        self.posc = 2

        board[0] = [ _ for _ in 'ooooo' ]
        board[1] = [ _ for _ in 'ooooo' ]
        board[2] = [ _ for _ in 'ooooo' ]
        board[3] = [ _ for _ in 'o---o' ]
        board[4] = [ _ for _ in 'o-b-o' ]

        with patch('sys.stdout', new=StringIO()) as fakeOutput:

            r = next_move(self.posr, self.posc, board)
            o = fakeOutput.getvalue().strip()

        self.assertNotEqual(o, 'CLEAN')
        self.assertNotEqual(o, 'DOWN')

        return

    def test_partially_observable_corner_NotDown_2(self):

        from io import StringIO
        from unittest.mock import patch

        board = self.standart_board.copy()

        self.posr = 3
        self.posc = 2

        board[0] = [ _ for _ in 'ooooo' ]
        board[1] = [ _ for _ in 'ooooo' ]
        board[2] = [ _ for _ in 'o---o' ]
        board[3] = [ _ for _ in 'o-b-o' ]
        board[4] = [ _ for _ in 'o---o' ]

        #pdb.set_trace()
        with patch('sys.stdout', new=StringIO()) as fakeOutput:

            r = next_move(self.posr, self.posc, board)
            o = fakeOutput.getvalue().strip()

        self.assertNotEqual(o, 'CLEAN')
        self.assertNotEqual(o, 'DOWN')

        return

    def test_partially_observable_corner_NotLeft_1(self):

        from io import StringIO
        from unittest.mock import patch

        board = self.standart_board.copy()

        self.posr = 2
        self.posc = 0

        board[0] = [ _ for _ in 'ooooo' ]
        board[1] = [ _ for _ in '--ooo' ]
        board[2] = [ _ for _ in 'b-ooo' ]
        board[3] = [ _ for _ in '--ooo' ]
        board[4] = [ _ for _ in 'ooooo' ]

        with patch('sys.stdout', new=StringIO()) as fakeOutput:

            r = next_move(self.posr, self.posc, board)
            o = fakeOutput.getvalue().strip()

        self.assertNotEqual(o, 'CLEAN')
        self.assertNotEqual(o, 'LEFT')

        return

    def test_partially_observable_corner_NotLeft_2(self):

        from io import StringIO
        from unittest.mock import patch

        board = self.standart_board.copy()

        self.posr = 2
        self.posc = 1

        board[0] = [ _ for _ in 'ooooo' ]
        board[1] = [ _ for _ in '---oo' ]
        board[2] = [ _ for _ in '-b-oo' ]
        board[3] = [ _ for _ in '---oo' ]
        board[4] = [ _ for _ in 'ooooo' ]

        with patch('sys.stdout', new=StringIO()) as fakeOutput:

            r = next_move(self.posr, self.posc, board)
            o = fakeOutput.getvalue().strip()

        self.assertNotEqual(o, 'CLEAN')
        self.assertNotEqual(o, 'LEFT')

        return

    def test_partially_observable_corner_NotRight_NotUp_1(self):

        from io import StringIO
        from unittest.mock import patch

        board = self.standart_board.copy()

        self.posr = 1
        self.posc = 4

        board[0] = [ _ for _ in 'ooo--' ]
        board[1] = [ _ for _ in 'ooo-b' ]
        board[2] = [ _ for _ in 'ooo--' ]
        board[3] = [ _ for _ in 'ooooo' ]
        board[4] = [ _ for _ in 'ooooo' ]

        #pdb.set_trace()
        with patch('sys.stdout', new=StringIO()) as fakeOutput:

            r = next_move(self.posr, self.posc, board)
            o = fakeOutput.getvalue().strip()

        self.assertNotEqual(o, 'CLEAN')
        self.assertNotEqual(o, 'RIGHT')
        self.assertNotEqual(o, 'UP')

        return

    def test_partially_observable_corner_NotRight_NotUp_2(self):

        from io import StringIO
        from unittest.mock import patch

        board = self.standart_board.copy()

        self.posr = 1
        self.posc = 3

        board[0] = [ _ for _ in 'oo---' ]
        board[1] = [ _ for _ in 'oo-b-' ]
        board[2] = [ _ for _ in 'oo---' ]
        board[3] = [ _ for _ in 'ooooo' ]
        board[4] = [ _ for _ in 'ooooo' ]

        with patch('sys.stdout', new=StringIO()) as fakeOutput:

            r = next_move(self.posr, self.posc, board)
            o = fakeOutput.getvalue().strip()

        self.assertNotEqual(o, 'CLEAN')
        self.assertNotEqual(o, 'RIGHT')
        self.assertNotEqual(o, 'UP')

        return


class test_CleanBoard(unittest.TestCase):

    def setUp(self):

        self.posr = 0
        self.posc = 0

        self.standart_board = [
                [ '-', '-', '-', '-', 'd' ],
                [ '-', 'd' ,'-' ,'-' ,'d' ],
                [ '-', '-' ,'d' ,'d' ,'-' ],
                [ '-', '-' ,'d' ,'-' ,'-' ],
                [ '-', '-' ,'-' ,'-' ,'d' ]
                ]

        self.move = {
                'LEFT'  : lambda y, x: (y, x-1),
                'RIGHT' : lambda y, x: (y, x+1),
                'UP'    : lambda y, x: (y-1, x),
                'DOWN'  : lambda y, x: (y+1, x),
                'CLEAN' : lambda y, x: (y, x)
                }

        self.count_dirt = lambda b: sum(_.count('d') for _ in b)

        self.fboard = 'dp_board_state'
        self.fmove  = 'dp_move_state'
        return

    def tearDown(self):

        import os

        # remove temp file for intermidate board states, if exists
        if os.path.exists(self.fboard):
            os.remove(self.fboard)

        if os.path.exists(self.fmove):
            os.remove(self.fmove)

        return

    def _get_bot_input(self, r, c, b):

        from io import StringIO
        from unittest.mock import patch

        with patch('sys.stdout', new=StringIO()) as fakeOutput:

            r = next_move(r, c, b)
            o = fakeOutput.getvalue().strip()

        return o

    def _show_board(self, r, c, b):

        print(r,c)
        for r in map(''.join, b):
            print(r)

        return

    def _clean_baord(self, posr, posc, board, stdout = False):

        # while bot has something to clean feed him his current position and board
        count_moves = 0
        while self.count_dirt(board):

            if stdout:
                self._show_board(posr, posc, board)

            # get bot move in regard of current position
            bot_says = self._get_bot_input(posr, posc, board)

            # check if bot move is valid
            self.assertIn(bot_says, self.move.keys())

            # assure bot wants to clean only cell with dirt
            if bot_says == 'CLEAN':
                self.assertEqual(board[posr][posc], 'd')
                board[posr][posc] = 'b'

            else:
                board[posr][posc] = '-'
                posr, posc = self.move[bot_says](posr, posc)

                # make sure bot is not overshooting the board vertically
                self.assertLess(posr, len(board))
                self.assertGreaterEqual(posr, 0)

                # make sure bot is not overshooting the board horizontally
                self.assertLess(posc, len(board[0]))
                self.assertGreaterEqual(posc, 0)

                board[posr][posc] = 'd' if board[posr][posc] == 'd' else 'b'

            count_moves += 1

            if stdout:
                print(bot_says)
                print('\n')

        return count_moves

    def _generate_board(self, max_y, max_x, coef = 0.2):
        ''' generate board of nested lists with max_y rows and max_x cols
            by filling max_y*max_x*coef dirty cells

            max_y, max_x: int
                mandatory input to set board size

            coef: float
                what amount of the cells should be marked dirty
        '''

        from random import randint

        # create board with max size
        board_size_y = max_y
        board_size_x = max_x
        board = [ ['-' for _ in range(board_size_x)] for _ in range(board_size_y) ]

        # fill 20% of the board with dirt
        amount_dirt = board_size_y*board_size_x*coef
        rand_y_x = lambda: (randint(0, board_size_y-1), randint(0, board_size_x-1))

        while amount_dirt > 0:
            y, x = rand_y_x()
            if board[y][x] == '-':
                board[y][x] = 'd'
                amount_dirt -= 1

        return board

    def test_board_5x5(self):

        # set local def values
        board = self._generate_board(5,5)
        posr  = self.posr
        posc  = self.posc
        board[posr][posc] = 'b'

        r = self._clean_baord(posr, posc, board)
        print('Bot cleaned board with ', r, ' moves')

        return

    def test_board_5x25(self):

        # set local def values
        board = self._generate_board(5,25)
        posr  = self.posr
        posc  = self.posc
        board[posr][posc] = 'b'

        r = self._clean_baord(posr, posc, board)
        print('Bot cleaned board with ',r, ' moves')

        return

    def test_board_25x5(self):

        # set local def values
        board = self._generate_board(25,5)
        posr  = self.posr
        posc  = self.posc
        board[posr][posc] = 'b'

        r = self._clean_baord(posr, posc, board)
        print('Bot cleaned board with ',r, ' moves')

        return

    def test_board_10x10(self):

        # set local def values
        board = self._generate_board(10,10)
        posr  = self.posr
        posc  = self.posc
        board[posr][posc] = 'b'

        #pdb.set_trace()
        r = self._clean_baord(posr, posc, board, stdout=False)
        print('Bot cleaned board with ',r, ' moves')

        return

    def test_board_15x30(self):

        # set local def values
        board = self._generate_board(15,30)
        posr  = self.posr
        posc  = self.posc
        board[posr][posc] = 'b'

        r = self._clean_baord(posr, posc, board)
        print('Bot cleaned board with ', r,' moves')

        return

    def test_board_30x15(self):

        # set local def values
        board = self._generate_board(30,15)
        posr  = self.posr
        posc  = self.posc
        board[posr][posc] = 'b'

        r = self._clean_baord(posr, posc, board)
        print('Bot cleaned board with ', r, ' moves')

        return

    def test_board_50x50(self):

        # set local def values
        board = self._generate_board(50,50)
        posr  = self.posr
        posc  = self.posc
        board[posr][posc] = 'b'

        r = self._clean_baord(posr, posc, board)
        print('Bot cleaned board with ',r, ' moves')

        return

    # takes the longest so disabling it
    #def test_board_75x75(self):
    #
    #    # set local def values
    #    board = self._generate_board(75,75)
    #    posr  = self.posr
    #    posc  = self.posc
    #    board[posr][posc] = 'b'

    #    r = self._clean_baord(posr, posc, board)
    #    print('Bot cleaned board with ',r, ' moves')

    #    return

class test_IntermediateBoardStates(unittest.TestCase):

    def setUp(self):

        self.posr = 0
        self.posc = 0

        self.standart_board = [
                [ '-', '-', '-', '-', 'd' ],
                [ '-', 'd' ,'-' ,'-' ,'d' ],
                [ '-', '-' ,'d' ,'d' ,'-' ],
                [ '-', '-' ,'d' ,'-' ,'-' ],
                [ '-', '-' ,'-' ,'-' ,'d' ]
                ]

        # define a metric function for the sake of generality
        self.metric = lambda x1, x2, y1, y2: abs(x1-x2) + abs(y1-y2)

        # standart distance matrix w.r.t. standart position
        self.standart_board_distance_matrix = []
        for _r, row in enumerate(self.standart_board):
            for _c, cell in enumerate(row):
                if cell == 'd':
                    self.standart_board_distance_matrix.append(
                                [ _r, _c, self.metric(_r, self.posr, _c, self.posc)]
                                )

        # temp file name for testing
        self.fboard = 'dp_board_state'
        self.fmove  = 'dp_move_state'

        return

    def tearDown(self):

        import os

        # remove temp file for intermidate board states, if exists
        if os.path.exists(self.fboard):
            os.remove(self.fboard)

        if os.path.exists(self.fmove):
            os.remove(self.fmove)

        return

    def test_distance_matrix(self):

        distance_matrix = update_distance_matrix(
                self.posr, self.posc,
                self.standart_board
                )

        self.assertCountEqual(
                sorted(distance_matrix, key = lambda _: _[-1]),
                sorted(self.standart_board_distance_matrix, key = lambda _: _[-1])
                )

    def test_intermidate_state_save(self):

        # assure that no intermidate state is saved initially
        self.assertRaises(IOError, open, self.fboard, 'r')

        distance_matrix = update_distance_matrix(
                self.posr, self.posc,
                self.standart_board
                )


        _saved_states = []
        with open(self.fboard, 'r') as fb:
            for line in fb:
                _saved_states.append(
                    [ int(_) for _ in line.strip().split() ]
                    )

        self.assertCountEqual(
                sorted(distance_matrix, key = lambda _: _[-1]),
                sorted(_saved_states, key = lambda _: _[-1])
                )

    def test_intermidate_state_save_updated_added(self):

        # assure that no intermidate state is saved initially
        self.assertRaises(IOError, open, self.fboard, 'r')

        # create distane matrix based on standart board
        distance_matrix = update_distance_matrix(
                self.posr, self.posc,
                self.standart_board
                )

        # append additional dirt on the right of the bot initial position
        self.standart_board[0][1] = 'd'
        distance_matrix = update_distance_matrix(
                self.posr, self.posc,
                self.standart_board
                )

        _saved_states = []
        with open(self.fboard, 'r') as fb:
            for line in fb:
                _saved_states.append(
                    [ int(_) for _ in line.strip().split() ]
                    )

        self.assertCountEqual(
                sorted(distance_matrix, key = lambda _: _[-1]),
                sorted(_saved_states, key = lambda _: _[-1])
                )

    def test_intermidate_state_save_updated_removed(self):

        # assure that no intermidate state is saved initially
        self.assertRaises(IOError, open, self.fboard, 'r')

        # create distane matrix based on standart board
        distance_matrix = update_distance_matrix(
                self.posr, self.posc,
                self.standart_board
                )

        # remove dirt on the right of the bot
        self.standart_board[0][-1] = '-'
        distance_matrix = update_distance_matrix(
                self.posr, self.posc,
                self.standart_board
                )

        _saved_states = []
        with open(self.fboard, 'r') as fb:
            for line in fb:
                _saved_states.append(
                    [ int(_) for _ in line.strip().split() ]
                    )

        self.assertCountEqual(
                sorted(distance_matrix, key = lambda _: _[-1]),
                sorted(_saved_states, key = lambda _: _[-1])
                )

    def test_intermidate_state_hidden_dirt_1(self):

        # assure that no intermidate state is saved initially
        self.assertRaises(IOError, open, self.fboard, 'r')

        board = self.standart_board.copy()
        board[0] = [ _ for _ in 'ooooo' ]
        board[1] = [ _ for _ in 'ooooo' ]
        board[2] = [ _ for _ in 'ooooo' ]
        board[3] = [ _ for _ in 'o---o' ]
        board[4] = [ _ for _ in 'o-b-o' ]

        posr = 4
        posc = 2

        # create distance matrix based on standart board
        distance_matrix = update_distance_matrix(
                posr, posc, board
                )

        self.assertEqual(len(distance_matrix), 0)

if __name__ == '__main__':
    unittest.main()

#!/usr/bin/env python3

import unittest
import sys

from src.BotClean_minDistance import next_move

# IO catch is based on https://stackoverflow.com/a/31281467

class next_move_BasicMovement(unittest.TestCase):

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

        return

    def tearDown(self):
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

        with patch('sys.stdout', new=StringIO()) as fakeOutput:

            r = next_move(self.posr, self.posc, board)
            o = fakeOutput.getvalue().strip()
        
        self.assertEqual(o, 'CLEAN')

        return

if __name__ == '__main__':
    unittest.main()

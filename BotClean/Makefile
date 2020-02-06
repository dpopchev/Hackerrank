# alias for unittest execution
UNITTEST := python -m unittest -v 

# ln should always overwrite the created symbolic links
LN := ln
LN += --force
LN += --symbolic

MKDIR := mkdir
MKDIR += --parents

# make $(file) the defualt target for testing
# file is passed as argument, i.e. make default file=your_file_of_choice
default:
	@$(MKDIR) bin/
	@$(LN) ../src/$(file) bin/main.py

test_BasicMovement:
	@$(UNITTEST) tst.test_main.test_BasicMovement

test_CleanBoard:
	@$(UNITTEST) tst.test_main.test_CleanBoard

test_IntermediateBoardStates:
	@$(UNITTEST) tst.test_main.test_IntermediateBoardStates

test_all:
	@$(UNITTEST) tst.test_main

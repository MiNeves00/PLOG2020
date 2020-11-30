/**Start Game */
/**Starts game with mode  Player v Player*/
%gameStart(+TypeOfPlayer1, +TypeOfPlayer2)
gameStart('Player','Player'):-
    write('Starting Player vs Player game...'),
    nl,
    initial(GameState), %Gets initial game state
    gameLoop(GameState,'Player','Player'). %Initiates game loop 

/**Starts game with mode  Player v Computer*/
gameStart('Player','Com'):-
    write('Starting Player vs Com game...'),
    nl,
    initial(GameState), %Gets initial game state
    readLevel(Level),
    readWhosWho(White,Black),
    gameLoop(GameState, White, Black, Level). %Initiates game loop

/**Starts game with mode  Computer v Computer*/
gameStart('Com','Com'):-
    write('Starting Player vs Com game...'),
    nl,
    initial(GameState), %Gets initial game state
    readLevel(Level),
    gameLoop(GameState, 'Com', 'Com', Level). %Initiates game loop



/**Game Loop*/
/**
Loops between the two players' moves
Every loop consists two turns, one each player
Every turn consists of displaying the game state, a move by the player and a check to see if the game is over
After that, if game is not over, loops again
*/
%gameLoop(-GameState, +TypeOfPlayer1, +TypeOfPlayer2)
gameLoop(GameState,'Player','Player'):- %Each player has a turn in a loop
    display_game(GameState,'White'), %Displays game
    player_moveWrapped(GameState,'White',NewGameState,Won1), %A move is played
    (Won1 = 'True' -> HasWon = 'True', Winner1 = 'Black' ; game_over(NewGameState,'White',HasWon), Winner1 = 'White', display_game(NewGameState,'Black')),
    (HasWon = 'False' ->  
        player_moveWrapped(NewGameState,'Black',NewGameState2,Won2),
        (Won2 = 'True' -> HasWon2 = 'True', Winner2 = 'White' ; game_over(NewGameState2,'Black',HasWon2), Winner2 = 'Black'),
        (HasWon2 = 'False' ->
            gameLoop(NewGameState2,'Player','Player') %Recursive call to continue to next player turns
            ; 
            display_game(NewGameState2,'White'),
            won(Winner2)
        )
        ;
        won(Winner1)
    )
    .

/**Game Loop for Player v Computer with Player as White*/
gameLoop(GameState,'Player','Com',Level):- %Each player has a turn in a loop
    display_game(GameState,'White'), %Displays game
    player_moveWrapped(GameState,'White',NewGameState,Won1),
    (Won1 = 'True' -> HasWon = 'True', Winner1 = 'Black' ; game_over(NewGameState,'White',HasWon), Winner1 = 'White', display_game(NewGameState,'Black')),
    (HasWon = 'False' ->  
        com_moveWrapped(NewGameState,'Black',Level,NewGameState2,Won2),
        (Won2 = 'True' -> HasWon2 = 'True', Winner2 = 'White' ; game_over(NewGameState2,'Black',HasWon2), Winner2 = 'Black'),
        (HasWon2 = 'False' ->
            gameLoop(NewGameState2,'Player','Com',Level) %Recursive call to continue to next player turns
            ; 
            display_game(NewGameState2,'White'),
            won(Winner2)
        )
        ;
        won(Winner1)
    )
    .

/**Game Loop for Player v Computer with Computer as White*/
gameLoop(GameState,'Com','Player',Level):- %Each player has a turn in a loop
    display_game(GameState,'White'), %Displays game
    com_moveWrapped(GameState,'White',Level,NewGameState,Won1),
    (Won1 = 'True' -> HasWon = 'True', Winner1 = 'Black' ; game_over(NewGameState,'White',HasWon), Winner1 = 'White', display_game(NewGameState,'Black')),
    (HasWon = 'False' ->  
        player_moveWrapped(NewGameState,'Black',NewGameState2,Won2),
        (Won2 = 'True' -> HasWon2 = 'True', Winner2 = 'White' ; game_over(NewGameState2,'Black',HasWon2), Winner2 = 'Black'),
        (HasWon2 = 'False' ->
            gameLoop(NewGameState2,'Com','Player',Level) %Recursive call to continue to next player turns
            ; 
            display_game(NewGameState2,'White'),
            won(Winner2)
        )
        ;
        won(Winner1)
    )
    .

/**Game Loop for Computer v Computer*/
gameLoop(GameState,'Com','Com',Level):- %Each player has a turn in a loop
    display_game(GameState,'White'), %Displays game
    com_moveWrapped(GameState,'White',Level,NewGameState,Won1),
    (Won1 = 'True' -> HasWon = 'True', Winner1 = 'Black' ; game_over(NewGameState,'White',HasWon), Winner1 = 'White', display_game(NewGameState,'Black')),
    (HasWon = 'False' ->  
        com_moveWrapped(NewGameState,'Black',Level,NewGameState2,Won2),
        (Won2 = 'True' -> HasWon2 = 'True', Winner2 = 'White' ; game_over(NewGameState2,'Black',HasWon2), Winner2 = 'Black'),
        (HasWon2 = 'False' ->
            gameLoop(NewGameState2,'Com','Com',Level) %Recursive call to continue to next player turns
            ; 
            display_game(NewGameState2,'White'),
            won(Winner2)
        )
        ;
        won(Winner1)
    )
    .




/**Player Move*/
/**
A Player move consists of two steps, ringStep and ballStep
Given a game state and a player, will yield a new game state, after a move
Reads and handles move
*/

/**Move Format*/
%Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece]

/**Player move Wrapper to check if there are no more valid moves, in which case Won is 'True'*/
%player_moveWrapped(+GameState,+Player,-NewGameState,-Won)
player_moveWrapped(GameState,Player,NewGameState,Won):-
    player_move(GameState,Player,NewGameState), Won = 'False'.

player_moveWrapped(GameState,Player,NewGameState,Won):- Won = 'True'.

/**
Gets valid moves on screen before each step
Does both ringStep and ballStep, in sequence
Displays the board between steps
*/
%player_move(+GameState,+Player,-NewGameState)
player_move(GameState,Player,NewGameState):-
    nl,
    (Player = 'White' -> 
        valid_moves(GameState,'WhiteRing',ListOfRingMoves)
    ;
        valid_moves(GameState,'BlackRing',ListOfRingMoves)
    ),!,
    (ListOfRingMoves = [] -> fail; UselessVar = 0),
    ringStep(GameState,Player,IntermediateGameState),
    display_game(IntermediateGameState,Player),
    (Player = 'White' -> 
        valid_moves(IntermediateGameState,'WhiteBall',ListOfBallMoves)
    ;
        valid_moves(IntermediateGameState,'BlackBall',ListOfBallMoves)
    ),!,
    (ListOfBallMoves = [] -> fail; UselessVar2 = 0),
    ballStep(IntermediateGameState,Player,NewGameState).


/**
Ring Step
Reads a ring move
Handles a ring move
*/
%ringStep(+GameState,+Player,-NewGameState)
ringStep(GameState,Player,NewGameState):-
    readRingMove(Player, RingMove),
    handleRingMove(GameState,RingMove,Player,NewGameState).

/**
Ball Step
Reads a ball move
Handles a ball move
*/
%ballStep(+GameState, +Player, -NewGameState)
ballStep(GameState, Player, NewGameState):-
    readBallMove(Player, BallMove),
    handleBallMove(GameState,BallMove,Player,NewGameState).


/**Com Move*/
/**
A Computer move consists of the same two steps, ringStep and ballStep
Given a game state and a player, will yield a new game state, after a move
Chooses the best move and plays it
*/

/**Computer move Wrapper to check if there are no more valid moves, in which case Won is 'True'*/
%com_moveWrapped(+GameState,+Player,+Level,-NewGameState,-Won)
com_moveWrapped(GameState,Player,Level,NewGameState,Won):-
    com_move(GameState,Player,Level,NewGameState), Won = 'False'.

com_moveWrapped(GameState,Player,Level,NewGameState,Won):- Won = 'True'.

/**
Gets valid moves on screen before each step
Does both ringStep and ballStep, in sequence
Displays the board between steps
*/
%com_move(+GameState,+Player,Level,-NewGameState)
com_move(GameState,Player,Level,NewGameState):-
    nl,
    (Player = 'White' -> 
        valid_moves(GameState,'WhiteRing',ListOfRingMoves)
    ;
        valid_moves(GameState,'BlackRing',ListOfRingMoves)
    ),!,
    (ListOfRingMoves = [] -> fail; UselessVar = 0),
    ringStepCom(GameState,Player,Level,ListOfRingMoves,IntermediateGameState),
    display_game(IntermediateGameState,Player),
    (Player = 'White' -> 
        valid_moves(IntermediateGameState,'WhiteBall',ListOfBallMoves)
    ;
        valid_moves(IntermediateGameState,'BlackBall',ListOfBallMoves)
    ),!,
    (ListOfBallMoves = [] -> fail; UselessVar2 = 0),
    ballStepCom(IntermediateGameState,Player,Level,ListOfBallMoves,NewGameState).

/**
Ring Step
Chooses a ring move
Handles a ring move
*/
%ringStepCom(+GameState, +Player, +Level, +ListOfRingMoves, -NewGameState)
ringStepCom(GameState,Player,Level,ListOfRingMoves,NewGameState):-
    choose_moveRing(GameState,Player,Level,ListOfRingMoves, RingMove),
    handleRingMove(GameState,RingMove,Player,NewGameState).

/**
Ball Step
Chooses a ball move
Handles a ball move
*/
%ballStepCom(+GameState, +Player, +Level, +ListOfBallMoves , -NewGameState)
ballStepCom(GameState, Player, Level,ListOfBallMoves, NewGameState):-
    choose_moveBall(GameState,Player,Level,ListOfBallMoves, BallMove),
    handleBallMoveCom(GameState,BallMove,Player,Level,NewGameState).





/**Handle Move*/
/**
Verify if the move is valid and, if so, alter game state to reflect played move
*/

/**
Handles Ring Move
If move is valid, plays move and changes game state
If not, calls ringStep
*/
%handleRingMove(+GameState,+Move,+Player,-NewGameState)
handleRingMove(GameState,[-1,-1,ColIndexEnd,RowIndexEnd,Piece], Player, NewGameState):-
    isRingMoveValid(GameState,[-1,-1,ColIndexEnd,RowIndexEnd,Piece], Player,Valid),
    (Valid = 'True' -> 
        move(GameState,[-1,-1,ColIndexEnd,RowIndexEnd,Piece], Player, NewGameState)
    ; 
        nl,write('Select a ring to move'),nl,nl,
        ringStep(GameState,Player,NewGameState)
    ).

handleRingMove(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece], Player, NewGameState):-
    isRingMoveValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece], Player,Valid),
    (Valid = 'True' -> 
        move(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece], Player, NewGameState)
    ;
        nl,write('Select a ring to move'),nl,nl,
        ringStep(GameState,Player,NewGameState)
    ).

/**
Handles Ball Move
Checks if move is valid
A ball move is valid if its starting position has a ball of the players colour, its destination has no ball on top
If true, plays move and changes game state
If not, calls ringStep
*/
%handleBallMove(+GameState,+Move,+Player,-NewGameState) 
handleBallMove(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,NewGameState):-
    isBallMoveValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,Valid,ValidRelocateMoves),
    (Valid = 'True' -> 
        move(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece], Player, IntermediateGameState),
        (Player = 'White' ->
            relocateStep(IntermediateGameState,ValidRelocateMoves,'Black',NewGameState)
        ;
            relocateStep(IntermediateGameState,ValidRelocateMoves, 'White',NewGameState)
        )
    ; 
        nl,write('Select a ball to move'),nl,nl,
        ballStep(GameState,Player,NewGameState)
    ).


%relocateStep(+GameState,+Moves,+Player,-NewGameState)
relocateStep(GameState, [], _Player, NewGameState) :-
    NewGameState = GameState.

relocateStep(GameState, Moves, Player, NewGameState) :-
    nl,
    write('Opponent balls must be relocated'),nl,
    write('Insert relocating moves'),
    nl,
    readBallMove(Player, Move),
    removeMoves(Moves, Move, [], NewMoves),
    isBallRelocateEndValid(GameState,Move,Player,ValidEnd),
    (ValidEnd = 'True' ->
        move(GameState, Move, Player, IntermediateGameState),
        relocateStep(IntermediateGameState, NewMoves, Player, NewGameState)
    ;
        relocateStep(GameState, Moves, Player, NewGameState)
    ).



%handleBallMoveCom(+GameState,+Move,+Player,+Level,-NewGameState) 
handleBallMoveCom(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,Level,NewGameState):-
    isBallMoveValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,Valid,ValidRelocateMoves),
    (Valid = 'True' -> 
        move(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece], Player, IntermediateGameState),
        (Player = 'White' ->
            relocateStepCom(IntermediateGameState,ValidRelocateMoves,'Black',Level,NewGameState)
        ;
            relocateStepCom(IntermediateGameState,ValidRelocateMoves, 'White',Level,NewGameState)
        )
    ; 
        nl,write('Select a ball to move'),nl,nl,
        ballStepCom(GameState,Player,Level,ValidRelocateMoves,NewGameState)
    ).



%relocateStepCom(+GameState,+Moves,+Player,Level,-NewGameState)
relocateStepCom(GameState, [], _Player,Level, NewGameState) :-
    NewGameState = GameState.

relocateStepCom(GameState, Moves, Player,Level, NewGameState) :-
    nl,
    write('Opponent balls must be relocated'),nl,
    choose_moveBallRelocate(GameState,Player,Level,Moves,Move),
    removeMoves(Moves, Move, [], NewMoves),
    isBallRelocateEndValid(GameState,Move,Player,ValidEnd),
    (ValidEnd = 'True' ->
        move(GameState, Move, Player, IntermediateGameState),
        relocateStepCom(IntermediateGameState, NewMoves, Player,Level, NewGameState)
    ;
        relocateStepCom(GameState, Moves, Player,Level, NewGameState)
    ).




removeMoves([], _Move, OldMoves, NewMoves) :-
    NewMoves = OldMoves.

removeMoves([[Col1, Row1, Col2, Row2, Piece] | T], [PCol, PRow, PCol1, PRow1, PPiece], OldMoves, NewMoves) :-
    (Col1 = PCol ->
        (Row1 = PRow ->
            removeMoves(T, [PCol, PRow, PCol1, PRow1, PPiece], OldMoves, NewMoves)
        ;
            (Col2 = PCol1 ->
                (Row2 = PRow1 ->
                    removeMoves(T, [PCol, PRow, PCol1, PRow1, PPiece], OldMoves, NewMoves)
                ;
                    IntermediateMoves = [[Col1, Row1, Col2, Row2, Piece] | OldMoves],
                    removeMoves(T, [PCol, PRow, PCol, PRow, PPiece], IntermediateMoves, NewMoves)
                )
            ;
                IntermediateMoves = [[Col1, Row1, Col2, Row2, Piece] | OldMoves],
                removeMoves(T, [PCol, PRow, PCol, PRow, PPiece], IntermediateMoves, NewMoves)
            )
        )
    ;
        (Col2 = PCol1 ->
            (Row2 = PRow1 ->
                removeMoves(T, [PCol, PRow, PCol1, PRow1, PPiece], OldMoves, NewMoves)
            ;
                IntermediateMoves = [[Col1, Row1, Col2, Row2, Piece] | OldMoves],
                removeMoves(T, [PCol, PRow, PCol, PRow, PPiece], IntermediateMoves, NewMoves)
            )
        ;
            IntermediateMoves = [[Col1, Row1, Col2, Row2, Piece] | OldMoves],
            removeMoves(T, [PCol, PRow, PCol, PRow, PPiece], IntermediateMoves, NewMoves)
        )
    ).

    
/**
Validating Ring Move
Checks if ring move is valid
A ring move is valid if its starting position has a ring of the players colour and its destination has no ball on top
If this is true, Valid is 'True'
Its divided between Start valid and End valid
*/
%isRingMoveValid(+GameState,+Move,+Player,-Valid)
isRingMoveValid(GameState,[-1,-1,ColIndexEnd,RowIndexEnd,Piece], Player, Valid):-
    isRingMoveStartValid(GameState,[-1,-1,ColIndexEnd,RowIndexEnd,Piece], Player, ValidStart),
    isRingMoveEndValid(GameState,[-1,-1,ColIndexEnd,RowIndexEnd,Piece], Player, ValidEnd),
    (ValidStart = 'False' -> 
        Valid = 'False',
        nl,write('You dont have rings left in your hand!'),
        nl
    ; 
        (ValidEnd = 'False' -> 
            Valid = 'False',
            nl,write('Destination space invalid!'),
            nl,write('There is a ball in the position your trying to put a ring!'),nl
        ; 
            Valid = 'True'
        ) 
    ).

/**If starting position is (-1, -1), ring is to be played from hand*/
/**If there are no rings in hand, Valid = 'False'*/
isRingMoveStartValid([_Board, [[], _BlackPieces]],[-1,-1,ColIndexEnd,RowIndexEnd,Piece], 'White', Valid):-
    Valid = 'False'.

isRingMoveStartValid([_Board, [_WhitePieces, []]],[-1,-1,ColIndexEnd,RowIndexEnd,Piece], 'Black', Valid):-
    Valid = 'False'.

/**If there are rings in hand, Valid = 'True'*/
isRingMoveStartValid([_Board, [WhitePieces, _BlackPieces]],[-1,-1,ColIndexEnd,RowIndexEnd,Piece], 'White', Valid):-
    Valid = 'True'.

isRingMoveStartValid([_Board, [_WhitePieces, BlackPieces]],[-1,-1,ColIndexEnd,RowIndexEnd,Piece], 'Black', Valid):-
    Valid = 'True'.

/**If there is no ball on destination, Valid = 'True'*/
isRingMoveEndValid(GameState,[-1,-1,ColIndexEnd,RowIndexEnd,Piece], Player, Valid):-
    getBoard(GameState,Board),
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[EndHeadValue|_TailValue]),
    (EndHeadValue = whiteBall -> 
        Valid = 'False'
    ; 
        (EndHeadValue = blackBall -> 
            Valid = 'False'
        ; 
            Valid = 'True'
        ) 
    ).

/**If the starting position is not (-1, -1), ring is to be moved on the board*/
isRingMoveValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece], Player, Valid):-
    isRingMoveStartValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece], Player, ValidStart),
    isRingMoveEndValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece], Player, ValidEnd),
    (ValidStart = 'False' -> 
        Valid = 'False',
        nl,write('Piece you choose to move is not a ring of your colour!'),
        nl
    ; 
        (ValidEnd = 'False' -> 
            Valid = 'False',
            nl,write('Destination space invalid!'),
            nl,write('Select a place with no ball on top'),
            nl
        ; 
            Valid = 'True'
        ) 
    ).

/**Must verify it there is a ring of that colour on top of start space*/
isRingMoveStartValid(GameState,[ColIndexBegin,RowIndexBegin,_ColIndexEnd,_RowIndexEnd,Piece], Player, ValidStart):-
    getBoard(GameState,Board),
    getPieces(GameState,AllPieces),
    getValueInMapStackPosition(Board,RowIndexBegin,ColIndexBegin,[HeadValue|_Tail]),
    (Player = 'White' -> 
        (HeadValue = whiteRing -> 
            ValidStart = 'True'
        ; 
            ValidStart = 'False'
        ) 
    ; 
        (HeadValue = blackRing -> 
            ValidStart = 'True'
        ; 
            ValidStart = 'False'
        ) 
    ).

/**Must verify it there is no ball  on top of destination space*/
isRingMoveEndValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece], Player, ValidEnd):-
    getBoard(GameState,Board),
    getPieces(GameState,AllPieces),
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[EndHeadValue|_TailValue]),
    (EndHeadValue = whiteBall -> 
        ValidEnd = 'False'
    ; 
        (EndHeadValue = blackBall -> 
            ValidEnd = 'False'
        ; 
            (RowIndexBegin = RowIndexEnd ->
                (ColIndexBegin = ColIndexEnd ->
                    ValidEnd = 'False'
                ;
                    ValidEnd = 'True'
                )
            ;
                ValidEnd = 'True'
            )
        ) 
    ).

/**
Validating Ball Move
Checks if move is valid
A ball move is valid if its starting position has a ball of the players colour,
its destination has no ball on top and a ring of the players colour,
and is adjacent to the starting space
The one exception is the vault, where it has to check if the destination has a ring of the players colour and all spaces vaulted over have balls on top
Its divided in Start valid and End valid
*/
%isBallMoveValid(+GameState,+Move,+Player,-Valid)
isBallMoveValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,Valid,ValidRelocateMoves):-
    isBallMoveStartValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,ValidStart),
    isBallMoveEndValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,ValidEnd,ValidRelocateMoves),
    (ValidStart = 'False' -> 
        Valid = 'False',
        nl,write('Piece you choose to move is not a ball of your colour!'),
        nl
    ; 
        (ValidEnd = 'False' -> 
            Valid = 'False',
            nl
        ; 
            Valid = 'True'
        ) 
    ).

/**Ball cannot be moved after it has reached a goal space*/
/**(0, 3), (0, 4) and (1, 4) for White*/
isBallMoveStartValid(GameState,[3,0,ColIndexEnd,RowIndexEnd,Piece],'White','False').
isBallMoveStartValid(GameState,[4,0,ColIndexEnd,RowIndexEnd,Piece],'White','False').
isBallMoveStartValid(GameState,[4,1,ColIndexEnd,RowIndexEnd,Piece],'White','False').

/**(3, 0), (4, 0) and (4, 1) for Black*/
isBallMoveStartValid(GameState,[0,3,ColIndexEnd,RowIndexEnd,Piece],'Black','False').
isBallMoveStartValid(GameState,[0,4,ColIndexEnd,RowIndexEnd,Piece],'Black','False').
isBallMoveStartValid(GameState,[1,4,ColIndexEnd,RowIndexEnd,Piece],'Black','False').

/**Checks if ball of correct colour is on top of starting space*/
isBallMoveStartValid(GameState,[ColIndexBegin,RowIndexBegin,_ColIndexEnd,_RowIndexEnd,Piece],Player,ValidStart):-
    getBoard(GameState,Board),
    getPieces(GameState,AllPieces),
    getValueInMapStackPosition(Board,RowIndexBegin,ColIndexBegin,[HeadValue|_Tail]),
    (Player = 'White' -> 
        (HeadValue = whiteBall -> 
            ValidStart = 'True'
        ; 
            ValidStart = 'False'
        ) 
    ; 
        (HeadValue = blackBall -> 
            ValidStart = 'True'
        ; 
            ValidStart = 'False'
        ) 
    ).

/**
Checks if destination space is adjacent to starting space
Also checks if ring of correct colour is on top of destination space
If not adjecent, also checks if it is a valid Vault
*/
isBallMoveEndValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,ValidEnd, ValidRelocateMoves):-
    (ColIndexEnd < ColIndexBegin + 2 -> %Checks for adjacency
        (ColIndexEnd > ColIndexBegin - 2 ->
            (RowIndexEnd < RowIndexBegin + 2 ->
                (RowIndexEnd > RowIndexBegin - 2 ->
                    (
                        getBoard(GameState,Board),
                        getPieces(GameState,AllPieces),
                        getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[EndHeadValue|_TailValue]), %Checks destination space
                            (EndHeadValue = whiteBall -> 
                                ValidEnd = 'False'
                            ; 
                                (EndHeadValue = blackBall -> 
                                    ValidEnd = 'False'
                                ; 
                                    (Player = 'White' -> 
                                        (EndHeadValue = whiteRing -> 
                                            ValidEnd = 'True' 
                                        ; 
                                            ValidEnd = 'False'
                                        )
                                    ;
                                        (EndHeadValue = blackRing -> 
                                            ValidEnd = 'True' 
                                        ; 
                                            ValidEnd = 'False'
                                        )
                                    )
                                ) 
                            )
                    )
                ;
                    isBallVaultValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,ValidVault,OpponentBalls,ValidRelocateMoves), %Checks if valid vault
                    (ValidVault = 'True' ->
                        ValidEnd = 'True'
                    ;
                        ValidEnd = 'False'
                    )
                )
            ;
                isBallVaultValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,ValidVault,OpponentBalls,ValidRelocateMoves),
                (ValidVault = 'True' ->
                    ValidEnd = 'True'
                ;
                    ValidEnd = 'False'
                )     
            )
        ;
            isBallVaultValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,ValidVault,OpponentBalls,ValidRelocateMoves),
            (ValidVault = 'True' ->
                ValidEnd = 'True'
            ;
                ValidEnd = 'False'
            )      
        )
    ;
        isBallVaultValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,ValidVault,OpponentBalls,ValidRelocateMoves),
        (ValidVault = 'True' ->
            ValidEnd = 'True'
        ;
            ValidEnd = 'False'
        )
    ).

/**
Valid Relocate
Checks if a move is a valid relocate
Relocating a ball doesn't have to be to an adjacent spaces, but has to be to a space with a ring of the balls colour on top
*/
%isBallRelocateValid(+GameState,+Move,+Player,-ValidEnd)
isBallRelocateEndValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,ValidEnd):-
    (
    getBoard(GameState,Board),
    getPieces(GameState,AllPieces),
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[EndHeadValue|_TailValue]),
        (EndHeadValue = whiteBall -> 
            ValidEnd = 'False'
        ; 
            (EndHeadValue = blackBall -> 
                ValidEnd = 'False'
            ; 
                (Player = 'White' -> 
                    (EndHeadValue = whiteRing -> 
                        ValidEnd = 'True' 
                    ; 
                        ValidEnd = 'False'
                    )
                ;
                    (EndHeadValue = blackRing -> 
                        ValidEnd = 'True' 
                    ; 
                        ValidEnd = 'False'
                    )
                )
            ) 
        )
    ).

/**
Valid Vault
Checks if a move is a valid vault
Vaulting implies destination space haveing a ring of the ball's colour and every space in between start and finish having balls on top
Also, every opponent ball vaulted over must be relocated correctly, if not it isn't a valid vault
*/

/**If Col Begin = Col End, vault is vertical, calls checkValidVerticalVault and then checkIfCanRelocate*/
%isBallVaultValid(+GameState,+Move,+Player,-ValidEnd, -OpponentBalls)
isBallVaultValid(GameState,[ColIndexEnd,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],'White',ValidEnd,OpponentBalls, ValidRelocateMoves) :-
    getBoard(GameState, Board),
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[EndHeadValue|_TailValue]),
    (EndHeadValue = whiteRing ->
        (RowIndexEnd > RowIndexBegin ->
            RowIndexEnd1 is RowIndexEnd - 1,
            checkValidVerticalVault(Board,[ColIndexEnd,RowIndexBegin,ColIndexEnd,RowIndexEnd1,Piece],'White',ValidVault,[],OpponentBalls),
            checkIfCanRelocate(GameState, 'Black', OpponentBalls, ValidRelocateMoves, ValidRelocate),
            (ValidVault = 'True' ->
                (ValidRelocate = 'True' ->
                    ValidEnd = 'True'
                ;
                    ValidEnd = 'False'
                )
            ;
                ValidEnd = 'False'
            )
        ;
            RowIndexBegin1 is RowIndexBegin - 1,
            checkValidVerticalVault(Board,[ColIndexEnd,RowIndexEnd,ColIndexEnd,RowIndexBegin1,Piece],'White',ValidVault,[],OpponentBalls), %This call makes sure to check in a descending order
            checkIfCanRelocate(GameState, 'Black', OpponentBalls, ValidRelocateMoves, ValidRelocate),
            (ValidVault = 'True' ->
                (ValidRelocate = 'True' ->
                    ValidEnd = 'True'
                ;
                    ValidEnd = 'False'
                )
            ;
                ValidEnd = 'False'
            )
        )
    ;
        ValidEnd = 'False'
    ).

isBallVaultValid(GameState,[ColIndexEnd,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],'Black',ValidEnd,OpponentBalls, ValidRelocateMoves) :-
    getBoard(GameState, Board),
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[EndHeadValue|_TailValue]),
    (EndHeadValue = blackRing ->
        (RowIndexEnd > RowIndexBegin ->
            RowIndexEnd1 is RowIndexEnd - 1,
            checkValidVerticalVault(Board,[ColIndexEnd,RowIndexBegin,ColIndexEnd,RowIndexEnd1,Piece],'Black',ValidVault,[],OpponentBalls),
            checkIfCanRelocate(GameState, 'White', OpponentBalls, ValidRelocateMoves, ValidRelocate),
            (ValidVault = 'True' ->
                (ValidRelocate = 'True' ->
                    ValidEnd = 'True'
                ;
                    ValidEnd = 'False'
                )
            ;
                ValidEnd = 'False'
            )
        ;
            RowIndexBegin1 is RowIndexBegin - 1,
            checkValidVerticalVault(Board,[ColIndexEnd,RowIndexEnd,ColIndexEnd,RowIndexBegin1,Piece],'Black',ValidVault,[],OpponentBalls),
            checkIfCanRelocate(GameState, 'White', OpponentBalls, ValidRelocateMoves, ValidRelocate),
            (ValidVault = 'True' ->
                (ValidRelocate = 'True' ->
                    ValidEnd = 'True'
                ;
                    ValidEnd = 'False'
                )
            ;
                ValidEnd = 'False'
            )
        )
    ;
        ValidEnd = 'False'
    ).

/**If Row Begin = Row End, vault is horizontal, calls checkValidHorizontalVault and then checkIfCanRelocate*/
isBallVaultValid(GameState,[ColIndexBegin,RowIndexEnd,ColIndexEnd,RowIndexEnd,Piece],'White',ValidEnd,OpponentBalls, ValidRelocateMoves) :-
    getBoard(GameState, Board),
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[EndHeadValue|_TailValue]),
    (EndHeadValue = whiteRing ->
        (ColIndexEnd > ColIndexBegin ->
            ColIndexEnd1 is ColIndexEnd - 1,
            checkValidHorizontalVault(Board,[ColIndexBegin,RowIndexEnd,ColIndexEnd1,RowIndexEnd,Piece],'White',ValVaultnd,[],OpponentBalls),
            checkIfCanRelocate(GameState, 'Black', OpponentBalls, ValidRelocateMoves, ValidRelocate),
            (ValidVault = 'True' ->
                (ValidRelocate = 'True' ->
                    ValidEnd = 'True'
                ;
                    ValidEnd = 'False'
                )
            ;
                ValidEnd = 'False'
            )
        ;
            ColIndexBegin1 is ColIndexBegin - 1,
            checkValidHorizontalVault(Board,[ColIndexEnd,RowIndexEnd,ColIndexBegin1,RowIndexEnd,Piece],'White',ValVaultnd,[],OpponentBalls),
            checkIfCanRelocate(GameState, 'Black', OpponentBalls, ValidRelocateMoves, ValidRelocate),
            (ValidVault = 'True' ->
                (ValidRelocate = 'True' ->
                    ValidEnd = 'True'
                ;
                    ValidEnd = 'False'
                )
            ;
                ValidEnd = 'False'
            )
        )
    ;
        ValidEnd = 'False'
    ).

isBallVaultValid(GameState,[ColIndexBegin,RowIndexEnd,ColIndexEnd,RowIndexEnd,Piece],'Black',ValidEnd,OpponentBalls, ValidRelocateMoves) :-
    getBoard(GameState, Board),
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[EndHeadValue|_TailValue]),
    (EndHeadValue = blackRing ->
        (ColIndexEnd > ColIndexBegin -> 
            ColIndexEnd1 is ColIndexEnd - 1,
            checkValidHorizontalVault(Board,[ColIndexBegin,RowIndexEnd,ColIndexEnd1,RowIndexEnd,Piece],'Black',ValVaultnd,[],OpponentBalls),
            checkIfCanRelocate(GameState, 'White', OpponentBalls, ValidRelocateMoves, ValidRelocate),
            (ValidVault = 'True' ->
                (ValidRelocate = 'True' ->
                    ValidEnd = 'True'
                ;
                    ValidEnd = 'False'
                )
            ;
                ValidEnd = 'False'
            )
        ;
            ColIndexBegin1 is ColIndexBegin - 1,
            checkValidHorizontalVault(Board,[ColIndexEnd,RowIndexEnd,ColIndexBegin1,RowIndexEnd,Piece],'Black',ValVaultnd,[],OpponentBalls),
            checkIfCanRelocate(GameState, 'White', OpponentBalls, ValidRelocateMoves, ValidRelocate),
            (ValidVault = 'True' ->
                (ValidRelocate = 'True' ->
                    ValidEnd = 'True'
                ;
                    ValidEnd = 'False'
                )
            ;
                ValidEnd = 'False'
            )
        )
    ;
        ValidEnd = 'False'
    ).

/**If none of the above, ValidEnd = 'False'*/
isBallVaultValid(_GameState,_Move,_Player,'False',_OpponentBalls,_ValidRelocateMoves).

/**
Check Valid Vertical Vault
Verifies if every space between start and finish has a ball on top
Saves opponents balls positions
Row by row
*/
%checkValidVerticalVault(+Board,+Move,+Player,-ValidEnd,+OldOpponentBalls,-NewOpponentBalls)
checkValidVerticalVault(Board,[ColIndexBegin,RowIndexEnd,ColIndexEnd,RowIndexEnd,Piece],Player,'True',OpponentBalls,OpponentBalls). %If starting position = ending position, already verified every position between, so ValidEnd is 'True'

checkValidVerticalVault(Board,[ColIndexEnd,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],'White',ValidEnd,OldOpponentBalls,NewOpponentBalls) :- %If Row end > Row begin, check for a ball
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[HeadValue|_TailValue]),
    (HeadValue = blackBall ->
        RowIndexEnd1 is RowIndexEnd - 1, %Move one row
        IntermediateOpponentBalls = [[ColIndexEnd, RowIndexEnd] | OldOpponentBalls], %If it is an opponents ball, save position
        checkValidVerticalVault(Board, [ColIndexEnd,RowIndexBegin,ColIndexEnd,RowIndexEnd1,Piece], 'White', ValidEnd,IntermediateOpponentBalls,NewOpponentBalls) %Check again

    ;
        (HeadValue = whiteBall ->
            RowIndexEnd1 is RowIndexEnd - 1,
            checkValidVerticalVault(Board, [ColIndexEnd,RowIndexBegin,ColIndexEnd,RowIndexEnd1,Piece], 'White', ValidEnd,OldOpponentBalls, NewOpponentBalls)
        ;
            ValidEnd = 'False',
            OldOpponentBalls = [],
            !
        )
    ).

checkValidVerticalVault(Board,[ColIndexEnd,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],'Black',ValidEnd,OldOpponentBalls,NewOpponentBalls) :-
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[HeadValue|_TailValue]),
    (HeadValue = whiteBall ->
        RowIndexEnd1 is RowIndexEnd - 1,
        IntermediateOpponentBalls = [[ColIndexEnd, RowIndexEnd] | OpponentBalls],
        checkValidVerticalVault(Board, [ColIndexEnd,RowIndexBegin,ColIndexEnd,RowIndexEnd1,Piece], 'Black', ValidEnd,IntermediateOpponentBalls,NewOpponentBalls)

    ;
        (HeadValue = blackBall ->
            RowIndexEnd1 is RowIndexEnd - 1,
            checkValidVerticalVault(Board, [ColIndexEnd,RowIndexBegin,ColIndexEnd,RowIndexEnd1,Piece], 'Black', ValidEnd,OldOpponentBalls,NewOpponentBalls)
        ;
            ValidEnd = 'False',
            OldOpponentBalls = [],
            !
        )
    ).

/**
Check Valid Horizontal Vault
Verifies if every space between start and finish has a ball on top
Saves opponents balls positions
Col by Col
*/
%checkValidHorizontalVault(+Board,+Move,+Player,-ValidEnd,-OldOpponentBalls,+NewOpponentBalls)
checkValidHorizontalVault(Board,[ColIndexBegin,RowIndexBegin,ColIndexBegin,RowIndexEnd,Piece],Player,'True',OpponentBalls,OpponentBalls). %If starting position = ending position, already verified every position between, so ValidEnd is 'True'

checkValidHorizontalVault(Board,[ColIndexBegin,RowIndexEnd,ColIndexEnd,RowIndexEnd,Piece],'White',ValidEnd,OldOpponentBalls,NewOpponentBalls) :- %If Col end > Col begin, check for a ball
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[HeadValue|_TailValue]),
    (HeadValue = blackBall ->
        ColIndexEnd1 is ColIndexEnd - 1, %Move one col
        IntermediateOpponentBalls = [[ColIndexEnd, RowIndexEnd] | OldOpponentBalls], %If it is an opponents ball, save position
        checkValidHorizontalVault(Board, [ColIndexBegin,RowIndexBegin,ColIndexEnd1,RowIndexEnd,Piece], 'White', ValidEnd,IntermediateOpponentBalls,NewOpponentBalls) %Check again

    ;
        (HeadValue = whiteBall ->
            ColIndexEnd1 is ColIndexEnd - 1,
            checkValidHorizontalVault(Board, [ColIndexBegin,RowIndexBegin,ColIndexEnd1,RowIndexEnd,Piece], 'White', ValidEnd,OldOpponentBalls,NewOpponentBalls)
        ;
            ValidEnd = 'False',
            OldOpponentBalls = [],
            !
        )
    ).

checkValidHorizontalVault(Board,[ColIndexBegin,RowIndexEnd,ColIndexEnd,RowIndexEnd,Piece],'Black',ValidEnd,OldOpponentBalls,NewOpponentBalls) :-
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[HeadValue|_TailValue]),
    (HeadValue = whiteBall ->
        ColIndexEnd1 is ColIndexEnd - 1,
        IntermediateOpponentBalls = [[ColIndexEnd, RowIndexEnd] | OldOpponentBalls],
        checkValidHorizontalVault(Board, [ColIndexBegin,RowIndexBegin,ColIndexEnd1,RowIndexEnd,Piece], 'Black', ValidEnd,IntermediateOpponentBalls,NewOpponentBalls)

    ;
        (HeadValue = blackBall ->
            ColIndexEnd1 is ColIndexEnd - 1,
            checkValidHorizontalVault(Board, [ColIndexBegin,RowIndexBegin,ColIndexEnd1,RowIndexEnd,Piece], 'Black', ValidEnd, OldOpponentBalls,NewOpponentBalls)
        ;
            ValidEnd = 'False',
            OldOpponentBalls = [],
            !
        )
    ).

/**
Check if can Relocate
Verifies if every opponent ball vaulted over can be relocated
Uses saved opponents balls positions
Saves a list of valid relocate moves
*/
%checkIfCanRelocate(+GameState, +Player, +OpponentBalls, -ValidRelocateMoves, -ValidRelocate)
checkIfCanRelocate(_GameState, _Player, []).

checkIfCanRelocate(GameState, Player, OpponentBalls, List, ValidRelocate) :-
    ballRelocateMovesWraper(GameState, Player, OpponentBalls, OldList, List), %Gets list of valid moves based on opponent balls
    length(OpponentBalls, OpB),
    length(List, N),
    OpB2 is (OpB*OpB),
    (N >= OpB2 ->
        ValidRelocate = 'True'
    ;
        ValidRelocate = 'False'
    ).


/**
Move
Actually moves a piece on the board
Removes from one place and adds on top of another
(Or just adds and removes from hand if ring from hand is played)
Yields a new game state
*/

/**If start is (-1, -1), just adds on map and removes from pieces*/
%move(+GameState, +Move, +Player ,-NewGameState)
move([Board, AllPieces],[-1,-1,ColIndexEnd,RowIndexEnd,Piece], 'White',NewGameState):-
    addValueInMap(Board, RowIndexEnd, ColIndexEnd, Piece, NewBoard),
    AllPieces = [[_Played|NewWhitePieces], BlackPieces],
    NewAllPieces = [NewWhitePieces, BlackPieces],
    NewGameState = [NewBoard, NewAllPieces].


move([Board, AllPieces],[-1,-1,ColIndexEnd,RowIndexEnd,Piece],'Black',NewGameState):-
    addValueInMap(Board, RowIndexEnd, ColIndexEnd, Piece, NewBoard),
    AllPieces = [WhitePieces, [_Played|NewBlackPieces]],
    NewAllPieces = [WhitePieces, NewBlackPieces],
    NewGameState = [NewBoard, NewAllPieces].

/**If start is not (-1, -1), removes from start and adds on destination*/
move(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece], Player, NewGameState):-
    removeValueFromMapUsingGameState(GameState, RowIndexBegin, ColIndexBegin, IntermediateGameState, Removed),
    getBoard(IntermediateGameState,IntermediateBoard),
    getPieces(IntermediateGameState,IntermediatePieces),
    addValueInMap(IntermediateBoard, RowIndexEnd, ColIndexEnd, Piece, NewBoard),
    NewGameState = [NewBoard|[IntermediatePieces]].





/**
Valid Moves
Retrieves every valid move at a given time
*/

%valid_moves(+GameState, +Player, -ListOfMoves)
valid_moves(GameState, 'WhiteRing', ListOfMoves):-
    ringValidMoves(GameState, 'WhiteRing', ListOfMoves).

valid_moves(GameState, 'BlackRing', ListOfMoves):-
    ringValidMoves(GameState, 'BlackRing', ListOfMoves).

valid_moves(GameState, 'WhiteBall', ListOfMoves):-
    ballValidMoves(GameState, 'WhiteBall', ListOfMoves).

valid_moves(GameState, 'BlackBall', ListOfMoves):-
    ballValidMoves(GameState, 'BlackBall', ListOfMoves).


/**
Ring Valid Moves
Divided in start and end
Returns a list of valid moves
*/
%ringValidMoves(+GameState, +Player, -ListOfMoves)
ringValidMoves(GameState, 'WhiteRing', ListOfMoves):-
    ringStartValidMoves(GameState, 'White', 4, 4, [], ListOfStartMoves),
    ringEndValidMovesWraper(GameState, 'White', ListOfStartMoves, [], ListOfEndMoves),
    ListOfMoves = ListOfEndMoves.

ringValidMoves(GameState, 'BlackRing', ListOfMoves):-
    ringStartValidMoves(GameState, 'Black', 4, 4, [], ListOfStartMoves),
    ringEndValidMovesWraper(GameState, 'Black', ListOfStartMoves, [], ListOfEndMoves),
    ListOfMoves = ListOfEndMoves.

/**
Ring Start Valid Moves
Checks every space for a ring of that colour on top
Scans the board and calls isRingStartMoveValid
Returns a list of valid start moves
*/
%ringStartValidMoves(+GameState, +Player, +Col, +Row, ListOfStartMoves, -NewListOfStartMoves) [Col,Row]
ringStartValidMoves(GameState, Player, 0, 0, ListOfStartMoves, NewListOfStartMoves):-
    (Player = 'White' -> 
        isRingMoveStartValid(GameState,[0,0,0,0,whiteRing],Player,ValidStart)
    ; 
        isRingMoveStartValid(GameState,[0,0,0,0,blackRing],Player,ValidStart)
    ),
    (ValidStart = 'True' -> 
        IntermidiateListOfStartMoves = [ [0,0] | ListOfStartMoves]
    ;
        IntermidiateListOfStartMoves = ListOfStartMoves
    ),
    ringStartValidMoves(GameState, Player, -1, -1, IntermidiateListOfStartMoves, NewListOfStartMoves).


ringStartValidMoves(GameState, Player, -1, -1, ListOfStartMoves, NewListOfStartMoves):-
    (Player = 'White' -> 
        isRingMoveStartValid(GameState,[-1,-1,0,0,whiteRing],Player,ValidStart)
    ; 
        isRingMoveStartValid(GameState,[-1,-1,0,0,blackRing],Player,ValidStart)
    ),
    (ValidStart = 'True' -> 
        NewListOfStartMoves = [ [-1,-1] | ListOfStartMoves]
    ;
        NewListOfStartMoves = ListOfStartMoves
    ).


ringStartValidMoves(GameState, Player, Col, Row, ListOfStartMoves ,NewListOfStartMoves):-
    (Player = 'White' ->
        isRingMoveStartValid(GameState,[Col,Row,0,0,whiteRing],Player,ValidStart)
    ;
        isRingMoveStartValid(GameState,[Col,Row,0,0,blackRing],Player,ValidStart)
    ),
    (ValidStart = 'True' ->
        IntermediteListOfStartMoves = [ [Col,Row] | ListOfStartMoves]
    ;
        IntermediteListOfStartMoves = ListOfStartMoves
    ), 
    Col1 is Col-1 ,
    (Col1 = -1 -> 
        Col2 = 4, Row1 is Row - 1,
        ringStartValidMoves(GameState, Player, Col2, Row1, IntermediteListOfStartMoves, NewListOfStartMoves)
    ;
        ringStartValidMoves(GameState, Player, Col1, Row, IntermediteListOfStartMoves, NewListOfStartMoves)
    ).

/**
Ring End Valid Moves
Uses the list of start moves 
Scans the board and calls isRingEndMoveValid
Adds the start and end moves to create full moves
Returns a list of valid moves
*/

/**Wrapper for if there are no valid start moves*/
%ringEndValidMovesWraper(+GameState, +Player, +ListOfStartMoves, +ListOfEndMoves, -NewListOfEndMoves)
ringEndValidMovesWraper(GameState, Player, [], ListOfEndMoves, NewListOfEndMoves):-
    NewListOfEndMoves = ListOfEndMoves.

ringEndValidMovesWraper(GameState, Player, [ [ColStart, RowStart] | ListOfStartMoves], ListOfEndMoves, NewListOfEndMoves):-
    ringEndValidMoves(GameState, Player, ColStart, RowStart, 4,4, ListOfEndMoves, IntermediaryListOfEndMoves),
    ringEndValidMovesWraper(GameState, Player, ListOfStartMoves, IntermediaryListOfEndMoves, NewListOfEndMoves).

%ringEndValidMoves(+GameState, +Player, +ColStart, +RowStart, +Col, +Row, +ListOfEndMoves, -NewListOfEndMoves) [Col,Row]
ringEndValidMoves(GameState, Player, ColStart, RowStart, 0, 0, ListOfEndMoves, NewListOfEndMoves):- 
    (Player = 'White' -> 
        isRingMoveEndValid(GameState,[ColStart, RowStart,0,0,whiteRing],Player,ValidEnd)
    ; 
        isRingMoveEndValid(GameState,[ColStart, RowStart,0,0,blackRing],Player,ValidEnd)
    ),
    (ValidEnd = 'True' -> 
        (Player = 'White' -> 
            NewListOfEndMoves = [ [ColStart, RowStart, 0, 0, whiteRing] | ListOfEndMoves]
        ;
            NewListOfEndMoves = [ [ColStart, RowStart, 0, 0, blackRing] | ListOfEndMoves]
        )
        
    ;
        NewListOfEndMoves = ListOfEndMoves
    ).


ringEndValidMoves(GameState, Player, ColStart, RowStart, Col, Row, ListOfEndMoves ,NewListOfEndMoves):-
    (Player = 'White' ->
        isRingMoveEndValid(GameState,[ColStart, RowStart,Col,Row,whiteRing],Player,ValidEnd)
    ;
        isRingMoveEndValid(GameState,[ ColStart, RowStart,Col,Row,blackRing],Player,ValidEnd)
    ),
    (ValidEnd = 'True' ->
        (Player = 'White' -> 
            IntermediteListOfEndMoves = [ [ColStart, RowStart, Col, Row, whiteRing] | ListOfEndMoves]
        ;
            IntermediteListOfEndMoves = [ [ColStart, RowStart, Col, Row, blackRing] | ListOfEndMoves]
        )
    ;
        IntermediteListOfEndMoves = ListOfEndMoves
    ), 
    Col1 is Col-1 ,
    (Col1 = -1 -> 
        Col2 = 4, Row1 is Row - 1,
        ringEndValidMoves(GameState, Player, ColStart, RowStart, Col2, Row1, IntermediteListOfEndMoves, NewListOfEndMoves)
    ;
        ringEndValidMoves(GameState, Player, ColStart, RowStart, Col1, Row, IntermediteListOfEndMoves, NewListOfEndMoves)
    ).





/**
Ball Valid Moves
Divided in start and end
Returns a list of valid moves
*/
%ballValidMoves(+GameState, +Player, -ListOfMoves)
ballValidMoves(GameState, 'WhiteBall', ListOfMoves):-
    ballStartValidMoves(GameState, 'White', 4, 4, [], ListOfStartMoves),
    ballEndValidMovesWraper(GameState, 'White', ListOfStartMoves, [], ListOfEndMoves),
    ListOfMoves = ListOfEndMoves. 

ballValidMoves(GameState, 'BlackBall', ListOfMoves):-
    ballStartValidMoves(GameState, 'Black', 4, 4, [], ListOfStartMoves),
    ballEndValidMovesWraper(GameState, 'Black', ListOfStartMoves, [], ListOfEndMoves),
    ListOfMoves = ListOfEndMoves.   

/**
Ball Start Valid Moves
Checks every space for a ball of that colour on top
Scans the board and calls isBallStartMoveValid
Returns a list of valid start moves
*/
%ballStartValidMoves(+GameState, +Player, +Col, +Row, ListOfStartMoves, -NewListOfStartMoves) [Col,Row]
ballStartValidMoves(GameState, Player, 0, 0, ListOfStartMoves, NewListOfStartMoves):-
    (Player = 'White' -> 
        isBallMoveStartValid(GameState,[0,0,0,0,whiteBall],Player,ValidStart)
    ; 
        isBallMoveStartValid(GameState,[0,0,0,0,blackBall],Player,ValidStart)
    ),
    (ValidStart = 'True' -> 
        NewListOfStartMoves = [ [0,0] | ListOfStartMoves]
    ;
        NewListOfStartMoves = ListOfStartMoves
    ).




ballStartValidMoves(GameState, Player, Col, Row, ListOfStartMoves ,NewListOfStartMoves):-
    (Player = 'White' ->
        isBallMoveStartValid(GameState,[Col,Row,0,0,whiteBall],Player,ValidStart)
    ;
        isBallMoveStartValid(GameState,[Col,Row,0,0,blackBall],Player,ValidStart)
    ),
    (ValidStart = 'True' ->
        IntermediteListOfStartMoves = [ [Col,Row] | ListOfStartMoves]
    ;
        IntermediteListOfStartMoves = ListOfStartMoves
    ), 
    Col1 is Col-1 ,
    (Col1 = -1 -> 
        Col2 = 4, Row1 is Row - 1,
        ballStartValidMoves(GameState, Player, Col2, Row1, IntermediteListOfStartMoves, NewListOfStartMoves)
    ;
        ballStartValidMoves(GameState, Player, Col1, Row, IntermediteListOfStartMoves, NewListOfStartMoves)
    ).

/**
Ball End Valid Moves
Uses the list of start moves 
Scans the board and calls isBallEndMoveValid
Adds the start and end moves to create full moves
Returns a list of valid moves
*/

/**Wrapper for if there are no valid start moves*/
%ballEndValidMovesWraper(+GameState, +Player, +ListOfStartMoves, +ListOfEndMoves, -NewListOfEndMoves)
ballEndValidMovesWraper(GameState, Player, [[]], ListOfEndMoves, NewListOfEndMoves):-
    NewListOfEndMoves = ListOfEndMoves.
ballEndValidMovesWraper(GameState, Player, [], ListOfEndMoves, NewListOfEndMoves):-
    NewListOfEndMoves = ListOfEndMoves.

ballEndValidMovesWraper(GameState, Player, [ [ColStart, RowStart] | ListOfStartMoves], ListOfEndMoves, NewListOfEndMoves):-
    ballEndValidMoves(GameState, Player, ColStart, RowStart, 4,4, ListOfEndMoves, IntermediaryListOfEndMoves),
    ballEndValidMovesWraper(GameState, Player, ListOfStartMoves, IntermediaryListOfEndMoves, NewListOfEndMoves).


%ballEndValidMoves(+GameState, +Player, +ColStart, +RowStart, +Col, +Row, +ListOfEndMoves, -NewListOfEndMoves) [Col,Row]
ballEndValidMoves(GameState, Player, ColStart, RowStart, 0, 0, ListOfEndMoves, NewListOfEndMoves):- 
    (Player = 'White' -> 
        isBallMoveEndValid(GameState,[ColStart, RowStart,0,0,whiteBall],Player,ValidEnd,_)
    ; 
        isBallMoveEndValid(GameState,[ColStart, RowStart,0,0,blackBall],Player,ValidEnd,_)
    ),
    (ValidEnd = 'True' -> 
        (Player = 'White' -> 
            NewListOfEndMoves = [ [ColStart, RowStart, 0, 0, whiteBall] | ListOfEndMoves]
        ;
            NewListOfEndMoves = [ [ColStart, RowStart, 0, 0, blackBall] | ListOfEndMoves]
        )
        
    ;
        NewListOfEndMoves = ListOfEndMoves
    ).

ballEndValidMoves(GameState, Player, ColStart, RowStart, Col, Row, ListOfEndMoves ,NewListOfEndMoves):-
    (Player = 'White' ->
        isBallMoveEndValid(GameState,[ColStart, RowStart,Col,Row,whiteBall],Player,ValidEnd,_)
    ;
        isBallMoveEndValid(GameState,[ ColStart, RowStart,Col,Row,blackBall],Player,ValidEnd,_)
    ),
    (ValidEnd = 'True' ->
        (Player = 'White' -> 
            IntermediteListOfEndMoves = [ [ColStart, RowStart, Col, Row, whiteBall] | ListOfEndMoves]
        ;
            IntermediteListOfEndMoves = [ [ColStart, RowStart, Col, Row, blackBall] | ListOfEndMoves]
        )
    ;
        IntermediteListOfEndMoves = ListOfEndMoves
    ), 
    Col1 is Col-1 ,
    (Col1 = -1 -> 
        Col2 = 4, Row1 is Row - 1,
        ballEndValidMoves(GameState, Player, ColStart, RowStart, Col2, Row1, IntermediteListOfEndMoves, NewListOfEndMoves)
    ;
        ballEndValidMoves(GameState, Player, ColStart, RowStart, Col1, Row, IntermediteListOfEndMoves, NewListOfEndMoves)
    ).

/**
Ball Relocate Valid Moves
Uses the list of opponent balls positions
Scans the board and calls isBallRelocateValid
Creates full moves
Returns a list of valid moves
*/

%ballRelocateMovesWraper(+GameState, +Player, +ListOfStartMoves, +ListOfEndMoves, -NewListOfEndMoves)
ballRelocateMovesWraper(GameState, Player, [[]], ListOfEndMoves, NewListOfEndMoves):-
    NewListOfEndMoves = ListOfEndMoves.
ballRelocateMovesWraper(GameState, Player, [], ListOfEndMoves, NewListOfEndMoves):-
    NewListOfEndMoves = ListOfEndMoves.

ballRelocateMovesWraper(GameState, Player, [ [ColStart, RowStart] | ListOfStartMoves], ListOfEndMoves, NewListOfEndMoves):-
    ballRelocateMoves(GameState, Player, ColStart, RowStart, 4,4, ListOfEndMoves, IntermediaryListOfEndMoves),
    ballRelocateMovesWraper(GameState, Player, ListOfStartMoves, IntermediaryListOfEndMoves, NewListOfEndMoves).


%ballRelocateMoves(+GameState, +Player, +ColStart, +RowStart, +Col, +Row, +ListOfEndMoves, -NewListOfEndMoves) [Col,Row]
ballRelocateMoves(GameState, Player, ColStart, RowStart, 0, 0, ListOfEndMoves, NewListOfEndMoves):- 
    (Player = 'White' -> 
        isBallRelocateValid(GameState,[ColStart, RowStart,0,0,whiteBall],Player,ValidEnd)
    ; 
        isBallRelocateValid(GameState,[ColStart, RowStart,0,0,blackBall],Player,ValidEnd)
    ),
    (ValidEnd = 'True' -> 
        (Player = 'White' -> 
            NewListOfEndMoves = [ [ColStart, RowStart, 0, 0, whiteBall] | ListOfEndMoves]
        ;
            NewListOfEndMoves = [ [ColStart, RowStart, 0, 0, blackBall] | ListOfEndMoves]
        )
        
    ;
        NewListOfEndMoves = ListOfEndMoves
    ).

ballRelocateMoves(GameState, Player, ColStart, RowStart, Col, Row, ListOfEndMoves ,NewListOfEndMoves):-
    (Player = 'White' ->
        isBallRelocateValid(GameState,[ColStart, RowStart,Col,Row,whiteBall],Player,ValidEnd)
    ;
        isBallRelocateValid(GameState,[ ColStart, RowStart,Col,Row,blackBall],Player,ValidEnd)
    ),
    (ValidEnd = 'True' ->
        (Player = 'White' -> 
            IntermediteListOfEndMoves = [ [ColStart, RowStart, Col, Row, whiteBall] | ListOfEndMoves]
        ;
            IntermediteListOfEndMoves = [ [ColStart, RowStart, Col, Row, blackBall] | ListOfEndMoves]
        )
    ;
        IntermediteListOfEndMoves = ListOfEndMoves
    ), 
    Col1 is Col-1 ,
    (Col1 = -1 -> 
        Col2 = 4, Row1 is Row - 1,
        ballRelocateMoves(GameState, Player, ColStart, RowStart, Col2, Row1, IntermediteListOfEndMoves, NewListOfEndMoves)
    ;
        ballRelocateMoves(GameState, Player, ColStart, RowStart, Col1, Row, IntermediteListOfEndMoves, NewListOfEndMoves)
    ).

isBallRelocateValid(GameState,[ColStart, RowStart,ColEnd,RowEnd,whiteBall],'White',ValidEnd) :-
    getBoard(GameState, Board),
    getValueInMapStackPosition(Board,RowEnd,ColEnd,[EndHeadValue|_TailValue]),
    (EndHeadValue = whiteRing ->
        ValidEnd = 'True'
    ;
        ValidEnd = 'False'
    ).

isBallRelocateValid(GameState,[ColStart, RowStart,ColEnd,RowEnd,blackBall],'Black',ValidEnd) :-
    getBoard(GameState, Board),
    getValueInMapStackPosition(Board,RowEnd,ColEnd,[EndHeadValue|_TailValue]),
    (EndHeadValue = blackRing ->
        ValidEnd = 'True'
    ;
        ValidEnd = 'False'
    ).

/**Check Win*/

/**
Game Over
Checks if all players balls are on the opposite bases
If so, HasWon = 'True'
*/
%game_over(+GameState,+Player,-HasWon)
game_over(GameState,Player,HasWon):-
    getBoard(GameState,Board),
    areBallsOnOpositeBase(Board,Player,Bool),
    HasWon = Bool.

/**Gets opponents bases and checks for balls of players colour on top*/
%areBallsOnOpositeBase(+Board,+Player,-Bool)
areBallsOnOpositeBase(Board,'White',Bool):-
    getOpponentBaseStack(Board,'White',Base1,Base2,Base3),
    isBallOfColorOnTop(Base1,'White',Bool1),
    isBallOfColorOnTop(Base2,'White',Bool2),
    isBallOfColorOnTop(Base3,'White',Bool3),
    arefirst3BoolsTrue(Bool1,Bool2,Bool3,Bool).



areBallsOnOpositeBase(Board,'Black',Bool):-
    getOpponentBaseStack(Board,'Black',Base1,Base2,Base3),
    isBallOfColorOnTop(Base1,'Black',Bool1),
    isBallOfColorOnTop(Base2,'Black',Bool2),
    isBallOfColorOnTop(Base3,'Black',Bool3),
    arefirst3BoolsTrue(Bool1,Bool2,Bool3,Bool).  



/**Bools is true if players ball is on top of stak*/
%isBallOfColorOnTop(+Stack,+Player,-Bool)
isBallOfColorOnTop([Head|_Tail],'White',Bool):-
    (Head = whiteBall -> Bool = 'True' ; Bool = 'False').

isBallOfColorOnTop([Head|_Tail],'Black',Bool):-
    (Head = blackBall -> Bool = 'True' ; Bool = 'False').

/** Utils */

/**Bool is true if all first three bools are true*/
%arefirst3BoolsTrue(+Bool1,+Bool2,+Bool3,-Bool)
arefirst3BoolsTrue(Bool1,Bool2,Bool3,Bool):-
    Bool1 = 'True',
    Bool2 = 'True',
    Bool3 = 'True',
    Bool = 'True'.

arefirst3BoolsTrue(Bool1,Bool2,Bool3,Bool):-
    Bool = 'False'.


/**Gets values on top of every opponent home space*/
%getOpponentBaseStack(+Board,+Player,-Base1,-Base2,-Base3)
getOpponentBaseStack(Board,'White',Base1,Base2,Base3):-
    getValueInMapStackPosition(Board,0,3,Base1),
    getValueInMapStackPosition(Board,0,4,Base2),
    getValueInMapStackPosition(Board,1,4,Base3).
    

getOpponentBaseStack(Board,'Black',Base1,Base2,Base3):-
    getValueInMapStackPosition(Board,4,0,Base1),
    getValueInMapStackPosition(Board,4,1,Base2),
    getValueInMapStackPosition(Board,3,0,Base3).

/**Write who won*/
%won(+WhoWon)
won('White'):-
    nl,nl,nl,
    write('|| White wins ||'),nl,nl,nl.

won('Black'):-
    nl,nl,nl,
    write('|| Black wins ||'),nl,nl,nl.



test(Num):- Nothing = 0.


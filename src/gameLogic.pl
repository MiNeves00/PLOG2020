/**Start Game */
%gameStart(+TypeOfPlayer1, +TypeOfPlayer2)
gameStart('Player','Player'):-
    write('Starting Player vs Player game...'),
    nl,
    intermediateMap(GameState), %Gets initial game state
    gameLoop(GameState,'Player','Player').

/*
gameStart('Player','Com'):- %To Do
    write('Starting Player vs Com game...'),
    nl,
    initial(InitialMap),
    write('Initialized...'),
    nl,
    display_game(InitialMap).

gameStart('Com','Com'):- %To Do
    write('Starting Com vs Com game...'),
    nl,
    initial(InitialMap),
    write('Initialized...'),
    nl,
    display_game(InitialMap).
*/

/**Game Loop*/
%gameLoop(-GameState, +TypeOfPlayer1, +TypeOfPlayer2)
gameLoop(GameState,'Player','Player'):- %Each player has a turn in a loop
    display_game(GameState,'White'), %Displays game
    player_move(GameState,'White',NewGameState),
    checkIfWin(NewGameState,'White',HasWon),
    (HasWon = 'False' ->  
        display_game(NewGameState,'Black'),
        player_move(NewGameState,'Black',NewGameState2),
        checkIfWin(NewGameState2,'Black',HasWon2),
        (HasWon2 = 'False' ->
            gameLoop(NewGameState2,'Player','Player') %Recursive call to continue to next player turns
            ; 
            won('Black')
        )
        ;
        won('White')
    )
    .

/**Player Move*/
%Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece]

%player_move(+GameState,+Player,-NewGameState)
player_move(GameState,Player,NewGameState):-
    ringStep(GameState,Player,IntermediateGameState),
    display_game(IntermediateGameState,Player),
    (Player = 'White' -> 
        valid_moves(IntermediateGameState,'WhiteBall',ListOfMoves)
    ;
        valid_moves(IntermediateGameState,'BlackBall',ListOfMoves)
    ),
    ballStep(IntermediateGameState,Player,NewGameState).

%ringStep(+GameState,+Player,-NewGameState)
ringStep(GameState,Player,NewGameState):-
    readRingMove(Player, RingMove),
    handleRingMove(GameState,RingMove,Player,NewGameState).

%ballStep(+GameState, +Player, -NewGameState)
ballStep(GameState, Player, NewGameState):-
    readBallMove(Player, BallMove),
    handleBallMove(GameState,BallMove,Player,NewGameState).


/**Handle Move (for now not accurate) TO DO*/
%handleRingMove(+GameState,+Move,+Player,-NewGameState) TO DO
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


%handleBallMove(+GameState,+Move,+Player,-NewGameState) 
handleBallMove(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,NewGameState):-
    isBallMoveValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,Valid),
    (Valid = 'True' -> 
        move(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece], Player, NewGameState)
    ; 
        nl,write('Select a ball to move'),nl,nl,
        ballStep(GameState,Player,NewGameState)
    ).


%isRingMoveValid(+GameState,+Move,+Player,-Valid)
%TO DO
%isRingMoveValid(GameState,[-1,-1,ColIndexEnd,RowIndexEnd,Piece], Player, Valid):-


isRingMoveValid([_Board, [[], _BlackPieces]],[-1,-1,ColIndexEnd,RowIndexEnd,Piece], 'White', Valid):-
    Valid = 'False',
    nl,write('You dont have rings left in your hand!').

isRingMoveValid([_Board, [_WhitePieces, []]],[-1,-1,ColIndexEnd,RowIndexEnd,Piece], 'Black', Valid):-
    Valid = 'False',
    nl,write('You dont have rings left in your hand!').

isRingMoveValid(GameState,[-1,-1,ColIndexEnd,RowIndexEnd,Piece], Player, Valid):-
    getBoard(GameState,Board),
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[EndHeadValue|_TailValue]),
    (EndHeadValue = whiteBall -> 
        Valid = 'False',
        nl,write('There is a ball in the position your trying to put a ring!')
    ; 
        (EndHeadValue = blackBall -> 
            Valid = 'False',
            nl,write('There is a ball in the position your trying to put a ring!')
        ; 
            Valid = 'True'
        ) 
    ).


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

isRingMoveEndValid(GameState,[_ColIndexBegin,_RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece], Player, ValidEnd):-
    getBoard(GameState,Board),
    getPieces(GameState,AllPieces),
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[EndHeadValue|_TailValue]),
    (EndHeadValue = whiteBall -> 
        ValidEnd = 'False'
    ; 
        (EndHeadValue = blackBall -> 
            ValidEnd = 'False'
        ; 
            ValidEnd = 'True'
        ) 
    ).


%isBallMoveValid(+GameState,+Move,+Player,-Valid) %TODO
isBallMoveValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,Valid):-

    isBallMoveStartValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,ValidStart),
    isBallMoveEndValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,ValidEnd),
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

/** TODO Add error messages */

isBallMoveStartValid(GameState,[ColIndexBegin,RowIndexBegin,3,0,Piece],'White','False').
isBallMoveStartValid(GameState,[ColIndexBegin,RowIndexBegin,4,0,Piece],'White','False').
isBallMoveStartValid(GameState,[ColIndexBegin,RowIndexBegin,4,1,Piece],'White','False').

isBallMoveStartValid(GameState,[ColIndexBegin,RowIndexBegin,0,3,Piece],'Black','False').
isBallMoveStartValid(GameState,[ColIndexBegin,RowIndexBegin,0,4,Piece],'Black','False').
isBallMoveStartValid(GameState,[ColIndexBegin,RowIndexBegin,1,4,Piece],'Black','False').

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


isBallMoveEndValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,ValidEnd):-
    (ColIndexEnd < ColIndexBegin + 2 ->
        (ColIndexEnd > ColIndexBegin - 2 ->
            (RowIndexEnd < RowIndexBegin + 2 ->
                (RowIndexEnd > RowIndexBegin - 2 ->
                    (
                        getBoard(GameState,Board),
                        getPieces(GameState,AllPieces),
                        getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[EndHeadValue|_TailValue]),
                            (EndHeadValue = whiteBall -> 
                                ValidEnd = 'False',
                                nl,write('Select a place with no ball on top')
                            ; 
                                (EndHeadValue = blackBall -> 
                                    ValidEnd = 'False',
                                    nl,write('Select a place with no ball on top')
                                ; 
                                    (Player = 'White' -> 
                                        (EndHeadValue = whiteRing -> 
                                            ValidEnd = 'True' 
                                        ; 
                                            ValidEnd = 'False',
                                            nl, write('Select a destination place with a ring of your colour on top!')
                                        )
                                    ;
                                        (EndHeadValue = blackRing -> 
                                            ValidEnd = 'True' 
                                        ; 
                                            ValidEnd = 'False',
                                            nl, write('Select a destination place with a ring of your colour on top!')
                                        )
                                    )
                                ) 
                            )
                    )
                ;
                    ValidEnd = 'False',
                    nl, write('Select a destination place adjacent to your starting space!')
                )
            ;
                ValidEnd = 'False',
                nl, write('Select a destination place adjacent to your starting space!')
            )
        ;
            ValidEnd = 'False',
            nl, write('Select a destination place adjacent to your starting space!')
        )
    ;
        ValidEnd = 'False',
        nl, write('Select a destination place adjacent to your starting space!')
    ).




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


move(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece], Player, NewGameState):-
    removeValueFromMapUsingGameState(GameState, RowIndexBegin, ColIndexBegin, IntermediateGameState, Removed),
    getBoard(IntermediateGameState,IntermediateBoard),
    getPieces(IntermediateGameState,IntermediatePieces),
    addValueInMap(IntermediateBoard, RowIndexEnd, ColIndexEnd, Piece, NewBoard),
    NewGameState = [NewBoard|[IntermediatePieces]].





/**Valid Moves*/

%valid_moves(+GameState, +Player, -ListOfMoves)
valid_moves(GameState, 'WhiteRing', ListOfMoves):-
    ringValidMoves(GameState, 'WhiteRing', ListOfMoves).

valid_moves(GameState, 'BlackRing', ListOfMoves):-
    ringValidMoves(GameState, 'BlackRing', ListOfMoves).

valid_moves(GameState, 'WhiteBall', ListOfMoves):-
    ballValidMoves(GameState, 'WhiteBall', ListOfMoves).

valid_moves(GameState, 'BlackBall', ListOfMoves):-
    ballValidMoves(GameState, 'BlackBall', ListOfMoves).



%ringValidMoves(+GameState, +Player, -ListOfMoves) %TODO
ringValidMoves(GameState, 'WhiteRing', ListOfMoves).


ringValidMoves(GameState, 'BlackRing', ListOfMoves).



%ballValidMoves(+GameState, +Player, -ListOfMoves) %TODO
ballValidMoves(GameState, 'WhiteBall', ListOfMoves):-
    ballStartValidMoves(GameState, 'White', 4, 4, [], ListOfStartMoves),
    ballEndValidMovesWraper(GameState, 'White', ListOfStartMoves, [], ListOfEndMoves),
    ListOfMoves = ListOfEndMoves,
    nl,nl,write('||||||LIST OF MOVES COL,ROW|||||'),nl,write(ListOfMoves),nl. 

ballValidMoves(GameState, 'BlackBall', ListOfMoves):-
    ballStartValidMoves(GameState, 'Black', 4, 4, [], ListOfStartMoves),
    ballEndValidMovesWraper(GameState, 'Black', ListOfStartMoves, [], ListOfEndMoves),
    ListOfMoves = ListOfEndMoves,
    nl,nl,write('||||||LIST OF MOVES COL,ROW|||||'),nl,write(ListOfMoves),nl.   


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


%ballEndValidMovesWraper(+GameState, +Player, +ListOfStartMoves, +ListOfEndMoves, -NewListOfEndMoves)
ballEndValidMovesWraper(GameState, Player, [], ListOfEndMoves, NewListOfEndMoves):-
    NewListOfEndMoves = ListOfEndMoves.

ballEndValidMovesWraper(GameState, Player, [ [ColStart, RowStart] | ListOfStartMoves], ListOfEndMoves, NewListOfEndMoves):-
    ballEndValidMoves(GameState, Player, ColStart, RowStart, 4,4, ListOfEndMoves, IntermediaryListOfEndMoves),
    ballEndValidMovesWraper(GameState, Player, ListOfStartMoves, IntermediaryListOfEndMoves, NewListOfEndMoves).


%ballEndValidMoves(+GameState, +Player, +ColStart, +RowStart, +Col, +Row, +ListOfEndMoves, -NewListOfEndMoves) [Col,Row]
ballEndValidMoves(GameState, Player, ColStart, RowStart, 0, 0, ListOfEndMoves, NewListOfEndMoves):- 
    (Player = 'White' -> 
        isBallMoveEndValid(GameState,[ColStart, RowStart,0,0,whiteBall],Player,ValidEnd)
    ; 
        isBallMoveEndValid(GameState,[ColStart, RowStart,0,0,blackBall],Player,ValidEnd)
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
        isBallMoveEndValid(GameState,[ColStart, RowStart,Col,Row,whiteBall],Player,ValidEnd)
    ;
        isBallMoveEndValid(GameState,[ ColStart, RowStart,Col,Row,blackBall],Player,ValidEnd)
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

/**Check Win TO DO*/

%checkIfWin(+GameState,+Player,-HasWon)
checkIfWin(GameState,Player,HasWon):-
    nl,
    write('Checking if its a win'),
    getBoard(GameState,Board),
    areBallsOnOpositeBase(Board,Player,Bool),
    HasWon = Bool.

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




%isBallOfColorOnTop(+Stack,+Player,-Bool)
isBallOfColorOnTop([Head|_Tail],'White',Bool):-
    (Head = whiteBall -> Bool = 'True' ; Bool = 'False').

isBallOfColorOnTop([Head|_Tail],'Black',Bool):-
    (Head = blackBall -> Bool = 'True' ; Bool = 'False').

%arefirst3BoolsTrue(+Bool1,+Bool2,+Bool3,-Bool)
arefirst3BoolsTrue(Bool1,Bool2,Bool3,Bool):-
    Bool1 = 'True',
    Bool2 = 'True',
    Bool3 = 'True',
    Bool = 'True'.

arefirst3BoolsTrue(Bool1,Bool2,Bool3,Bool):-
    Bool = 'False'.


%getOpponentBaseStack(+Board,+Player,-Base1,-Base2,-Base3)
getOpponentBaseStack(Board,'White',Base1,Base2,Base3):-
    getValueInMapStackPosition(Board,0,3,Base1),
    getValueInMapStackPosition(Board,0,4,Base2),
    getValueInMapStackPosition(Board,1,4,Base3).
    

getOpponentBaseStack(Board,'Black',Base1,Base2,Base3):-
    getValueInMapStackPosition(Board,4,0,Base1),
    getValueInMapStackPosition(Board,4,1,Base2),
    getValueInMapStackPosition(Board,3,0,Base3).

%won(+WhoWon)
won('White'):-
    nl,
    write('White wins'),nl.

won('Black'):-
    nl,
    write('Black wins'),nl.



test(Num):- Nothing = 0.


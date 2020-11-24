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
isRingMoveValid([_Board, [[], _BlackPieces]],[-1,-1,ColIndexEnd,RowIndexEnd,Piece], 'White', Valid):-
    Valid = 'False',
    nl,write('You dont have rings left in your hand!').

isRingMoveValid([_Board, [_WhitePieces, []]],[-1,-1,ColIndexEnd,RowIndexEnd,Piece], 'Black', Valid):-
    Valid = 'False',
    nl,write('You dont have rings left in your hand!').

isRingMoveValid(GameState,[-1,-1,ColIndexEnd,RowIndexEnd,Piece], Player, Valid):-
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
    getBoard(GameState,Board),
    getPieces(GameState,AllPieces),
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[EndHeadValue|_TailValue]),
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
    ),
    (EndHeadValue = whiteBall -> 
        ValidEnd = 'False'
    ; 
        (EndHeadValue = blackBall -> 
            ValidEnd = 'False'
        ; 
            ValidEnd = 'True'
        ) 
    ),
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

%isBallMoveValid(+GameState,+Move,+Player,-Valid) %TODO
isBallMoveValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd,Piece],Player,Valid):-
    getBoard(GameState,Board),
    getPieces(GameState,AllPieces),
    getValueInMapStackPosition(Board,RowIndexEnd,ColIndexEnd,[EndHeadValue|_TailValue]),
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
    ),
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
    ),
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

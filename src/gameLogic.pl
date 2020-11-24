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
%Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd]

%player_move(+GameState,+Player,-NewGameState)
player_move(GameState,Player,NewGameState):-
    ringStep(GameState,Player,NewGameState).
    %TO DO ballStep

%ringStep(+GameState,+Player,-NewGameState)
ringStep(GameState,Player,NewGameState):-
    readRingMove(RingMove),
    handleRingMove(GameState,RingMove,Player,NewGameState).




/**Handle Move (for now not accurate) TO DO*/
%handleMove(+GameState,+Move,+Player,-NewGameState) TO DO
handleRingMove(GameState,[-1,-1,ColIndexEnd,RowIndexEnd], Player, NewGameState):-
    isRingMoveValid(GameState,[-1,-1,ColIndexEnd,RowIndexEnd], Player,Valid),
    (Valid = 'True' -> 
        move(GameState,[-1,-1,ColIndexEnd,RowIndexEnd], Player, NewGameState)
    ; 
        nl,write('You dont have rings left in your hand!'),
        nl,write('Select a ring on the board'),nl,
        ringStep(GameState,Player,NewGameState)
    ).

handleRingMove(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd], Player, NewGameState):-
    isRingMoveValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd], Player,Valid),
    (Valid = 'True' -> 
        move(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd], Player, NewGameState)
    ; 
        nl,write('Piece you choose to move is not a ring of your colour!'),
        nl,write('Be sure to select one'),nl,
        ringStep(GameState,Player,NewGameState)
    ).
/*
    removeValueFromMapUsingGameState([Board, AllPieces], RowIndexBegin, ColumnIndexBegin, [IntermediateBoard|IntermediatePieces], Removed),
    Player = 'White' ->
        Removed = 'WhiteRing' ->
            addValueInMap(IntermediateBoard, RowIndexEnd, ColIndexEnd, Removed, NewBoard),
            !
            ;
            player_move(GameState,Player,NewGameState). %deu borrada chama-se isto
*/

%isRingMoveValid(+GameState,+Move,+Player,-Valid)
%TO DO
isRingMoveValid([_Board, [[], _BlackPieces]],[-1,-1,ColIndexEnd,RowIndexEnd], 'White', Valid):-
    Valid = 'False'.

isRingMoveValid([_Board, [_WhitePieces, []]],[-1,-1,ColIndexEnd,RowIndexEnd], 'Black', Valid):-
    Valid = 'False'.

isRingMoveValid(GameState,[-1,-1,ColIndexEnd,RowIndexEnd], Player, Valid):-
    Valid = 'True'.


isRingMoveValid(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd], Player, Valid):-
    getBoard(GameState,Board),
    getPieces(GameState,AllPieces),
    getValueInMapStackPosition(Board,RowIndexBegin,ColIndexBegin,[HeadValue|_TailValue]),
    (Player = 'White' -> 
        (HeadValue = whiteRing -> 
            Valid = 'True'
        ; 
            Valid = 'False'
        ) 
    ; 
        (HeadValue = blackRing -> 
            Valid = 'True'
        ; 
            Valid = 'False'
        ) 
    ).




%move(+GameState, +Move, +Player ,-NewGameState)
move([Board, AllPieces],[-1,-1,ColIndexEnd,RowIndexEnd], 'White',NewGameState):-
    addValueInMap(Board, RowIndexEnd, ColIndexEnd, whiteRing, NewBoard),
    AllPieces = [[_Played|NewWhitePieces], BlackPieces],
    NewAllPieces = [NewWhitePieces, BlackPieces],
    NewGameState = [NewBoard, NewAllPieces].


move([Board, AllPieces],[-1,-1,ColIndexEnd,RowIndexEnd],'Black',NewGameState):-
    addValueInMap(Board, RowIndexEnd, ColIndexEnd, blackRing, NewBoard),
    AllPieces = [WhitePieces, [_Played|NewBlackPieces]],
    NewAllPieces = [WhitePieces, NewBlackPieces],
    NewGameState = [NewBoard, NewAllPieces].


move(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd], 'White',NewGameState):-
    removeValueFromMapUsingGameState(GameState, RowIndexBegin, ColIndexBegin, IntermediateGameState, Removed),
    getBoard(IntermediateGameState,IntermediateBoard),
    getPieces(IntermediateGameState,IntermediatePieces),
    addValueInMap(IntermediateBoard, RowIndexEnd, ColIndexEnd, whiteRing, NewBoard),
    NewGameState = [NewBoard|[IntermediatePieces]].

move(GameState,[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd], 'Black',NewGameState):-
    removeValueFromMapUsingGameState(GameState, RowIndexBegin, ColIndexBegin, IntermediateGameState, Removed),
    getBoard(IntermediateGameState,IntermediateBoard),
    getPieces(IntermediateGameState,IntermediatePieces),
    addValueInMap(IntermediateBoard, RowIndexEnd, ColIndexEnd, blackRing, NewBoard),
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

/**Start Game */
gameStart('Player','Player'):-
    write('Starting Player vs Player game...'),
    nl,
    initialMap(InitialMap),
   initializePieces(InitialMap,InitializedMap),
    write('Map has been initialized...'),
    nl,
    printMap(InitializedMap),
    gameLoop(InitializedMap,'Player','Player').

gameStart('Player','Com'):- %To Do
    write('Starting Player vs Com game...'),
    nl,
    initialMap(InitialMap),
    write('Initialized...'),
    nl,
    printMap(InitialMap).

gameStart('Com','Com'):- %To Do
    write('Starting Com vs Com game...'),
    nl,
    initialMap(InitialMap),
    write('Initialized...'),
    nl,
    printMap(InitialMap).

/**Initialize Map */
initializePieces(InitialMap,InitializedMap):-
    changeValueInMap(InitialMap,0,4,blackRing,InitialMap2),
    changeValueInMap(InitialMap2,0,3,blackRing,InitialMap3),
    changeValueInMap(InitialMap3,1,4,blackRing,InitialMap4),

    changeValueInMap(InitialMap4,4,0,whiteRing,InitialMap5),
    changeValueInMap(InitialMap5,3,0,whiteRing,InitialMap6),
    changeValueInMap(InitialMap6,4,1,whiteRing,InitializedMap).

/**Game Loop */
gameLoop(Map,'Player','Player'):-
    whiteMoves(Map),
    checkIfWin(Map,HasWon),
    (HasWon = 'None' ->  
        blackMoves(Map),
        checkIfWin(Map,HasWon2),
        (HasWon2 = 'None' ->
            gameLoop(Map,'Player','Player')
            ; 
            won(HasWon2)
        )
        ;
        won(HasWon)
    )
    .

/**Check Win*/
checkIfWin(Map,HasWon):- %Updates HasWon If Someone Wins
    nl,
    write('Checking if win'),
    read(Input),
    winInput(Input,HasWon).

winInput(0,HasWon):- HasWon='None'.
winInput(1,HasWon):- HasWon='B'.
winInput(2,HasWon):- HasWon='W'.

won('W'):-
    nl,
    write('White wins').

won('B'):-
    nl,
    write('Black wins').


/**Turn Move*/
whiteMoves(Map):-
    write('White moves...').

blackMoves(Map):-
    write('Black moves...').

handleMove(_Input).



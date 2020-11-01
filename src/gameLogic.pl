/**Start Game */
%gameStart(+TypeOfPlayer1, +TypeOfPlayer2)
gameStart('Player','Player'):-
    write('Starting Player vs Player game...'),
    nl,
    initial(InitialMap), %Gets initial game state
    display_game(InitialMap), %Displays game
    gameLoop(InitialMap,'Player','Player').

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

/**Game Loop*/
%gameLoop(-GameState, +TypeOfPlayer1, +TypeOfPlayer2)
gameLoop(Map,'Player','Player'):- %Each player has a turn in a loop
    whiteMoves(Map),
    checkIfWin(Map,HasWon),
    (HasWon = 'None' ->  
        blackMoves(Map),
        checkIfWin(Map,HasWon2),
        (HasWon2 = 'None' ->
            gameLoop(Map,'Player','Player') %Recursive call to continue to next player turns
            ; 
            won(HasWon2)
        )
        ;
        won(HasWon)
    )
    .

/**Check Win (for now not accurate)*/
%checkIfWin(+GameState, -HasWon)
checkIfWin(Map,HasWon):- %Updates HasWon If Someone Wins
    nl,
    write('Checking if win'),
    read(Input),
    winInput(Input,HasWon).

%winInput(+Input, -HasWon)
winInput(0,HasWon):- HasWon='None'.
winInput(1,HasWon):- HasWon='B'.
winInput(2,HasWon):- HasWon='W'.

%won(+WhoWon)
won('W'):-
    nl,
    write('White wins').

won('B'):-
    nl,
    write('Black wins').


/**Turn Move (for now not accurate)*/
%whiteMoves(-GameState)
whiteMoves(Map):-
    write('White moves...').

%blackMoves(-GameState)
blackMoves(Map):-
    write('Black moves...').

/**Handle Move (for now not accurate)*/
%handleMove(+Input)
handleMove(_Input).



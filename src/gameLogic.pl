gameStart('Player','Player'):-
    write('Starting Player vs Player game...'),
    nl,
    initialMap(InitialMap),
    write('Initialized...'),
    nl,
    printMap(InitialMap).

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

%addPieces(InitialMap):-

gameStart('Player','Player'):-
    write('Starting Player vs Player game...'),
    nl,
    initialMap(InitialMap),
   initializePieces(InitialMap,InitializedMap),
    write('Map has been initialized...'),
    nl,
    printMap(InitializedMap).

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

initializePieces(InitialMap,InitializedMap):-
    changeValueInMap(InitialMap,0,4,blackRing,InitialMap2),
    changeValueInMap(InitialMap2,0,3,blackRing,InitialMap3),
    changeValueInMap(InitialMap3,1,4,blackRing,InitialMap4),

    changeValueInMap(InitialMap4,4,0,whiteRing,InitialMap5),
    changeValueInMap(InitialMap5,3,0,whiteRing,InitialMap6),
    changeValueInMap(InitialMap6,4,1,whiteRing,InitializedMap).

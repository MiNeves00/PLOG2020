%generateFirstRow(+Length, -Row)
generateFirstRow(0, FirstRow).

generateFirstRow(Length, [H | T]) :-
    Length > 0,
    random(1, 9, H),
    Length1 is Length - 1,
    generateFirstRow(Length1, T).

%completeBoard(+OldRow, +Length, +Board, -NewBoard)
completeBoard(_, 1, Board, Board).

completeBoard(OldRow, Length, Board, NewBoard) :-
    Length > 1,
    completeRow(OldRow, Length, NewRow),
    Length1 is Length - 1,
    append(Board, [NewRow], IntermediateBoard),
    completeBoard(NewRow, Length1, IntermediateBoard, NewBoard).

%completeRow(+OldRow, +Length, -NewRow)
completeRow(_, 1, _).

completeRow([H1 | [H2 | T2]], Length, [Summed | NewT]) :-
    Length > 1,
    Summed is H1 + H2,
    Length1 is Length - 1,
    completeRow([H2 | T2], Length1, NewT).


/*
color(2,Var)
color(2,_18312)
color(4,Var)
color(Num,Var)
nth
 */

%createDatabaseColors(+Board, +Length)
createDatabaseColors(Board, Length):-
    flatten(Board, FlatList),
    sort(FlatList, SetList),
    length(SetList, N),
    rowDatabaseColors(SetList, N),
    printGeneratedColoursRow(SetList).

%rowDatabaseColors(+Row, +Length)
rowDatabaseColors(_, 0).
rowDatabaseColors([H | T], Length):-
    assert(colour(H, Var)),
    Length1 is Length - 1,
    rowDatabaseColors(T, Length1).


%makeNumbersSameColour(+Board, -ListOfPairs)
makeNumbersSameColour(Board, ListOfPairs):-
    flatten(Board, FlattenBoard),
    sort(FlattenBoard, DifferentNums),
    length(DifferentNums, Length),
    getListOfSameColourPairs(FlattenBoard, DifferentNums, Length, [], ListOfPairs).

%getListOfSameColourPairs(+FlattenBoard, +DifferentNums, +Length, +OldListOfPairs, -NewListOfPairs)
getListOfSameColourPairs(_, _, 0, ListOfPairs, ListOfPairs).

getListOfSameColourPairs(FlattenBoard, [DiffNum | Tail], Lenght, OldListOfPairs, NewListOfPairs):-
    Lenght > 0,
    Length1 is Lenght - 1,
    select(DiffNum, FlattenBoard, NewFlatten), 
    (member(DiffNum,NewFlatten) -> 
        getAllSameColourPairs(FlattenBoard, NewFlatten, DiffNum, -1, OldListOfPairs, IntermediateListOfPairs)
    ;
        IntermediateListOfPairs = OldListOfPairs
       
    ),
    getListOfSameColourPairs(FlattenBoard, Tail, Length1, IntermediateListOfPairs, NewListOfPairs).


%getAllSameColourPairs(+FlattenBoard, +NewFlatten, +DiffNum, +CarryNum, +OldListOfPairs, -NewListOfPairs)
getAllSameColourPairs(_, _, -1, _, NewListOfPairs, NewListOfPairs).

getAllSameColourPairs(FlattenBoard, NewFlatten, DiffNum, CarryNum, OldListOfPairs, NewListOfPairs):-

    getSameColourPair(FlattenBoard, NewFlatten, DiffNum, Index1, Index2),
    CarryNum1 is CarryNum + 1,
    ActualIndex1 is Index1 + CarryNum1,
    ActualIndex2 is Index2 + CarryNum1,
    append(OldListOfPairs, [ActualIndex1-ActualIndex2], IntermediateListOfPairs),
    select(DiffNum, NewFlatten, RestBoard),
    (member(DiffNum, RestBoard) ->
        getAllSameColourPairs(NewFlatten, RestBoard, DiffNum, CarryNum1, IntermediateListOfPairs, NewListOfPairs)
    ;
        getAllSameColourPairs(NewFlatten, RestBoard, -1, CarryNum1, IntermediateListOfPairs, NewListOfPairs)
    ).


%getSameColourPair(+FlattenBoard, +RestBoard, +DiffNum, -Index1, -Index2)
getSameColourPair(FlattenBoard, RestBoard, DiffNum, Index1, Index2):-
    indexOf(FlattenBoard, DiffNum, Index1),
    indexOf(RestBoard, DiffNum, InterIndex2),
    Index2 is InterIndex2 + 1.
    
    
%assignColoursToBoard(+FlatBoard, +ListOfPairs, +PairLen)
assignColoursToBoard(_, _, 0).

assignColoursToBoard(FlatBoard, [I1-I2 | Tail], PairLen):-
    PairLen > 0,
    PairLen1 is PairLen - 1,
    nth1F(I1, FlatBoard, Var1, _),
    nth1F(I2, FlatBoard, Var2, _),
    Var1 = Var2,
    assignColoursToBoard(FlatBoard, Tail, PairLen1).





%generateBoard(+Board, +Length, +IntermediateBoard, -NewBoard)
generateBoard(_, 0, NewBoard, NewBoard).

generateBoard([Row | Tail], Length, IntermediateBoard, NewBoard):-
    Length > 0,
    generateRow(Row, Length, [], NewRow),
    append(IntermediateBoard, [NewRow], NewIntermediateBoard),
    Length1 is Length - 1,
    generateBoard(Tail, Length1, NewIntermediateBoard, NewBoard).


%generateRow(+Row, +Length, -IntermediateRow, -NewRow)
generateRow(_, 0, NewRow ,NewRow).

generateRow([H | T], Length, IntermediateRow, NewRow):-
    Length > 0,
    append(IntermediateRow, [Var], NewIntermediateRow),
    Length1 is Length - 1,
    generateRow(T, Length1, NewIntermediateRow, NewRow).




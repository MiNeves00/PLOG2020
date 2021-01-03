generateFirstRow(0, FirstRow).

generateFirstRow(Length, [H | T]) :-
    Length > 0,
    random(1, 9, H),
    Length1 is Length - 1,
    generateFirstRow(Length1, T).


completeBoard(_, 1, Board, Board).

completeBoard(OldRow, Length, Board, NewBoard) :-
    Length > 1,
    completeRow(OldRow, Length, NewRow),
    Length1 is Length - 1,
    append(Board, [NewRow], IntermediateBoard),
    completeBoard(NewRow, Length1, IntermediateBoard, NewBoard).


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

        getSameColourPair(FlattenBoard, NewFlatten, DiffNum, Index1, Index2),
        append(OldListOfPairs, [Index1-Index2], IntermediateListOfPairs),
        select(DiffNum, NewFlatten, RestBoard),
        (member(DiffNum, RestBoard) ->

            getSameColourPair(NewFlatten, RestBoard, DiffNum, I1, I2),
            ActualI1 is I1 + 2,
            ActualI2 is I2 + 1,
            append(IntermediateListOfPairs, [Index2-ActualI2], NewIntermediateListOfPairs)
        ;
            NewIntermediateListOfPairs = IntermediateListOfPairs
        )
    ;
        NewIntermediateListOfPairs = OldListOfPairs
       
    ),
    getListOfSameColourPairs(FlattenBoard, Tail, Length1, NewIntermediateListOfPairs, NewListOfPairs).

%getSameColourPair(+FlattenBoard, +RestBoard, +DiffNum, -Index1, -Index2)
getSameColourPair(FlattenBoard, RestBoard, DiffNum, Index1, Index2):-
    indexOf(FlattenBoard, DiffNum, Index1),
    indexOf(RestBoard, DiffNum, InterIndex2),
    Index2 is InterIndex2 + 1.
    
    


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




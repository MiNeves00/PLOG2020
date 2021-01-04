/** generateFirstRow
    generates and returns a first row based on length and fills it with random numbers between 1 and 9
*/
%generateFirstRow(+Length, -Row)
generateFirstRow(0, FirstRow).

generateFirstRow(Length, [H | T]) :-
    Length > 0,
    getrand(Rand),
    setrand(Rand),
    random(1, 9, H),
    Length1 is Length - 1,
    generateFirstRow(Length1, T).

/** completeBoard
    completes the rest of the board after the first line is already filled,
    calls completeRow on each iteration of each row, iterates lenghts - 1 times since
    the first row is already defined
    returns this new board
*/
%completeBoard(+OldRow, +Length, +Board, -NewBoard)
completeBoard(_, 1, Board, Board).

completeBoard(OldRow, Length, Board, NewBoard) :-
    Length > 1,
    completeRow(OldRow, Length, NewRow),
    Length1 is Length - 1,
    append(Board, [NewRow], IntermediateBoard),
    completeBoard(NewRow, Length1, IntermediateBoard, NewBoard).

/** completeRow
    completes a row taking into account that 
    each position is the sum of the two elements above itself,
    iterates the length of the row - 1 times
*/
%completeRow(+OldRow, +Length, -NewRow)
completeRow(_, 1, _).

completeRow([H1 | [H2 | T2]], Length, [Summed | NewT]) :-
    Length > 1,
    Summed is H1 + H2,
    Length1 is Length - 1,
    completeRow([H2 | T2], Length1, NewT).

/** makeNumbersSameColour
    uses sort to get all diferent numbers in the board and then calls getListOfSameColourPairs,
    returns a list of pairs in the format [..., PosNum1-PosNum2, ...]
*/
%makeNumbersSameColour(+Board, -ListOfPairs)
makeNumbersSameColour(Board, ListOfPairs):-
    flatten(Board, FlattenBoard),
    sort(FlattenBoard, DifferentNums),
    length(DifferentNums, Length),
    getListOfSameColourPairs(FlattenBoard, DifferentNums, Length, [], ListOfPairs).

/** getListOfSameColourPairs
    iterates thourgh every different number and checks for each numbers if a equal number exists in the board,
    if it does it calls getAllSameColourPairs.
*/
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

/** getAllSameColourPairs
    when its called it is because there exists another number in the board equal to the one being analysed,
    so its function is to save their positions to the ListOfPairs, called NewListOfPairs, then it evaluates
    if theres still exists a number equal to the one being analysed which its position has yet to be saved it
    removes the number with the lowest index out of the two it saved before and then calls it self recursivly in order to
    save the positions.
*/
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

/** getSameColourPair
    uses the predicate indexOf in order to get the index of both equal numbers with the lowest index in the board
    and then returns them
*/
%getSameColourPair(+FlattenBoard, +RestBoard, +DiffNum, -Index1, -Index2)
getSameColourPair(FlattenBoard, RestBoard, DiffNum, Index1, Index2):-
    indexOf(FlattenBoard, DiffNum, Index1),
    indexOf(RestBoard, DiffNum, InterIndex2),
    Index2 is InterIndex2 + 1.
    
/** assignColoursToBoard
    using the list of pairs it iterates through the ListOfPairs and for each pair it finds the elements
    in their position and unifies them
*/
%assignColoursToBoard(+FlatBoard, +ListOfPairs, +PairLen)
assignColoursToBoard(_, _, 0).

assignColoursToBoard(FlatBoard, [I1-I2 | Tail], PairLen):-
    PairLen > 0,
    PairLen1 is PairLen - 1,
    nth1F(I1, FlatBoard, Var1, _),
    nth1F(I2, FlatBoard, Var2, _),
    Var1 = Var2,
    assignColoursToBoard(FlatBoard, Tail, PairLen1).




/** generateBoard
    generates a board based on a length with empty variables in it,
    calls generateRow each row
*/
%generateBoard(+Board, +Length, +IntermediateBoard, -NewBoard)
generateBoard(_, 0, NewBoard, NewBoard).

generateBoard([Row | Tail], Length, IntermediateBoard, NewBoard):-
    Length > 0,
    generateRow(Row, Length, [], NewRow),
    append(IntermediateBoard, [NewRow], NewIntermediateBoard),
    Length1 is Length - 1,
    generateBoard(Tail, Length1, NewIntermediateBoard, NewBoard).

/** generateRow
    fills each row with empty variables based on the length of itself
*/
%generateRow(+Row, +Length, -IntermediateRow, -NewRow)
generateRow(_, 0, NewRow ,NewRow).

generateRow([H | T], Length, IntermediateRow, NewRow):-
    Length > 0,
    append(IntermediateRow, [Var], NewIntermediateRow),
    Length1 is Length - 1,
    generateRow(T, Length1, NewIntermediateRow, NewRow).




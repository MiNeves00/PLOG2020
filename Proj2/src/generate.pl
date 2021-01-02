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
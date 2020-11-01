/**Change values in map*/
%changeValueInMap(+GameState1, +Row, +Column, +Value, -GameState2)
changeValueInMap([Head|Tail], 0, Column,Value, [HNew|Tail]) :-
        changeValueInList(Head, Column, Value, HNew).

changeValueInMap([Head|Tail], Row, Column, Value, [Head|TNew]) :-
        Row > 0,
        Row1 is Row - 1,
        changeValueInMap(Tail, Row1, Column, Value, TNew).

%changeValueInList(+List1, +Row, +Column, +Value, -List2)
changeValueInList([_Head|Tail], 0, Value, [Value|Tail]).

changeValueInList([Head|Tail], Index, Value, [Head|TNew]) :-
        Index > 0,
        Index1 is Index - 1,
        changeValueInList(Tail, Index1, Value, TNew).
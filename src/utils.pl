/**Add values in map*/
%addValueInMap(+Board, +Row, +Column, +Value, -NewBoard)
addValueInMap([Head|Tail], 0, Column,Value, [HNew|Tail]) :-
        addValueInList(Head, Column, Value, HNew).

addValueInMap([Head|Tail], Row, Column, Value, [Head|TNew]) :-
        Row > 0,
        Row1 is Row - 1,
        addValueInMap(Tail, Row1, Column, Value, TNew).

%addValueInList(+List1, +Index, +Value, -List2)
addValueInList([Head|Tail], 0, Value, [[Value|Head]|Tail]).

addValueInList([Head|Tail], Index, Value, [Head|TNew]) :-
        Index > 0,
        Index1 is Index - 1,
        addValueInList(Tail, Index1, Value, TNew).

/**Remove values from map*/
%removeValueFromMap(+Board, +Row, +Column, -NewBoard, -Removed)
removeValueFromMap([Head|Tail], 0, Column, [HNew|Tail], Removed) :-
        removeValueFromStackList(Head, Column, HNew, Removed).

removeValueFromMap([Head|Tail], Row, Column, [Head|TNew], Removed) :-
        Row > 0,
        Row1 is Row - 1,
        removeValueFromMap(Tail, Row1, Column, TNew, Removed).       

%removeValueFromStackList(+List1, +Index, -List2, -Removed)
removeValueFromStackList([[Removed|T]|Tail], 0, [T|Tail], Removed).

removeValueFromStackList([Head|Tail], Index, [Head|TNew], Removed) :-
        Index > 0,
        Index1 is Index - 1,
        removeValueFromStackList(Tail, Index1, TNew, Removed).
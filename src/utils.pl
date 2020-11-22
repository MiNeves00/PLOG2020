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





%getValueInMapStackPosition(+Board,+Row,+Col,-Value) #receives the row and col -1
getValueInMapStackPosition([Head|Tail],0,Col,Value):-
        getStackInListPosition(Head,Col,Value).


getValueInMapStackPosition([Head|Tail],Row,Col,Value):-
        Row > 0,
        Row1 is Row - 1,
        getValueInMapStackPosition(Tail,Row1,Col,Value).

%getStackInListPosition(+BoardRow,+Col,-Value)
getStackInListPosition([Head|Tail],0,Head).

getStackInListPosition([Head|Tail],Col,Value):-
        Col > 0,
        Col1 is Col -1,
        getStackInListPosition(Tail,Col1,Value).
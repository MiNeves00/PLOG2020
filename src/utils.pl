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
%removeValueFromMapUsingGameState(+GameState, +Row, +Column, -NewGameState, -Removed)
removeValueFromMapUsingGameState([Board|Pieces],Row,Col,[NewBoard|Pieces],Removed):-
        removeValueFromMap(Board,Row,Col,NewBoard,Removed).

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
        changeValueInList(Tail, Index1, Value, TNew).




/**Get Stack from map*/
%getValueInMapStackPosition(+Board,+Row,+Col,-Value)
getValueInMapStackPosition([Head|Tail],0,Col,Value):-
        getStackInListPosition(Head,Col,Value).


getValueInMapStackPosition([Head|Tail],Row,Col,Value):-
        Row > 0,
        Row1 is Row - 1,
        getValueInMapStackPosition(Tail,Row1,Col,Value).

%getStackInListPosition(+BoardRow,+Col,-Value)
getStackInListPosition([Head|Tail],0,Value) :-
        Value = Head.

getStackInListPosition([Head|Tail],Col,Value):-
        Col > 0,
        Col1 is Col -1,
        getStackInListPosition(Tail,Col1,Value).



/**Get Balls Of Player Colour*/
%getBallsPositions(+GameState,+Player,-BallPos1,-BallPos2,-BallPos3)
getBallsPositions([Board|Pieces],Player,BallPos1,BallPos2,BallPos3):-
    getBallsPositionsAux(Board,Player,BallPos1Row,BallPos1Col,4,4),
    Num1 is BallPos1Row-1,
    getBallsPositionsAux(Board,Player,BallPos2Row,BallPos2Col,Num1,BallPos1Col),
    Num2 is BallPos2Row-1,
    getBallsPositionsAux(Board,Player,BallPos3Row,BallPos3Col,Num2,BallPos2Col),
    BallPos1 = [BallPos1Row|BallPos1Col],
    BallPos2 = [BallPos2Row|BallPos2Col],
    BallPos3 = [BallPos3Row|BallPos3Col].
    



%getBallsPositionsAux(+Board,+Player,-BallRow1,-BallCol1,+Row,+Col)
getBallsPositionsAux(Board,Player,BallRow1,BallCol1,-1,-1):-
    getValueInMapStackPosition(Board,0,0,Stack),
    isBallOfColorOnTop(Stack,Player,Bool),
    (Bool = 'True' -> 
        BallRow1 = 0, BallCol1 = 0
    ;
        write('panic getting balls')
    ).

getBallsPositionsAux(Board,Player,BallRow1,BallCol1,-1,Col):-
    Col > -1, Col1 is Col-1,
    getBallsPositionsAux(Board,Player,BallRow1,BallCol1,4,Col1).

getBallsPositionsAux(Board,Player,BallRow1,BallCol1,Row,Col):-
    Row > -1, Row1 is Row-1,
    getValueInMapStackPosition(Board,Row,Col,Stack),
    isBallOfColorOnTop(Stack,Player,Bool),
    (Bool = 'True' -> 
        BallRow1 = Row, BallCol1 = Col
    ;
        getBallsPositionsAux(Board,Player,BallRow1,BallCol1,Row1,Col)
    ).

max_list([H|T], Max) :-
        max_list(T, H, Max).

max_list([], Max, Max).

max_list([H|T], Max0, Max) :-
        Max1 is max(H, Max0),
        max_list(T, Max1, Max).


nth0(0, [H|_], H).

nth0(Index, [H | List], Elem) :-
  Index > 0,
  NextIndex is Index - 1,
  nth0(NextIndex, List, Elem).


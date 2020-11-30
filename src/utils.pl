/**Add values in map*/
%addValueInMap(+Board, +Row, +Column, +Value, -NewBoard)
addValueInMap([Head|Tail], 0, Column,Value, [HNew|Tail]) :- %If Row is 0, already in the correct row, can call addValueInList
        addValueInList(Head, Column, Value, HNew).

addValueInMap([Head|Tail], Row, Column, Value, [Head|TNew]) :- %If Row > 0, move one row and call addValueInMap, until Row = 0
        Row > 0,
        Row1 is Row - 1,
        addValueInMap(Tail, Row1, Column, Value, TNew).

%addValueInList(+List1, +Index, +Value, -List2)
addValueInList([Head|Tail], 0, Value, [[Value|Head]|Tail]). %Adds value on top of existing stack (If Index is 0 can add directly)

addValueInList([Head|Tail], Index, Value, [Head|TNew]) :- %If Index > 0, move one spot and call addValueInList, until Index = 0
        Index > 0,
        Index1 is Index - 1,
        addValueInList(Tail, Index1, Value, TNew).

/**Remove values from map*/
%removeValueFromMapUsingGameState(+GameState, +Row, +Column, -NewGameState, -Removed) 
removeValueFromMapUsingGameState([Board|Pieces],Row,Col,[NewBoard|Pieces],Removed):- %Wrapper that allows to pass GameState
        removeValueFromMap(Board,Row,Col,NewBoard,Removed). %Board is retrieved and removeValueFromMap is called

%removeValueFromMap(+Board, +Row, +Column, -NewBoard, -Removed)
removeValueFromMap([Head|Tail], 0, Column, [HNew|Tail], Removed) :- %If Row is 0, already in the correct row, can call removeValueFromStackList
        removeValueFromStackList(Head, Column, HNew, Removed).

removeValueFromMap([Head|Tail], Row, Column, [Head|TNew], Removed) :- %If Row > 0, move one row and call removeValueFromMap, until Row = 0
        Row > 0,
        Row1 is Row - 1,
        removeValueFromMap(Tail, Row1, Column, TNew, Removed).       

%removeValueFromStackList(+List1, +Index, -List2, -Removed)
removeValueFromStackList([[Removed|T]|Tail], 0, [T|Tail], Removed). %Removes value from top of existing stack (If Index is 0 can remove directly), keeping Removed value

removeValueFromStackList([Head|Tail], Index, [Head|TNew], Removed) :- %If Index > 0, move one spot and call removeValueFromStackList, until Index = 0
        Index > 0,
        Index1 is Index - 1,
        removeValueFromStackList(Tail, Index1, TNew, Removed).
        changeValueInList(Tail, Index1, Value, TNew).




/**Get Stack from map*/
%getValueInMapStackPosition(+Board,+Row,+Col,-Value)
getValueInMapStackPosition([Head|Tail],0,Col,Value):- %If Row is 0, already in the correct row, can call getStackInListPosition
        getStackInListPosition(Head,Col,Value).


getValueInMapStackPosition([Head|Tail],Row,Col,Value):- %If Row > 0, move one row and call getValueInMapStackPosition, until Row = 0
        Row > 0,
        Row1 is Row - 1,
        getValueInMapStackPosition(Tail,Row1,Col,Value).

%getStackInListPosition(+BoardRow,+Col,-Value)
getStackInListPosition([Head|Tail],0,Value) :- %Gets stack on that space (If Col is 0, stack is Head of list)
        Value = Head.

getStackInListPosition([Head|Tail],Col,Value):- %If Col > 0, move one spot and call getStackInListPosition, until Col = 0
        Col > 0,
        Col1 is Col -1,
        getStackInListPosition(Tail,Col1,Value).



/**Get Balls Of Player Colour*/
/**Scans the board and gets positions of all of players balls*/
%getBallsPositions(+GameState,+Player,-BallPos1,-BallPos2,-BallPos3)
getBallsPositions([Board|Pieces],Player,BallPos1,BallPos2,BallPos3):-
    getBallsPositionsAux(Board,Player,BallPos1Row,BallPos1Col,4,4), %Auxiliary function will actually retirieve one ball
    Num1 is BallPos1Row-1, %Start after the first ball position
    getBallsPositionsAux(Board,Player,BallPos2Row,BallPos2Col,Num1,BallPos1Col), %Search for second ball
    Num2 is BallPos2Row-1, %Start after the second ball position
    getBallsPositionsAux(Board,Player,BallPos3Row,BallPos3Col,Num2,BallPos2Col), %Search for third ball
    BallPos1 = [BallPos1Row|BallPos1Col], %Set balls positions to correct variables
    BallPos2 = [BallPos2Row|BallPos2Col],
    BallPos3 = [BallPos3Row|BallPos3Col].
    



%getBallsPositionsAux(+Board,+Player,-BallRow1,-BallCol1,+Row,+Col)
getBallsPositionsAux(Board,Player,BallRow1,BallCol1,-1,-1):- %If Row is -1 and COl is -1, it has scanned all positions on the board
    getValueInMapStackPosition(Board,0,0,Stack), %Checks if ball is at (0, 0)
    isBallOfColorOnTop(Stack,Player,Bool),
    (Bool = 'True' -> 
        BallRow1 = 0, BallCol1 = 0 %If true, assigns position of ball as (0, 0)
    ;
        write('panic getting balls') %If not, somethings wrong
    ).

getBallsPositionsAux(Board,Player,BallRow1,BallCol1,-1,Col):- %If Row is -1, it has scanned all rows for that column
    Col > -1, Col1 is Col-1, %Move one column
    getBallsPositionsAux(Board,Player,BallRow1,BallCol1,4,Col1). %Scan again from the top (Row = 4)

getBallsPositionsAux(Board,Player,BallRow1,BallCol1,Row,Col):-
    Row > -1, Row1 is Row-1, %Decrements Row
    getValueInMapStackPosition(Board,Row,Col,Stack), %Gets Stack on that position
    isBallOfColorOnTop(Stack,Player,Bool), %Checks if ball is on top
    (Bool = 'True' -> 
        BallRow1 = Row, BallCol1 = Col %If true, assigns ball position to correct variables
    ;
        getBallsPositionsAux(Board,Player,BallRow1,BallCol1,Row1,Col) %If not, scans again in next position (Row1 is Row-1)
    ).

/**Max in List*/
/**Gets Maximum Value in List*/
max_list([H|T], Max) :-
        max_list(T, H, Max).

max_list([], Max, Max).

max_list([H|T], Max0, Max) :-
        Max1 is max(H, Max0),
        max_list(T, Max1, Max).

/**Min in List*/
/**Gets Minimum Value in List*/
min_list([H|T], Min) :-
        min_list(T, H, Min).

min_list([], Min, Min).

min_list([H|T], Min0, Min) :-
        Min1 is min(H, Min0),
        min_list(T, Min1, Min).

/**Nth in List*/
/**Gets Nth Value in List*/
nth0(0, [H|_], H).

nth0(Index, [H | List], Elem) :-
  Index > 0,
  NextIndex is Index - 1,
  nth0(NextIndex, List, Elem).

/**IndexOf in List*/
/**Gest Index of Value in List*/
indexOf([Element|_], Element, 0):- !.
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1),
  !,
  Index is Index1+1.

/**reverse List*/
reverseL([],Z,Z).

reverseL([H|T],Z,Acc) :- reverseL(T,Z,[H|Acc]).


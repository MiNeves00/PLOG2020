/** printState
    Prints a state given the state as a list of lists
    Uses printRow to print each row
*/
%printState(-List, -Length, -N)
printState([],Length,Length).

printState([H|T],Length,N):-
    write(' | '),
    N1 is N + 1,
    printRow(H), %Imprime a linha do tabuleiro
    write('\n\n'),
    writeTabs(N1),
    printState(T,Length,N1).
    
%printRow(-List)
printRow([]).

printRow([Head|Tail]) :-
    write(Head), %Escreve sempre a cabeca da lista
    write(' | '),
    printRow(Tail).

/** printStateList
    Prints a state given the state as a single list
    Uses printStateListRow to print each row
*/
%printStateList(-List, -Length, -OldLength, -Index)
printStateList(_, 0, _, _).

printStateList(_, _, _,1) :-
    fail.

printStateList(List, Length, OldLength, Index) :-
    write(' | '),
    printStateListRow(List, Length, Index),
    write('\n\n'),
    Row is OldLength + 1 - Length,
    writeTabs(Row),
    Length1 is Length - 1,
    Index1 is Index + Length,
    printStateList(List, Length1, OldLength, Index1).

%printStateListRow(-List, -Length, -Index)
printStateListRow(List, 0, _).

printStateListRow(List, Length, Index) :-
    nth_membro(Index,List,Item),
    write(Item),
    write(' | '),
    Index1 is Index + 1,
    Length1 is Length - 1,
    printStateListRow(List, Length1, Index1).

/** printGeneratedBoard
    Prints a generated board given the board as a single list 
    Uses printGeneratedRow to print each row
*/
%printGeneratedBoard(-List, -Length, -N)
printGeneratedBoard([],Length,Length).

printGeneratedBoard([H|T],Length,N):-
    write(' | '),
    N1 is N + 1,
    printGeneratedRow(H), %Imprime a linha do tabuleiro
    write('\n\n'),
    writeTabs(N1),
    printGeneratedBoard(T,Length,N1).
    
%printGeneratedRow(-List)
printGeneratedRow([]).

printGeneratedRow([Head|Tail]) :-
    (Head < 10 ->
        write('  '),
        write(Head),
        write('  ')
    ;
        (Head < 100 ->
            write(' '),
            write(Head),
            write('  ')
        ;
            (Head < 1000 ->
                write(' '),
                write(Head),
                write(' ')
            ;
                write(Head),
                write(' ')
            )
        ) 
    ),
    write(' | '),
    printGeneratedRow(Tail).  

/** printSolution
    Prints a solution given the solution as a single list
    Uses printSolutionRow to print each row
*/
%printSolution(-Solution, -Length, -OldLength, -Index)
printSolution(_, 0, _, _).

printSolution(_, _, _,1) :-
    fail.

printSolution(Solution, Length, OldLength, Index) :-
    write(' | '),
    printSolutionRow(Solution, Length, Index),
    write('\n\n'),
    Row is OldLength + 1 - Length,
    writeTabs(Row),
    Length1 is Length - 1,
    Index1 is Index + Length,
    printSolution(Solution, Length1, OldLength, Index1).

%printSolutionRow(-Solution, -Length, -Index)
printSolutionRow(Solution, 0, _).

printSolutionRow(Solution, Length, Index) :-
    nth_membro(Index,Solution,Item),
    (Item < 10 ->
        write('  '),
        write(Item),
        write('  ')
    ;
        (Item < 100 ->
            write(' '),
            write(Item),
            write('  ')
        ;
            (Item < 1000 ->
                write(' '),
                write(Item),
                write(' ')
            ;
                write(Item),
                write(' ')
            )
        ) 
    ),
    write(' | '),
    Index1 is Index + 1,
    Length1 is Length - 1,
    printSolutionRow(Solution, Length1, Index1).
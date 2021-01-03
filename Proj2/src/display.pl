state1(
    [ %1%2%3%4
      [A,B,B,C],%4
      [D,A,E],  %3
      [C,F],    %2
      [G]       %1 
    
    ]
).

statelist1([A,B,B,C,D,A,E,C,F,G]).

state2(
    [ %1%2%3%4%5
      [A,A,B,C,D],%5
      [B,E,F,G],  %4
      [H,D,I],    %3
      [J,K],      %2
      [L]         %1 
    
    ]
).

statelist2([A,A,B,C,D,B,E,F,G,H,D,I,J,K,L]).

state3(
    [ %1%2%3%4%5
      [A,B,C,D,E],%5
      [F,G,H,F],  %4
      [I,J,K],    %3
      [L,M],      %2
      [N]         %1 
    
    ]
).

state4(
    [ %1%2%3%4%5
      [2,2,1,1,1],%5
      [4,3,2,2],  %4
      [7,5,4],    %3
      [12,9],     %2
      [21]        %1 
    
    ]
).

state5(
    [ %1%2%3%4%5
      [2,2,1,1,1],%5
      [4,3,2,2],  %4
      [7,1,4],    %3
      [12,9],     %2
      [4]        %1 
    
    ]
).

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

%printGeneratedColoursBoard(-List, -Length, -N)
printGeneratedColoursBoard([],Length,Length).

printGeneratedColoursBoard([H|T],Length,N):-
    write(' | '),
    N1 is N + 1,
    printGeneratedColoursRow(H), %Imprime a linha do tabuleiro
    write('\n\n'),
    writeTabs(N1),
    printGeneratedColoursBoard(T,Length,N1).



%printGeneratedColoursRow(-List)
printGeneratedColoursRow([]).

printGeneratedColoursRow([Head|Tail]) :-
    (Head < 10 ->
        write('  '),
        colour(Head,Var),
        write(Var),
        write('  ')
    ;
        (Head < 100 ->
            write(' '),
            colour(Head,Var),
            write(Var),
            write('  ')
        ;
            (Head < 1000 ->
                write(' '),
                colour(Head,Var),
                write(Var),
                write(' ')
            ;
                colour(Head,Var),
                write(Var),
                write(' ')
            )
        ) 
    ),
    write(' | '),
    printGeneratedColoursRow(Tail).    
  

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
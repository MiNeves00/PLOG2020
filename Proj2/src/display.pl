state1(
    [ %1%2%3%4
      [A,B,B,C],%4
      [D,A,E],  %3
      [C,F],    %2
      [G]       %1 
    
    ]
).

state2(
    [ %1%2%3%4%5
      [A,A,B,C,D],%5
      [B,E,F,G],  %4
      [H,D,I],    %3
      [J,K],      %2
      [L]         %1 
    
    ]
).

state3(
    [ %1%2%3%4%5
      [A,B,C,D,E],%5
      [F,G,H,F],  %4
      [I,J,K],    %3
      [L,M],      %2
      [N]         %1 
    
    ]
).

%printState(-List, -Length, -N)
printState([],Length,Length).

printState([H|T],Length,N):-
    write('    '),
    write('   |  '),
    N1 is N + 1,
    printRow(H), %Imprime a linha do tabuleiro
    write('\n-------|-------|-------|-------|-------|-------|\n'),
    printState(T,Length,N1).
    
%printRow(-List)
printRow([]).

printRow([Head|Tail]) :-
    write(Head), %Escreve sempre a cabeca da lista
    write(' | '),
    printRow(Tail).

%printSolution(-Solution, -Length, -Index)
printSolution(_, 0, _).

printSolution(_, _, 1) :-
    write('| '),
    fail.

printSolution(Solution, Length, Index) :-
    printSolutionRow(Solution, Length, Index),
    write('\n\n'),
    Row is 6 - Length,
    writeTabs(Row),
    write('| '),
    Length1 is Length - 1,
    Index1 is Index + Length,
    printSolution(Solution, Length1, Index1).

%printSolutionRow(-Solution, -Length, -Index)
printSolutionRow(Solution, 0, _).

printSolutionRow(Solution, Length, Index) :-
    nth_membro(Index,Solution,Item),
    write(Item),
    write(' | '),
    Index1 is Index + 1,
    Length1 is Length - 1,
    printSolutionRow(Solution, Length1, Index1).
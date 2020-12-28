state(
    [ %1%2%3%4
      [A,B,B,C],%4
      [D,A,E],  %3
      [C,F],    %2
      [G]       %1 
    
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

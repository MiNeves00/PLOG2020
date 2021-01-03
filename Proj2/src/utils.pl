

%flatten2(-List, +FlatList)
flatten2([], []) :- !.
flatten2([L|Ls], FlatL) :-
    !,
    flatten2(L, NewL),
    flatten2(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten2(L, [L]).


flatten(List, FlatList) :-
      flatten(List, [], FlatList0),
      !,
      FlatList = FlatList0.
  
  flatten(Var, Tl, [Var|Tl]) :-
      var(Var),
      !.
  flatten([], Tl, Tl) :- !.
  flatten([Hd|Tl], Tail, List) :-
      !,
      flatten(Hd, FlatHeadTail, List),
     flatten(Tl, Tail, FlatHeadTail).
  flatten(NonList, Tl, [NonList|Tl]).


getLength([FirstRow|T],Length):-
    length(FirstRow,Length).

nth_membro(1,[M|_],M).

nth_membro(N,[_|T],M):-
    N>1,
    N1 is N-1,
    nth_membro(N1,T,M).

writeTabs(0).

writeTabs(Length) :-
    write('    '),
    Length1 is Length-1,
    writeTabs(Length1).




indexOf([Element|_], Element, 1). % We found the element

indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1), % Check in the tail of the list
  Index is Index1+1.  % and increment the resulting index


% Case 1: Index not specified
nth1R(Index, In, Element, Rest) :-
    var(Index), !,
    generate_nth(1, Index, In, Element, Rest).
% Case 2: Index is specified
nth1F(Index, In, Element, Rest) :-
    integer(Index), Index > 0,
    find_nth1(Index, In, Element, Rest).

generate_nth(I, I, [Head|Rest], Head, Rest).
generate_nth(I, IN, [H|List], El, [H|Rest]) :-
    I1 is I+1,
    generate_nth(I1, IN, List, El, Rest).

find_nth1(1, [Head|Rest], Head, Rest) :- !.
find_nth1(N, [Head|Rest0], Elem, [Head|Rest]) :-
    M is N-1,
    find_nth1(M, Rest0, Elem, Rest).


/*
select(X, [Head|Tail], Rest) :-
    select3_(Tail, Head, X, Rest).
  
select3_(Tail, Head, Head, Tail).

select3_([Head2|Tail], Head, X, [Head|Rest]) :-
    select3_(Tail, Head2, X, Rest).
*/
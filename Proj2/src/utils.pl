

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
    write('  '),
    Length1 is Length-1,
    writeTabs(Length1).

write2Tabs(0).

write2Tabs(Length) :-
    write('    '),
    Length1 is Length-1,
    write2Tabs(Length1).
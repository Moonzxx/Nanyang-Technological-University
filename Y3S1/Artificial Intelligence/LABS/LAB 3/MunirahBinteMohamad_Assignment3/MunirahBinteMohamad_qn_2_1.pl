%Facts given
offspring(prince, charles).
offspring(princess, ann).
offspring(prince, andrew).
offspring(prince, edward).

older(charles, ann).
older(ann, andrew).
older(andrew, edward).

male(A):- offspring(prince,A).
female(A):- offspring(princess,A).

%RULES

%How it is being Ordered, based on age
isOlder(X, Y):- older(X, Y).
isOlder(A, B):- older(A, X),isOlder(X, B).

%How it is being Ordered, abased on gender
inOrder(X, Y) :- offspring(prince, X), offspring(princess, Y).
inOrder(X, Y) :- offspring(prince, X), offspring(prince, Y), isOlder(X, Y).
inOrder(X, Y) :- offspring(princess, X), offspring(princess, Y), isOlder(X, Y).

%Insertion Sort on A
successors(X, Y) :- insertSort(X, [], Y).
insertSort([], OldList, OldList).
insertSort([H|T], OldList, Y) :- insertion(H, OldList, NewList), insertSort(T, NewList, Y).

% How it is inserted (Can change insertion factor (By age or gender) )
insertion(X, [], [X]).
insertion(X, [Y|T], [X, Y|T]) :- inOrder(X, Y).
insertion(X, [Y|T], [Y|NewT]) :- not(inOrder(X, Y)), insertion(X, T, NewT).

succession(SuccessionList):-
    findall(Y,offspring(_,Y),OffspringList),successors(OffspringList,SuccessionList).

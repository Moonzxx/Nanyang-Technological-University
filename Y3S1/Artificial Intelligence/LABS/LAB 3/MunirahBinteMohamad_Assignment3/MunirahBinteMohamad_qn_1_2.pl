%Facts given
company(sumsum).
company(appy).
smartPhoneTech(galacticaS3).
developed(galacticaS3, sumsum).
boss(stevey).
competitor(sumsum,appy).
steal(stevey, galacticaS3).

%Rules
business(Tech):-smartPhoneTech(Tech).
rival(Comp):- competitor(Comp, appy); competitor(appy, Comp).

%Run Program
unethical(X):-
    boss(X), steal(X, Biz), business(Biz), developed(Biz,CompA), rival(CompA).

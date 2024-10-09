% relaciones
parent(pedro, sebastian).
parent(pedro, andres).
sibling(pedro, carlos).
cousin(pedro, felipe).

parent(mario, luis).       
grandparent(jorge, mario). 
grandparent(ana, mario).   
uncle(raul, mario).       
uncle(mateo, mario).      
uncle(pablo, mario).      

parent(juanita, laura).
sibling(juanita, santiago).
sibling(juanita, diego).
cousin(juanita, tomas).
cousin(juanita, javier).

% consanguinidad
levelConsanguinity(X, Y, 1) :- parent(X, Y).
levelConsanguinity(X, Y, 2) :- sibling(X, Y).
levelConsanguinity(X, Y, 2) :- grandparent(X, Y).
levelConsanguinity(X, Y, 3) :- uncle(X, Y).
levelConsanguinity(X, Y, 3) :- cousin(X, Y).

% distribucion herencia

distributeInheritance(Inheritance, Herederos, Percentages, Distribution) :-
    maplist(calculatePortion(Inheritance), Herederos, Percentages, BaseDistribution),

    sum_list(Percentages, TotalPercentage),

    RemainingPercentage is 100 - TotalPercentage,
    length(Herederos, N),
    (RemainingPercentage > 0 ->
        ExtraPercent is RemainingPercentage / N,
        maplist(addExtraPortion(Inheritance, ExtraPercent), BaseDistribution, Distribution)
    ;
        Distribution = BaseDistribution
    ).

calculatePortion(Inheritance, Heredero, Percent, Heredero-Portion) :-
    Portion is Inheritance * (Percent / 100).

addExtraPortion(Inheritance, ExtraPercent, Heredero-Portion, Heredero-NewPortion) :-
    ExtraPortion is Inheritance * (ExtraPercent / 100),
    NewPortion is Portion + ExtraPortion.


% Caso 1: Herencia de $100,000 con 2 hijos (Sebastián, Andrés), 1 hermano (Carlos), 1 primo (Felipe)
caso1 :-
    Herederos = [sebastian, andres, carlos, felipe],
    Percentages = [30, 30, 20, 10],  % 30% para cada hijo, 20% para el hermano, 10% para el primo
    distributeInheritance(100000, Herederos, Percentages, Distribution),
    writeln(Distribution).

% Caso 2: Herencia de $250,000 con 1 hijo (Luis), 2 abuelos (Jorge, Ana), 3 tíos (Raúl, Mateo, Pablo)
caso2 :-
    Herederos = [luis, jorge, ana, raul, mateo, pablo],
    Percentages = [30, 20, 20, 10, 10, 10],  % Distribución según niveles de consanguinidad
    distributeInheritance(250000, Herederos, Percentages, Distribution),
    writeln(Distribution).

% Caso 3: Herencia de $150,000 con 1 hija (Laura), 2 hermanos (Santiago, Diego), 2 primos (Tomás, Javier)
caso3 :-
    Herederos = [laura, santiago, diego, tomas, javier],
    Percentages = [30, 20, 20, 10, 10],  % 30% para la hija, 20% para cada hermano, 10% para cada primo
    distributeInheritance(150000, Herederos, Percentages, Distribution),
    writeln(Distribution).

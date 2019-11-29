%split query and populate Parameters and Values
%the values are defined in weatherValueTable
processQuery(Query,Parameters,Values):-
   parseSubject(Query, PS1, Parameters),
   getWeatherValue(PS1, W1, Parameters),
   parseSubject(W1, PS3, Values),
   getWeatherValue(PS3, Tem, Values).

%remove the subject
%subject values are predefined
parseSubject(PS0,PS2,Parameter) :-
  subject(PS0,PS1,Parameter),
  parseSubject(PS1,PS2,Parameter).
parseSubject(P,P,_).

%assin weather values
%values are in weatherValueTable
getWeatherValue(PS0,PS2,Parameter) :-
    weatherValue(PS0,PS1,Parameter),
    getWeatherValue(PS1,PS2,Parameter).
getWeatherValue(P,P,_).

subject(['I'| P],P,_).
subject([want| P],P,_).
subject([to| P],P,_).
subject([go| P],P,_).
subject([where| P],P,_).
subject([weather| P],P,_).
subject([is| P],P,_).

weatherValue([H1 | T], T, Temp) :- weatherValueTable(H1, Temp).
weatherValueTable(temperature, temp).
weatherValueTable(rainfall, rain).
weatherValueTable(windspeed, wind).
weatherValueTable(hot, 273).
weatherValueTable(medium, 100).
weatherValueTable(high, 100).
weatherValueTable(slow, 100).















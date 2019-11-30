:- [weatherPredictor].
:- [nlpQueries].

%this is the entry point for program
%to excute type main_fn().
%the valid parameters should match from below response
/*
{
"id": 6090785,
"name": "North Vancouver",
"coord": {
"lat": 49.32,
"lon": -123.07
},
"main": {
"temp": 274.82,(in Kelvin)
"pressure": 1014,(in HectoPascals/HPa)
"humidity": 59,(in % percentage)
"temp_min": 273.15,
"temp_max": 276.48
},
"dt": 1574993347,
"wind": {
"speed": 3.6,
"deg": 300
},
"sys": {
"country": "CA"
},
"rain": null,
"snow": null,
"clouds": {
"all": 5
},
"weather": [
{
"id": 800,
"main": "Clear",
"description": "clear sky",
"icon": "01n"
}
]
}*/
main_fn() :-
    write("Please select a near by location to predict weather conditions"),
    nl,
    read(Location),
    write("Enter string value parameter to filter, like [temp,pressure] "),
    read(Parameters),
    length(Parameters,ParametersL),
    split(Parameters,P),
    write("Enter expected value of parameter +- 2 like [250,34]"),
    read(Values),
    split(Values,V),
    PL is ParametersL-1,
    result_geocode(Location,P,V,PL).

 /*
 These are the sample question that can be queried
['I',want, to, go, to , weather, where, temperature, is, hot].
['I',want, to, go, to , weather, where, temperature, is, medium].
['I',want, to, go, to , weather, where, rainfall, is, high].
['I',want, to, go, where, windspeed, is, slow].
In general any parameter from above JSON main_fn() can be considerd with high low moderate*/
main_nlp_fn() :-
    write("Please select a near by location to predict weather conditions"),
    nl,
    read(Location),
    write("Enter query."),
    read(Query),
    processQuery(Query,Parameters,Values),
    number(Values),
    split([Parameters],P),
    split([Values],V),
   % write('values'),
   % nl,
   % write(P),
   % nl,
   % write(V),
    result_geocode(Location,P,V,0).

%split comma separated values into array
split(L,Result) :-
    splitacc(L, [], Result).
    splitacc([], Acc, Result) :-
    Result=Acc.

%helper for split
splitacc([H|T], Acc, Result) :-
    append(Acc, [[H]], NewAcc),
    splitacc(T, NewAcc, Result).

















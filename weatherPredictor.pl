%this file has a dependency on http module to
%get JSON data from various API

:- use_module(library(http/json)).
:- use_module(library(http/http_open)).
:- use_module(library(clpfd)).
:- use_module(library(apply)).
:- dynamic(known/2).

%Call various methods for given location and get
%final result
result_geocode(Location, Parameters, Values, PL) :- openGeoCoder(Data,Location),
    Response = Data.get('Response'),
    View = Response.get('View'),
    nth0(0, View, FirstView),
    Result = FirstView.get('Result'),
    nth0(0, Result, FirstResult),
    nl,
    PointLocation = FirstResult.get('Location'),
    DisplayPosition = PointLocation.get('DisplayPosition'),
    Lat = DisplayPosition.get('Latitude'),
    Lon = DisplayPosition.get('Longitude'),
    result_coder(Lat, Lon, Parameters, Values, PL).

%from location get lattitude and longitudes
openGeoCoder(Data, Location) :-
    Url_Start = "https://geocoder.api.here.com/6.2/geocode.json?app_id=W5Xg9ORY6hBSX1duzPmA&app_code=2VnalmJE6DVdLhahnV2_TA&searchtext=",
    string_concat(Url_Start, Location, URL),
    setup_call_cleanup(
    http_open(URL, In, [request_header('Accept'='application/json')]),
    json_read_dict(In, Data),
    close(In)
    ).

% this is main part of program, here opwn weather API is called &lon=
% indicates longitudes lat= indicates lattitude cnt indicates number of
% cities around coordinates Note: Because of free version of API number
% of cities are limited
openWeatherMap(Data,Lat,Lon) :-
    Url_Start = "http://api.openweathermap.org/data/2.5/find?lat=",
    Lat_lon_separator = "&lon=",
    Query_type = "&cnt=",
    Url_End = "&format=json&APPID=ddcc2026eccbf62555b984013be99d6f",
    string_concat(Url_Start, Lat, Url_1),
    string_concat(Url_1, Lat_lon_separator, Url_2),
    string_concat(Url_2, Lon, Url_3),
    string_concat(Url_3, Query_type, Url_4),
    string_concat(Url_4, 1, Url_5),
    string_concat(Url_5, Url_End, URL),
    write(URL),
    http_open(URL, In, [request_header('Accept'='application/json')]),
    json_read_dict(In, Data),
    close(In).

%process JSOn received from API
%JSON has cities and weather conditions
result_coder(Lat, Lon, Parameters, Values,PL) :-
    openWeatherMap(Data, Lat, Lon),
    N= Data.get('count'),
    List = Data.get('list'),
    %length(List,Len),
    %format(Len),
    E is N-1,E>=0,
    %write(E),nl,
    result_helper(List, Lat, Lon,Parameters, Values,E,PL).

decr(X,NX) :-
    NX is X-1.

%go throgh JSOn cities to apply given creteria
%at end the result is the cities that match given parameters
result_helper(_,_,_,_,-1,-1):-format("Sorry, give other coordinates!").
result_helper(List, Lat, Lon, Parameters, Values, E, PL):-
    nth0(E,List,FirstList),
    decr(E,A),
    A>= -1,
    display_with_filters(FirstList,Parameters, Values, PL),
    result_helper(List, Lat, Lon, Parameters, Values, A, PL);
    true.

%final result display
display_with_filters(FirstList, Parameters, Values, PL):-
    Name = FirstList.get('name'),
    check_filters(FirstList,Parameters, Values, PL),
    write('---------------'),
    nl,
    write(Name),
    nl,
    write(FirstList);
    true.

%verify conditions
check_filters(FirstList,Parameters,Values,PL ):-
    ( PL >= 0 ->
    PointMain = FirstList.get('main'),
    nth0(PL,Parameters,X0),
    nth0(PL,Values,V0),
    nth0(0,X0,X1),
    nth0(0,V0,V1),
      ( PointMain.get(X1) >= (V1-2) -> true; false ),
      ( PointMain.get(X1) <  (V1+2) -> true;false  ),
      decr(PL,Z),
      check_filters(FirstList,Parameters, Values,Z)
       ; (PL == -1 -> true; false)).





































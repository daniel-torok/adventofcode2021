-module(solution).
-export([main/0]).

mapi(F, E) -> i_mapi(F, E, 1).
i_mapi(_, [], _) -> [];
i_mapi(F, [H|T], Index) -> [F(H,Index)|i_mapi(F,T,Index+1)].

pow(_, 0) -> 1;
pow(Num, 1) -> Num;
pow(Num, E) -> Num * pow(Num, E-1).

bin2dec([]) -> 0;
bin2dec([$#|Tail]) -> pow(2, length(Tail)) + bin2dec(Tail);
bin2dec([$.|Tail]) -> bin2dec(Tail).

readline(FileName) ->
  [First | _] = readlines(FileName),
  First.

readlines(FileName) ->
  {ok, Data} = file:read_file(FileName),
  string:tokens(erlang:binary_to_list(Data), "\n").

newbound($.) -> $#;
newbound($#) -> $..

parselitpixs(Lines) ->
  Concat = lists:flatten(mapi(
    fun (Row, I) ->
      mapi(fun (Col, J) -> { {J, I}, Col } end, Row)
    end, Lines)),
  Filtered = lists:filter(fun ({_, V}) -> V =:= $# end, Concat),
  maps:from_list(Filtered).

bounds(Pixs) ->
  Keys = maps:keys(Pixs),
  XS = lists:map(fun ({X,_}) -> X end, Keys),
  YS = lists:map(fun ({_,Y}) -> Y end, Keys),
  MinX = lists:min(XS),
  MaxX = lists:max(XS),
  MinY = lists:min(YS),
  MaxY = lists:max(YS),
  { MinX, MaxX, MinY, MaxY }.

inbounds({X, Y}, { MinX, MaxX, MinY, MaxY }) ->
  (X >= MinX) and (X =< MaxX) and (Y >= MinY) and (Y =< MaxY).

extract(Algo, LitPixs, Bounds, Bound, Neighbours) ->
  Bin = lists:map(
    fun (Coord) ->
      case inbounds(Coord, Bounds) of
        true -> maps:get(Coord, LitPixs, $.);
        false -> Bound
      end
    end, Neighbours),
  lists:nth(bin2dec(Bin) + 1, Algo).

step(Algo, LitPixs, Bound) ->
  Bounds = bounds(LitPixs),
  { MinX, MaxX, MinY, MaxY } = Bounds,
  Indices = [ { X, Y } || Y <- lists:seq(MinY - 1, MaxY + 1), X <- lists:seq(MinX - 1, MaxX + 1) ],
  ExtractCoords = lists:map(fun ({X, Y}) -> {{X,Y}, [{X+DX,Y+DY} || DY <- [-1,0,1], DX <- [-1,0,1]]} end, Indices),
  NewLitPixs = lists:map(fun ({Coord, Neighbours}) -> {Coord, extract(Algo, LitPixs, Bounds, Bound, Neighbours)} end, ExtractCoords),
  Filtered = lists:filter(fun ({_, V}) -> V =:= $# end, NewLitPixs),
  maps:from_list(Filtered).

iter(_, LitPixs, _, 0) -> LitPixs;
iter(Algo, LitPixs, Bound, Count) -> iter(Algo, step(Algo, LitPixs, Bound), newbound(Bound), Count - 1).

main() ->
  Algo = readline("algo.data"),
  LitPixs = parselitpixs(readlines("image.data")),
  io:format("Part one: ~p~n", [maps:size(iter(Algo, LitPixs, $., 2))]),
  io:format("Part one: ~p~n", [maps:size(iter(Algo, LitPixs, $., 50))]).

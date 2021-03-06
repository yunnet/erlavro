%% coding: latin-1
%%%-------------------------------------------------------------------
%%% Copyright (c) 2013-2016 Klarna AB
%%%
%%% This file is provided to you under the Apache License,
%%% Version 2.0 (the "License"); you may not use this file
%%% except in compliance with the License.  You may obtain
%%% a copy of the License at
%%%
%%%   http://www.apache.org/licenses/LICENSE-2.0
%%%
%%% Unless required by applicable law or agreed to in writing,
%%% software distributed under the License is distributed on an
%%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%%% KIND, either express or implied.  See the License for the
%%% specific language governing permissions and limitations
%%% under the License.
%%%
%%%-------------------------------------------------------------------
-module(avro_enum_tests).

-import(avro_enum, [ cast/2
                   , get_value/1
                   , new/2
                   , type/2
                   ]).

-include("erlavro.hrl").
-include_lib("eunit/include/eunit.hrl").

empty_symbols_test() ->
  ?assertError(empty_symbols, type("FooBar", [])).

non_unique_symbols_test() ->
  ?assertError(non_unique_symbols, type("FooBar", ["a", "c", "d", "c", "e"])).

incorrect_name_test() ->
  ?assertError({invalid_name, "c-1"},
    type("FooBar", ["a", "b", "c-1", "d", "c", "e"])).

correct_cast_from_enum_test() ->
  SourceType = type("MyEnum", ["a", "b", "c", "d"]),
  SourceValue = new(SourceType, "b"),
  TargetType = SourceType,
  ?assertEqual({ok, SourceValue}, cast(TargetType, SourceValue)).

incorrect_cast_from_enum_test() ->
  SourceType = type("MyEnum", ["a", "b", "c", "d"]),
  SourceValue = new(SourceType, "b"),
  TargetType = type("MyEnum2", ["a", "b", "c", "d"]),
  ?assertEqual({error, type_name_mismatch}, cast(TargetType, SourceValue)).


correct_cast_from_string_test() ->
  Type = type("MyEnum", ["a", "b", "c", "d"]),
  {ok, Enum} = cast(Type, "b"),
  ?assertEqual(Type, ?AVRO_VALUE_TYPE(Enum)),
  ?assertEqual("b", get_value(Enum)).

incorrect_cast_from_string_test() ->
  Type = type("MyEnum", ["a", "b", "c", "d"]),
  ?assertEqual({error, {cast_error, Type, "e"}}, cast(Type, "e")).

get_value_test() ->
  Type = type("MyEnum", ["a", "b", "c", "d"]),
  Value = new(Type, "b"),
  ?assertEqual("b", get_value(Value)).

%%%_* Emacs ====================================================================
%%% Local Variables:
%%% allout-layout: t
%%% erlang-indent-level: 2
%%% End:

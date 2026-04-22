extends Node
#autoload global script for signals referenced in multiple places

signal hour_change(new_time)
signal day_change(new_day)
signal game_state_change(new_state)
signal party_confirmed(doll1, doll2, doll3, doll4)

signal game_load()

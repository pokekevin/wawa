extends Node
#autoload global script for signals referenced in multiple places

signal hour_change(new_time)
signal day_change(new_day)

signal game_state_change(new_state)

signal start_adv
signal party_confirmed(adv, dolls: Array, weapons: Array, uniform, beacon, perfume, ring)

signal game_load()


signal gold_change(amount)
signal inventory_changed

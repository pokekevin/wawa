class_name Expedition
extends Node
#expedition main control script

var current_party = {}
#the party that ends up going into battle
var party_array = []
#the array that goes into func enter_battle()
var weapon_array = []
#same as above

var current_enemy

var adventure_dict = {}

var battle_file = preload("res://scenes/battle.tscn")
var battle_scene

signal confirm_party
#init vars

func _ready():
	SignalBus.party_confirmed.connect(_party_confirmed)
	
	$expedition_end_screen.hide()
		
	update_signage()

func update_signage():
	$expedition_ui/entrance.text = "Entrance: " + current_floor + ", Viridian Forest"
	$expedition_ui/stage_number.text = "Current Stage: " + str(current_stage)

func _party_confirmed(adv, dolls, weapons, uniform, beacon, perfume, ring):
	expedition_start(adv)
	for i in dolls.size():
		party_array.append(dolls[i])
		weapon_array.append(weapons[i])


#location info
var current_state = "map"
var entrance = ""
var current_floor = "5-1"
var current_stage = 1
var current_event

var scripted_floor_array = []
var encounter_count = 0

func expedition_start(adv):
	var script_list_number = 0
	adventure_dict["number"] = adv.number
	adventure_dict["length"] = adv.length
	adventure_dict["boss"] = adv.boss
	adv.array_assignment()
	for i in 8:
		if adv.encounter_array[3*i-2] != 0:
			if adv.encounter_array[3*i-2] == -1:
				script_list_number += 1
				adventure_dict["scriptedencounter" + str(script_list_number)] = adv.encounter_array[3*i-3]
				scripted_floor_array.append("scriptedencounter" + str(script_list_number))
				scripted_floor_array.append(adv.encounter_array[3*i-1])
			else:
				encounter_count += 1
				adventure_dict["encounter" + str(encounter_count)] = adv.encounter_array[3*i-3]
				adventure_dict["weight" + str(encounter_count)] = adv.encounter_array[3*i-2]
				adventure_dict["unlock" + str(encounter_count)] = adv.encounter_array[3*i-1]

var on_boss = false
func on_turn():
	if current_stage == adventure_dict.length:
		encounter(adventure_dict.boss)
		on_boss = true
	elif scripted_floor_array.size() > 0:
		if scripted_floor_array.has(current_stage):
			var array_pos = scripted_floor_array.find(current_stage)
			encounter(adventure_dict[scripted_floor_array[array_pos - 1]])
			scripted_floor_array.remove_at(array_pos)
			scripted_floor_array.remove_at(array_pos - 1)
	else:
		var rng = RandomNumberGenerator.new()
		var encounter_array = []
		var encounter_weights = PackedFloat32Array([])
		for i in encounter_count:
			if current_stage >= adventure_dict["unlock" + str(i+1)]:
				encounter_array.append(adventure_dict["encounter" + str(i+1)])
				encounter_weights.append(adventure_dict["weight" + str(i+1)])
		encounter(encounter_array[rng.rand_weighted(encounter_weights)])


#temp
func _on_proceed_pressed():
	proceed()

func proceed():
	$expedition_ui.hide()
	on_turn()
	current_stage += 1
	update_signage()

#encounter function. call this one when clicking proceed
func encounter(_event):
	current_event = _event
	var events : Array = []
	var text_event = DialogicTextEvent.new()
	text_event.text = current_event.text
	events.append(text_event)
	
	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = events
	timeline.events_processed = true
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start(timeline)

var story_loop = 0

#recursion is necessary because dialogic is dogshit
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	
	if story_loop == 0:
		if current_event.type == "combat":
			enter_battle()
		elif current_event.type == "scavenge":
			print("deez")
		elif current_event.type == "story":
			Dialogic.start(current_event.story)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			story_loop = 1
	elif story_loop == 1:
		if current_event.battle != null:
			enter_battle()
			if current_event.story2 != null:
				pass
			else:
				story_loop = 0
	elif story_loop == 2:
		battle_end_progress_next()
		story_loop = 0



#function to instance a battle
#by default it will call an actionable dummy. somewhere down the line i think a dummy build would be funny
func enter_battle():
	current_party = expedition_party.new().party_list
	#if less than 4 will set rest to training dummies
	
	
	match party_array.size():
		1:
			current_party["doll1"] = party_array[0]
			current_party["doll2"] = Party.dummy
			current_party["doll3"] = Party.dummy
			current_party["doll4"] = Party.dummy
		2:
			current_party["doll1"] = party_array[0]
			current_party["doll2"] = party_array[1]
			current_party["doll3"] = Party.dummy
			current_party["doll4"] = Party.dummy
		3:
			current_party["doll1"] = party_array[0]
			current_party["doll2"] = party_array[1]
			current_party["doll3"] = party_array[2]
			current_party["doll4"] = Party.dummy
		4:
			current_party["doll1"] = party_array[0]
			current_party["doll2"] = party_array[1]
			current_party["doll3"] = party_array[2]
			current_party["doll4"] = party_array[3]
		0:
			current_party["doll1"] = Party.dummy
			current_party["doll2"] = Party.dummy
			current_party["doll3"] = Party.dummy
			current_party["doll4"] = Party.dummy
	
	
	party_array.append(current_party["doll1"])
	party_array.append(current_party["doll2"])
	party_array.append(current_party["doll3"])
	party_array.append(current_party["doll4"])
	current_enemy = current_event.battle
	
	add_child(preload("res://scenes/battle.tscn").instantiate())
	emit_signal("confirm_party", party_array, current_enemy)
	#adds a part instance and then initializes the party and enemy settings
	#conditions also need to come here later tbd
	
	get_node("battle").battle_end_signal.connect(_on_battle_battle_end_signal)



signal end_battle
func _on_battle_battle_end_signal(status):
	battle_scene = get_node("battle")
	battle_scene.queue_free()
	
	do_drops()
	
	if current_event.story2 != null:
		story_loop = 2
		Dialogic.start(current_event.story2)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
	else:
		battle_end_progress_next()

func battle_end_progress_next():
	if on_boss == true:
		end_expedition()
	else:
		$expedition_ui.show()


#################################
#drops

var expedition_drops = {}
var expedition_xp = 0

func do_drops():
	var drop_table = current_enemy.drop_table
	var drop_array = [drop_table.drop1, drop_table.drop1chance, drop_table.drop2, drop_table.drop2chance, drop_table.drop3, drop_table.drop3chance, drop_table.drop4, drop_table.drop4chance, drop_table.drop5, drop_table.drop5chance, drop_table.drop6, drop_table.drop6chance, drop_table.drop7, drop_table.drop7chance]
	var drop_info_array = []
	var i = 0
	while i < drop_array.size():
		if drop_array[i+1] != 0:
			var roll = roll_drops(drop_array[i+1])
			if roll == true:
				drop_get(drop_array[i])
				drop_info_array.append(drop_array[i])
			
		i = i + 2
	expedition_xp += current_enemy.xp
	emit_signal("end_battle", current_enemy.xp, drop_info_array, expedition_xp, expedition_drops)

func drop_get(item):
	if expedition_drops.has(item.name):
		expedition_drops[item.name]["amount"] += 1
	else :
		expedition_drops[item.name] = {
			"base": item,
			"amount": 1
		}


func roll_drops(chance):
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randf_range(0.0, 100.0)
	if chance >= random_number:
		return true
	else:
		return false

#############################



func end_expedition():
	
	$expedition_end_screen.show()
	$expedition_end_screen/AudioStreamPlayer2D.play()
	
	$expedition_end_screen/xp.text = "Total XP: " + str(expedition_xp) + "\n"
	$expedition_end_screen/loot.text = "Total Drops: \n"
	for key in expedition_drops.keys():
		$expedition_end_screen/loot.text += expedition_drops[key]["base"].name + " x" + str(expedition_drops[key]["amount"]) + "\n"
#end of expedition and tallying of loot and exp


func return_from_expedition():
	for key in expedition_drops.keys():
		Party.add_item(expedition_drops[key]["base"], expedition_drops[key]["amount"]) 
	SignalBus.expedition_end.emit()
	
	self.queue_free()

func _on_end_expedition_pressed():
	return_from_expedition()

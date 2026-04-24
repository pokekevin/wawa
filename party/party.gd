extends Node
#script holding all save data info total srp death
#anything that needs to be changed should come here or extend from here
#I LOVE HASHMAPS I LOVE HASHMAPS I LOVE HASHMAPS

func _ready():
	pass


var items_equipment : Dictionary
var items_loot : Dictionary
var items_material : Dictionary
var gold = 1.0

#feels like there is a faster way to do this but idk how
#add item function

func add_item(item_added: Resource, amount: int):
	var item: Dictionary = {
		"base": item_added,
		"amount": 0,
	}
	if item["base"].type == "Loot":
		for i in amount:
			if items_loot.has(item["base"].name):
				items_loot.get(item["base"].name)["amount"] += 1
			else:
				items_loot.set(item["base"].name, item)
				items_loot.get(item["base"].name)["amount"] = 1
	elif item["base"].type == "Material":
		for i in amount:
			if items_material.has(item["base"].name):
				items_material.get(item["base"].name)["amount"] += 1
			else:
				items_material.set(item["base"].name, item)
				items_material.get(item["base"].name)["amount"] = 1
	elif item["base"].type == "Weapon" or "Uniform" or "Beacon" or "Ring" or "Perfume":
		for i in amount:
			add_equipment(item)
	SignalBus.inventory_changed.emit()

func add_equipment(item):
	var equipment: Dictionary = {
		"name": item["base"].name,
		"base": item["base"],
		"affix1": ResourceLoader.load("res://item/affix/duck_bane.tres"),
		"affix2": ResourceLoader.load("res://item/affix/duck_bane.tres"),
		"affix3": ResourceLoader.load("res://item/affix/duck_bane.tres"),
		"affix4": ResourceLoader.load("res://item/affix/duck_bane.tres"),
 	}
	if items_equipment.has(equipment["name"]) == false:
		items_equipment.set(equipment["base"].name, equipment)
	else:
		var equip_name = equipment["name"]
		var looper = 1
		while items_equipment.has(equip_name):
			equip_name = equipment["name"] + str(looper)
			looper += 1
		items_equipment.set(equip_name, equipment)

#remove item function; see above for array optimization problems
func remove_item(item: Resource, amount: int):
	if item.type == "Loot":
		if items_loot.has(item.name):
			items_loot.get(item.name)["amount"] -= amount
			if items_loot.get(item.name)["amount"] == 0:
				items_loot.erase(item.name)
				return "empty"
	if item.type == "Material":
		if items_material.has(item.name):
			items_material.get(item.name)["amount"] -= amount
			if items_material.get(item.name)["amount"] == 0:
				items_material.erase(item.name)
				return "empty"
	SignalBus.inventory_changed.emit()



#/////////////////#



var progression : Dictionary = {
	"time_day": 1,
	#counts up from 1
	"time_hour": 1,
	#counts up to 4 from 1
	"adv_completed" : []
	#array of completed adventures
}

var company: Dictionary = {
	"Rank": 1,
	#F-E-D-C-B-A-S-U
	#numbers for easier checks on unlocks
	
	"overall_rep" : 0,
	"guild_rep": 0,
	"syndicate_rep": 0,
	"business_rep": 0,
	
	"location": "4",
	#2,3,4,maria,vermillion,heaven
	
	"business_type": "none",
	"business_xp": 0,
	
}



#///////////////////////#
#dolls
#///////////////////////#

func stat_raise(doll, stat, value):
	doll[stat] += value


#kei dictionary for kei's proficiencies
var kei: Dictionary = {
	"authority": 0,
	"veterancy": 0,
	"synthesis": 0,
	"cognizance": 0,
}

#template dict for dolls
#should not be typed because i have cancer
#not going to use a class for these because i think it'll be easier if you wanted to edit info for testing
#maybe can be replaced by just having a console to do it ??? idk
var dummy: Dictionary = {
	"doll_base": ResourceLoader.load("res://dolls/dolls/dolldummy.tres"),
	#resource with static info about doll
	"unlock": 0,
	"death": 0,
	#0 for false, 1 for true
	
	#info
	"level": 1,
	"xp": 0,
	"class": ResourceLoader.load("res://dolls/classes/Dummy.tres"),
	#unpunct, needs to load in during expedition select
	
	#stats
	"dom": 0,
	"inf": 0,
	"res": 0,
	"tem": 0,
	"pre": 0,
	
	#other attributes
	"affinity": 0,
	"luck": 0,
}

var kyuki: Dictionary = {
	"doll_base" : ResourceLoader.load("res://dolls/dolls/kyuki/kyuki.tres"),
	"unlock": 1,
	"death": 0,
	
	#info
	"level": 1,
	"xp": 0,
	"class": ResourceLoader.load("res://dolls/classes/rev/invalid/Ignorant Loner.tres"),
	
	#stats
	"dom": 10,
	"inf": 10,
	"res": 10,
	"tem": 10,
	"pre": 10,
	
	#other attributes
	"affinity": 0,
	"luck": 0,
}

var kiana: Dictionary = {
	"doll_base": ResourceLoader.load("res://dolls/dolls/kiana/kiana.tres"),
	#resource with static info about doll
	"unlock": 1,
	"death": 0,
	#0 for false, 1 for true
	
	#info
	"level": 1,
	"xp": 0,
	"class": ResourceLoader.load("res://dolls/classes/Dummy.tres"),
	#unpunct, needs to load in during expedition select
	
	#stats
	"dom": 0,
	"inf": 0,
	"res": 0,
	"tem": 0,
	"pre": 0,
	
	#other attributes
	"affinity": 0,
	"luck": 0,
}

var kosellia: Dictionary = {
	"doll_base" : ResourceLoader.load("res://dolls/dolls/kosellia/kosellia.tres"),
	"unlock": 1,
	"death": 0,
	
	#info
	"level": 1,
	"xp": 0,
	"class": ResourceLoader.load("res://dolls/classes/rev/invalid/Ignorant Loner.tres"),
	
	#stats
	"dom": 10,
	"inf": 10,
	"res": 10,
	"tem": 10,
	"pre": 10,
	
	#other attributes
	"affinity": 0,
	"luck": 0,
}









func doll_gain(doll):
	doll_list.append(doll)
#change this when you add a new doll
var doll_list: Array = [kyuki, kiana, kosellia, kyuki]

#final savefile that everything else needs to go under
var savefile: Dictionary
#save
func update_save():
	savefile = {
	"progression": progression,
	"doll_list" : doll_list,
	
	"gold" : gold,
	
	"items_equipment" : items_equipment,
	"items_loot" : items_loot,
	"items_material" : items_material,
	
	"company": company,
	
	"kei": kei,
	"kyuki": kyuki,
	"kiana": kiana,
	"kosellia": kosellia,
}

#load
func update_party():
	progression = savefile["progression"]
	doll_list = savefile["doll_list"]
	
	gold = savefile["gold"]
	items_equipment = savefile["items_equipment"]
	items_loot = savefile["items_loot"]
	items_material = savefile["items_material"]
	
	company = savefile["company"]
	
	kei = savefile["kei"]
	kyuki = savefile["kyuki"]
	kiana = savefile["kiana"]
	kosellia = savefile["kosellia"]

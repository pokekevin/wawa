extends MarginContainer
#controls the item submenu in the Cafe menu

var current_list
var current_item

#inits n shit
func _ready():
	#testing
	Party.add_item(ResourceLoader.load("res://item/equipment/duck_sword.tres"), 1)
	#loops through loot and mat dicts in party and puts them in 2 lists on the ui
	for key in Party.items_equipment.keys():
		add_node(Party.items_equipment[key])
	for key in AffixList.affix_dictionary.keys():
		add_affixes_dropdown(AffixList.affix_dictionary[key])

#add node func
func add_node(item):
	var node = item_list_button.new()
	node.text = item["base"].name
	node.set_name(item["base"].name)
	node.item = item
	node.item_selected.connect(change_item)
	
	var location
	location = get_node("HBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer")
	location.add_child(node)

#tbf
func remove_node(item):
	var item_node = get_tree().self.get_child(0).has_node(current_item.name)
	item_node.remove()

#changes current_item and calls the update item function
func change_item(item):
	current_item = item
	update_item(item)

#updates ui
func update_item(current_item):
	$HBoxContainer/Info/VBoxContainer/name.text = "Name: " + current_item["base"].name
	$HBoxContainer/Info/VBoxContainer/type.text = "Type: " + current_item["base"].type
	$HBoxContainer/Info/VBoxContainer/description.text = current_item["base"].description
	$HBoxContainer/Info/VBoxContainer/wAD.text = "wAD: " + str(current_item["base"].wAD)
	$HBoxContainer/Info/VBoxContainer/rank.text= "Rank: " + current_item["base"].rank
	$HBoxContainer/Info/VBoxContainer/affix0.text = "Base Affix: " + current_item["base"].affix.name
	
	$HBoxContainer/Info/VBoxContainer2/affix1.text = "Affix 1: " + current_item["affix1"].name
	$HBoxContainer/Info/VBoxContainer2/affix2.text = "Affix 2: " + current_item["affix2"].name
	$HBoxContainer/Info/VBoxContainer2/affix3.text = "Affix 3: " + current_item["affix3"].name
	$HBoxContainer/Info/VBoxContainer2/affix4.text = "Affix 4: " + current_item["affix4"].name

#temp
func add_affixes_dropdown(affix):
	var dropdown_array = [$HBoxContainer/VSplitContainer/VBoxContainer/affix1, $HBoxContainer/VSplitContainer/VBoxContainer/affix2, $HBoxContainer/VSplitContainer/VBoxContainer/affix3, $HBoxContainer/VSplitContainer/VBoxContainer/affix4]
	for i in dropdown_array.size():
		dropdown_array[i].add_item(ResourceLoader.load(affix).name)

func change_affix(affix, index):
	match index:
		0:
			current_item["affix1"] = ResourceLoader.load(AffixList.affix_dictionary[affix])
		1:
			current_item["affix2"] = ResourceLoader.load(AffixList.affix_dictionary[affix])
		2:
			current_item["affix3"] = ResourceLoader.load(AffixList.affix_dictionary[affix])
		3:
			current_item["affix4"] = ResourceLoader.load(AffixList.affix_dictionary[affix])
	change_item(current_item)

func _on_affix_1_item_selected(index):
	affix_array[0] = $HBoxContainer/VSplitContainer/VBoxContainer/affix1.get_item_text(index)

func _on_affix_2_item_selected(index):
	affix_array[1] = $HBoxContainer/VSplitContainer/VBoxContainer/affix2.get_item_text(index)

func _on_affix_3_item_selected(index):
	affix_array[2] = $HBoxContainer/VSplitContainer/VBoxContainer/affix3.get_item_text(index)

func _on_affix_4_item_selected(index):
	affix_array[3] = $HBoxContainer/VSplitContainer/VBoxContainer/affix4.get_item_text(index)

var affix_array = ["", "", "", ""]

func _on_confirm_pressed():
	for i in affix_array.size():
		change_affix(affix_array[i], i)

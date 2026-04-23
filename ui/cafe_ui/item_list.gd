extends MarginContainer
#controls the item submenu in the Cafe menu

var current_list
var current_item

#inits n shit
func _ready():
	SignalBus.inventory_changed.connect(inventory_changed)
	
	Party.add_item(ResourceLoader.load("res://item/loot/duck_feather.tres"), 2)
	Party.add_item(ResourceLoader.load("res://item/material/duck_beak.tres"), 6)
	#testing
	
	#loops through loot and mat dicts in party and puts them in 2 lists on the ui
	inventory_changed()

func inventory_changed():
	var location
	location = get_node("HBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer")
	free_current(location)
	location = get_node("HBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2")
	free_current(location)
	
	current_list = "loot"
	for key in Party.items_loot.keys():
		add_node(Party.items_loot[key])
	current_list = "material"
	for key in Party.items_material.keys():
		add_node(Party.items_material[key])

func free_current(location):
	if location.get_child_count() > 0:
		var children = location.get_children()
		for c in children:
			location.remove_child(c)
			c.queue_free()

#add node func
func add_node(item):
	var node = item_list_button.new()
	node.text = item["base"].name
	node.set_name(item["base"].name)
	node.item = item
	node.item_selected.connect(change_item)
	
	var location
	if (current_list == "loot"):
		location = get_node("HBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer")
	if (current_list == "material"):
		location = get_node("HBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2")
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
	$HBoxContainer/Info/VBoxContainer/value.text = "Value: " + str(current_item["base"].value)
	$HBoxContainer/Info/VBoxContainer/amount.text= "Currently Owned: " + str(current_item["amount"])

#add and remove item test buttons
func _on_add_pressed():
	Party.add_item(current_item["base"], 1)
	if current_item["base"].type == "Loot":
		change_item(Party.items_loot[current_item["base"].name])
	if current_item["base"].type == "Material":
		change_item(Party.items_material[current_item["base"].name])

func _on_remove_pressed():
	Party.remove_item(current_item["base"], 1)
	if current_item["base"].type == "Loot":
		change_item(Party.items_loot[current_item["base"].name])
	if current_item["base"].type == "Material":
		change_item(Party.items_material[current_item["base"].name])

extends MarginContainer

var current_list

#inits n shit
func _ready():
	
	current_list = "loot"
	for key in Party.items_loot.keys():
		add_node(Party.items_loot[key])
	current_list = "material"
	for key in Party.items_material.keys():
		add_node(Party.items_material[key])

var current_item

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

func change_item(item):
	current_item = item
	update_item(item)

func update_item(item):
	$"../item_value".text = "Current Item Value: " + str(item["base"].value)
	$"../item_amount".text = "Amount Held: " + str(item["amount"])

func _on_sell_pressed():
	if current_item["amount"] > 0:
		var item = current_item["base"]
		SignalBus.gold_change.emit(item.value)
		Party.remove_item(item, 1)
		update_item(current_item)


func _on_sell_all_pressed():
	if current_item["amount"] > 0:
		var item = current_item["base"]
		SignalBus.gold_change.emit(item.value * current_item["amount"])
		print(current_item["amount"])
		Party.remove_item(item, current_item["amount"])
		update_item(current_item)

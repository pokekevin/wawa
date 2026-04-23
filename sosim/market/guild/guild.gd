extends Control

var current_list

#inits n shit
func _ready():
	
	current_list = "loot"
	for key in Party.items_loot.keys():
		add_node_sell(Party.items_loot[key])
	current_list = "material"
	for key in Party.items_material.keys():
		add_node_sell(Party.items_material[key])
	
	
	update_shop(ResourceLoader.load("res://sosim/market/guild/frank.tres"))
	
	$"gold".text = "Gold: " + str(Party.gold)



var current_item

func add_node_sell(item):
	var node = item_list_button.new()
	node.text = item["base"].name
	node.set_name(item["base"].name)
	node.item = item
	node.item_selected.connect(change_item)
	
	var location
	if (current_list == "loot"):
		location = get_node("sell_items/HBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer")
	if (current_list == "material"):
		location = get_node("sell_items/HBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2")
	location.add_child(node)

func change_item(item):
	current_item = item
	update_item(item)

func update_item(item):
	$item_name.text = "Item Name: " + item["base"].name
	$item_value.text = "Current Item Value: " + str(item["base"].value)
	$"item_amount".text = "Amount Held: " + str(item["amount"])
	$"gold".text = "Gold: " + str(Party.gold)

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




########################

var current_shop
var current_item_buy

func update_shop(shop):
	current_shop = shop
	for key in current_shop.table.keys():
		add_node_buy(key)

func add_node_buy(item):
	var node = item_list_button.new()
	node.text = item.name
	node.set_name(item.name)
	node.item = item
	node.item_selected.connect(change_item_buy)
	
	var location
	if (item.type == "Material"):
		location = get_node("buy_items/HBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2")
	else:
		location = get_node("buy_items/HBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer")
	location.add_child(node)

func change_item_buy(item):
	current_item_buy = item
	update_item_buy(item)

func update_item_buy(item):
	$item_info.text = "Name: " + item.name + "\nType: " + item.type + "\n Price: " + str(current_shop.table[item]) + "\n Description: \n" + item.description
	if item.type != "Material":
		$item_info_equipment.text = "Rank: " + item.rank + "\nAffix: " + item.affix.name 
		if item.type == "Weapon":
			$item_info_equipment.text += ("\nAD: " + str(item.wAD))
	else:
		$item_info_equipment.clear()



func buy_item():
	if Party.gold >= current_shop.table[current_item_buy]:
		Party.gold -= current_shop.table[current_item_buy]
		print(current_item_buy.name)
		Party.add_item(current_item_buy, 1)
		$"gold".text = "Gold: " + str(Party.gold)
		


func _on_buy_pressed():
	buy_item()

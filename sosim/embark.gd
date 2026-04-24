extends Control

func _ready():
	SignalBus.inventory_changed.connect(update_lists)
	update_lists()

func update_lists():
	adventure_list_update()
	doll_select_update($VSplitContainer/doll1)
	doll_select_update($VSplitContainer/doll2)
	doll_select_update($VSplitContainer/doll3)
	doll_select_update($VSplitContainer/doll4)
	weapon_select_update($VSplitContainer2/weapon1)
	weapon_select_update($VSplitContainer2/weapon2)
	weapon_select_update($VSplitContainer2/weapon3)
	weapon_select_update($VSplitContainer2/weapon4)
	equipment_select_update()


func adventure_list_update():
	$adventure_select.clear()
	for key in AdventureList.adv_dictionary:
		$adventure_select.add_item(key)

func doll_select_update(node):
	node.clear()
	for i in Party.doll_list.size():
		node.add_item(Party.doll_list[i]["doll_base"]["name"])

func weapon_select_update(node):
	node.clear()
	for key in Party.items_equipment.keys():
		if Party.items_equipment[key]["base"]["type"] == "Weapon":
			node.add_item(key)

func equipment_select_update():
	$uniform.clear()
	$beacon.clear()
	$perfume.clear()
	$ring.clear()
	for key in Party.items_equipment.keys():
		match Party.items_equipment[key]["base"]["type"]:
			"Uniform":
				$uniform.add_item(key)
			"Beacon":
				$beacon.add_item(key)
			"Perfume":
				$perfume.add_item(key)
			"Ring":
				$ring.add_item(key)

func begin_expedition():
	#adv, dolls: Array, weapons: Array, uniform, beacon, perfume, ring
	var adv = ResourceLoader.load(AdventureList.adv_dictionary[AdventureList.adv_array[$adventure_select.selected]])
	var dolls = [get_doll($VSplitContainer/doll1), get_doll($VSplitContainer/doll2), get_doll($VSplitContainer/doll3), get_doll($VSplitContainer/doll4)]
	var weapons = [get_equip($VSplitContainer2/weapon1), get_equip($VSplitContainer2/weapon2), get_equip($VSplitContainer2/weapon3), get_equip($VSplitContainer2/weapon4)]
	var uniform = get_equip($uniform)
	var beacon = get_equip($beacon)
	var perfume = get_equip($perfume)
	var ring = get_equip($ring)
	SignalBus.start_adv.emit()
	SignalBus.party_confirmed.emit(adv, dolls, weapons, uniform, beacon, perfume, ring)

func get_doll(node):
	return Party.doll_list[node.selected]
func get_equip(node):
	return Party.items_equipment[node.text]

func _on_being_expedition_pressed():
	begin_expedition()

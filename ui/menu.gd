extends Control
#node for the tab menu
#the big warning sign isnt true anymore btw but i cba to remove

signal party_confirmed

func _ready():
	
	for i in range(Party.doll_list.size()):
		add_listing(Party.doll_list[i])
	expedition_party_confirm(Party.kyuki, Party.kyuki, Party.kyuki, Party.kyuki)
	
	SignalBus.gold_change.connect(_on_gold_changed)
	$"gold counter".text = "Gold: " + str(Party.gold)

func expedition_party_confirm(doll1, doll2, doll3, doll4):
	pass

func add_listing(doll):
	$menu_select/Expedition/doll_choose_list.add_item(doll["doll_base"]["name"])


#temporary
func _on_doll_choose_confirmation_pressed():
	var selected_doll_array = $menu_select/Expedition/doll_choose_list.get_selected_items()
	var doll1 = 0
	var doll2 = 1
	var doll3 = 2
	var doll4 = 3
	#hardcoded rn need to fix
	var get_cancer_array = [doll1, doll2, doll3, doll4]
	
	var expedition_scene
	get_parent().add_child(preload("res://scenes/expedition.tscn").instantiate())
	emit_signal("party_confirmed", get_cancer_array, "res://expedition/expedition/adventure/intro.tres")
	
	get_parent().get_node("expedition").expedition_end.connect(_on_expedition_expedition_end)
	get_parent().get_node("expedition").end_battle.connect(_on_expedition_end_battle)
	
	$menu_select/Expedition/doll_choose_list.hide()
	$menu_select/Expedition/doll_choose_confirmation.hide()
	$menu_select/Expedition/WARNING.hide()
	self.hide()
	


func _on_test_dialog_pressed():
	Dialogic.start("intro")


func _on_expedition_end_battle(exp, drops, expedition_xp, total_drops):
	#$menu_select/Expedition/doll_choose_list.show()
	#$menu_select/Expedition/doll_choose_confirmation.show()
	#$menu_select/Expedition/WARNING.show()
	#if self.visible == false:
		#self.show()
	
	$menu_select/Expedition/battle_end_info.text = "Battle End \nEXP: " + str(exp) + "\nItem Drops: \n"
	
	for i in drops.size():
		$menu_select/Expedition/battle_end_info.text += drops[i].name + "\n"
	
	$menu_select/Expedition/battle_end_info2.text = "Total XP: " + str(expedition_xp) + "\n"
	$menu_select/Expedition/battle_end_info2.text += "Total Drops: \n"
	for key in total_drops.keys():
		$menu_select/Expedition/battle_end_info2.text += total_drops[key]["base"].name + "\n"


func _on_expedition_expedition_end():
	self.show()
	$menu_select/Expedition/battle_end_info.text = "Waiting for Expedition"
	$menu_select/Expedition/battle_end_info2.text = "Waiting for Expedition"
	
	$menu_select/Expedition/doll_choose_list.show()
	$menu_select/Expedition/doll_choose_confirmation.show()
	$menu_select/Expedition/WARNING.show()


func _on_gold_changed(amount):
	Party.gold += amount
	$"gold counter".text = "Gold: " + str(Party.gold)

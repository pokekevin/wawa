extends Control
#node for the tab menu
#the big warning sign isnt true anymore btw but i cba to remove

signal party_confirmed

func _ready():
	
	SignalBus.gold_change.connect(_on_gold_changed)
	$"gold counter".text = "Gold: " + str(Party.gold)


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

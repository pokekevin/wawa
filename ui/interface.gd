extends Control

var curr

func _input(event):
	if event.is_action_pressed("menu"):
		if $menu.is_visible():
			$menu.hide()
			return
		if not $menu.is_visible():
			$menu.show()
			return
#open and close menu

func _ready():
	#$expedition/battle.queue_free()
	#gets rid of existing battles
	
	SignalBus.start_adv.connect(start_expedition)

func start_expedition():
	self.add_child(preload("res://scenes/expedition.tscn").instantiate())
	$sosim.hide()


func _on_battle_battle_end_signal():
	pass # Replace with function body.

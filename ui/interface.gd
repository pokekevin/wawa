extends Control

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
	pass
#gets rid of existing battles


func _on_battle_battle_end_signal():
	pass # Replace with function body.

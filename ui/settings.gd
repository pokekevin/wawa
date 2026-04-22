extends MarginContainer



func _on_save_pressed():
	SaveLoad._save()


func _on_load_pressed():
	SaveLoad._load()



func _on_exit_pressed():
	get_tree().quit()

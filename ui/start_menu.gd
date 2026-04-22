extends Control

func _on_exit_pressed():
	get_tree().quit()


#loads straight into the intro
func _on_start_pressed():
	Dialogic.start("intro")
	self.queue_free()

#load button tbi

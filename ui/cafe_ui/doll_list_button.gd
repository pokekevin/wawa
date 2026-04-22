class_name doll_list_button
extends Button

var doll
signal doll_selected

func _pressed():
	emit_signal("doll_selected", doll)

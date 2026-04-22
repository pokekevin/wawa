class_name item_list_button
extends Button

var item
signal item_selected

func _pressed():
	emit_signal("item_selected", item)

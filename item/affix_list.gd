extends Node

var affix_dictionary = {
	"Duck Bane" : "res://item/affix/duck_bane.tres",
	"Duck Help" : "res://item/affix/duck_help.tres",
}

var affix_array = []

func _ready():
	for key in affix_dictionary.keys():
		affix_array.append(key)

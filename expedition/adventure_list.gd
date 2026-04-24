extends Node

var adv_dictionary = {
	"5-1" : "res://expedition/adventure/5-1/5-1.tres",
	"intro" : "res://expedition/adventure/5-1/intro.tres",
}

var adv_array = []

func _ready():
	for key in adv_dictionary.keys():
		adv_array.append(key)

extends Node
#save/load script. uses a resource below "save_file.tres" and isn't encrypted which i think is a le good thing

const save_location = "user://save_file.tres"

#creates new instance of save_file_data resource
var save_file_data: SaveDataResource = SaveDataResource.new()

#saver script; need to implement one line for each variable in the .savefile dict in party.gd
func _save():
	Party.update_save()
	save_file_data.savefile = Party.savefile
	ResourceSaver.save(save_file_data, save_location)
#see save_data class; needs to be changed whenever a new variable needs to be loaded in

#load func. needs to have the shit loaded in
func _load():
	if FileAccess.file_exists(save_location):
		save_file_data = ResourceLoader.load(save_location).duplicate(true)
	Party.savefile = save_file_data.savefile
	Party.update_party()

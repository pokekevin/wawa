class_name adventure
extends Resource
#resource class for adventures, or the expedition routes

@export var number: String
@export_enum("mobber", "boss", "story") var type: String

#neither of these should be visible to the player
@export var name: String
@export var description: String

@export var length: int



@export_category("Encounters")

#boss stage will always occur at the last stage on every adventure
#guaranteed loot type shit 
@export var boss: Resource

#if type=story, set scripted encounters to weighting=-1 and unlock to the stage the condition is set at
#other encounters will work normally at non-scripted stages
#if none, leave weighting as 0 and the expedition script will skip it over
@export var encounter1: Resource
@export var weighting1: int
@export var unlock1: int 

@export var encounter2: Resource
@export var weighting2: int
@export var unlock2: int 

@export var encounter3: Resource
@export var weighting3: int
@export var unlock3: int

@export var encounter4: Resource
@export var weighting4: int
@export var unlock4: int 

@export var encounter5: Resource
@export var weighting5: int
@export var unlock5: int 

@export var encounter6: Resource
@export var weighting6: int
@export var unlock6: int 

@export var encounter7: Resource
@export var weighting7: int
@export var unlock7: int 

@export var encounter8: Resource
@export var weighting8: int
@export var unlock8: int 

var encounter_array = []

func array_assignment():
	encounter_array = [encounter1, weighting1, unlock1, encounter2, weighting2, unlock2, encounter3, weighting3, unlock3, 
	encounter4, weighting4, unlock4, encounter5, weighting5, unlock5, encounter6, weighting6, unlock6, encounter7, weighting7, unlock7, 
	encounter8, weighting8, unlock8]

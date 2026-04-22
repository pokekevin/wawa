class_name DollDefault
extends Resource
#resource class for a doll's default state that should be loaded in on first recruitment

@export var name: String
#this needs first letter caps to function properly when matching with the party.gd
@export var diTrait: String
@export var doll_trait_desc: String
@export var portrait: Resource
@export var sprite: Resource

#hidden stat multipliers
@export var hiddendom: float = 1
@export var hiddeninf: float = 1
@export var hiddenres: float = 1
@export var hiddentem: float = 1
@export var hiddenpre: float = 1
@export var hiddenluck: float = 1

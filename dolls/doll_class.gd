class_name DollClass
extends Resource
#resource class for doll identities
#refered to as "class" for back end purposes because identity is hard to type

@export var name: String
#this needs first letter caps to function properly when matching with the party.gd
@export var family: String
@export var tier: String
@export var description: String
@export var dcTrait: String
@export var class_trait_desc: String

@export var skill1: Resource
@export var skill2: Resource
@export var skill3: Resource
@export var skill4: Resource

#hidden stat multipliers
#1.0 = 100%
@export var hiddendom: float = 1
@export var hiddeninf: float = 1
@export var hiddenres: float = 1
@export var hiddentem: float = 1
@export var hiddenpre: float = 1

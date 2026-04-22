extends Resource
class_name Equipment


@export var address: String
@export var name: String
@export_enum("Weapon", "Uniform", "Beacon", "Perfume", "Ring") var type: String
@export var texture: Texture2D

@export var description: String

@export var affix: Affix
@export var wAD: int 


@export var rank: String

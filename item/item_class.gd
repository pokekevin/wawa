extends Resource
class_name Item


@export var address: String
@export var name: String
@export_enum("Loot", "Material") var type: String
@export var texture: Texture2D

@export var description: String
@export var value: float
@export var rank: String

extends Resource
class_name Affix

@export var name: String
@export_enum("Prefix", "Suffix") var type: String
@export var effect: String
@export var effect_value: float
@export var description: String

@export_category("Attainment")
@export_enum("Uniform", "Beacon", "Perfume", "Ring") var equipment_type: String
@export var weighting: int

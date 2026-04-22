extends Resource
class_name EnemySkill

@export var esName: String
@export var esDamage: float
@export var esEffect: String = "none"
#same system as skill effects. search the string name in the spreadsheet
@export var esEffectValue: float
@export var esLoss: float
@export var esPen: float

@export var esTargeting1: bool
@export var esTargeting2: bool
@export var esTargeting3: bool
@export var esTargeting4: bool

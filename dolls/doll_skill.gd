class_name DollSkill
extends Resource
#check the spreadsheet for variable meanings but should be self-explanatory
#dsUnique is for especially unusual stuff that will need to be processed differently

@export var dsName: String
@export var dsTier: String
@export var dsAD: float
@export var skill_desc: String

@export_enum("phys", "mag", "heal", "shield") var dsType: String
@export_enum("enemy", "party", "self") var dsTarget: String

@export var dsADM: float

@export var dsLoss: float
@export var dsCost: float
@export var dsUnique: String

@export_category("Crit and Pen")
@export var dsCritChance: float
@export var dsCritMulti: float
@export var dsPen: float

@export_category("Heal and Shield Multi")
@export var dsHealM: float
@export var dsShieldM: float

@export_category("Ailments")
@export_enum("none","shred", "delay", "stun", "weakness","poison","scorch","rime","charge","bleed") var dsAilmentType: String = "none"
@export var dsAilmentChance: float
@export var dsAilmentBase: float
@export var dsAilmentM: float
@export var dsAilmentMore: float

#check the main battle sheet for match
#it might actually be faster to have this put in here instead so you have it all in one place ? idk
#this was faster to type out, at least, since i only had to copy it once from the spreadsheet
@export_category("Buffs and Stuff")
@export var effect1: String = "none"
@export var effect1value: float
@export var effect2: String = "none"
@export var effect2value: float
@export var effect3: String = "none"
@export var effect3value: float
@export var effect4: String = "none"
@export var effect4value: float

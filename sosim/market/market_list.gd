extends Resource
class_name MarketList


@export var name: String
@export_enum("none", "f", "e", "d", "c", "b", "a", "s") var req: String
@export_flags("material", "equipment", "cake") var item_types

@export_category("Items; Resource + Price")
@export var table: Dictionary[Resource, int]

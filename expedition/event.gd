class_name event
extends Resource
#resource class for events

@export var name: String
@export_enum("combat", "scavenge", "story") var type: String
@export var text: String

@export_category("Resources")
@export var battle: Resource
@export var item: Resource
@export var story: Resource
@export var story2: Resource

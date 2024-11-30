extends Resource
class_name Character

@export var code : String
@export var texture : Texture2D
@export var theme : AudioStream
@export_subgroup("Events")
@export var event_eliminated : Event
@export var events : Array[Event]

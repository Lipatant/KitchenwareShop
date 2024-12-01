extends Resource
class_name Character

@export var code : String
@export var theme : AudioStream
@export_subgroup("Textures")
@export var texture_crying : Texture2D
@export var texture_embarrassed : Texture2D
@export var texture_focused : Texture2D
@export var texture_happy : Texture2D
@export var texture_neutral : Texture2D
@export var texture_sad : Texture2D
@export var texture_scared : Texture2D
@export var texture_terrified : Texture2D
@export_subgroup("Events")
@export var event_eliminated : Event
@export var events : Array[Event]

enum Emotion {
	CRYING,
	EMBARRASSED,
	FOCUSED,
	HAPPY,
	NEUTRAL,
	SAD,
	SCARED,
	TERRIFIED,
}

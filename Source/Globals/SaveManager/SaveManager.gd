extends Node

# EXPORTS #

@export var _character_resources : Array[Character]
@export var _dialogue_resource : PackedScene
@export var _elimination_resource : PackedScene

# MEMBERS #

var current_character : Character
var current_day : int
var current_event : Event
var characters : Array[Character]
var characters_remaining : Array[Character]

# METHODS #

func _ready() -> void:
	reset()

func eliminate_character(character: Character) -> void:
	characters.erase(character)
	start_next_day()

func end_event() -> void:
	if characters_remaining.is_empty():
		SceneManager.change_scene_to_packed(_elimination_resource)
	else:
		intertact_with_character(characters_remaining.front())

func intertact_with_character(character: Character) -> void:
	var current_day_index : int = current_day - 1
	characters_remaining.erase(character)
	assert(character.events.size() > current_day_index)
	current_character = character
	current_event = character.events[current_day_index]
	SceneManager.change_scene_to_packed(_dialogue_resource)

func reset() -> void:
	current_day = 0
	characters = _character_resources.duplicate(false)

func start_next_day() -> void:
	current_day += 1
	characters_remaining = characters.duplicate(false)
	if characters_remaining.is_empty():
		SceneManager.change_scene_to_file("res://Source/Scenes/MainMenu.tscn")
	else:
		intertact_with_character(characters_remaining.front())

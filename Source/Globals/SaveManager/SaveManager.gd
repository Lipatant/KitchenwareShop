extends Node

# EXPORTS #

@export var _character_resources : Array[Character]
@export var _dialogue_resource : PackedScene

# MEMBERS #

var characters : Array[Character]

# METHODS #

func _ready() -> void:
	reset()

func reset() -> void:
	characters = _character_resources.duplicate(false)

func start_next_day() -> void:
	SceneManager.change_scene_to_packed(_dialogue_resource)

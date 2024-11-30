extends Node

# EXPORTS #

@export var _character_resources : Array[Character]

# MEMBERS #

var characters : Array[Character]

# METHODS #

func _ready() -> void:
	reset()

func reset() -> void:
	characters = _character_resources.duplicate(false)

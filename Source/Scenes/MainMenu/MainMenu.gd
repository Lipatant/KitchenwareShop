extends Node

# EXPORTS #

@export var music : AudioStream

# METHODS #

func _ready() -> void:
	MusicManager.play(music)

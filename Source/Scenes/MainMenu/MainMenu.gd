extends Node

# EXPORTS #

@export var music : AudioStream

# METHODS #

func _ready() -> void:
	MusicManager.play(music)

func _on_leave_button_pressed() -> void:
	SceneManager.quit()

func _on_start_button_pressed() -> void:
	SaveManager.start_next_day()

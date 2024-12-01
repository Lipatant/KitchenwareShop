extends Node

# EXPORTS #

@export var music : AudioStream

# METHODS #

func _ready() -> void:
	MusicManager.play(music)
	%LeaveButton.visible = _can_use_leave_button()

func _can_use_leave_button() -> bool:
	return !OS.has_feature("web")

func _on_leave_button_pressed() -> void:
	SceneManager.quit()

func _on_start_button_pressed() -> void:
	SaveManager.reset()
	SaveManager.start_next_day()

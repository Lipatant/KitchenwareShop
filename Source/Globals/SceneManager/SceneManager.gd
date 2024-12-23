extends Node

# METHODS #

func _ready() -> void:
	_play_face_out_animation()

func change_scene_to_file(path: String) -> Error:
	await _play_fade_in_animation()
	var output : Error = get_tree().change_scene_to_file(path)
	_play_face_out_animation()
	return output

func change_scene_to_packed(packed_scene: PackedScene) -> Error:
	await _play_fade_in_animation()
	var output : Error = get_tree().change_scene_to_packed(packed_scene)
	_play_face_out_animation()
	return output

func quit() -> void:
	await _play_fade_in_animation()
	get_tree().quit()

func _play_fade_in_animation() -> void:
	%AnimationPlayer.play("FadeIn")
	await %AnimationPlayer.animation_finished

func _play_face_out_animation() -> void:
	%AnimationPlayer.play("FadeOut")

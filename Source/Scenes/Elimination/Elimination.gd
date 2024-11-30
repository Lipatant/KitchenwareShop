extends SceneChoice

# MEMBERS #

func _get_character_list() -> Array[Character]:
	return SaveManager.characters

func _on_character_selected(character: Character) -> void:
	SaveManager.eliminate_character(character)

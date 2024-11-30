extends Node
class_name SceneChoice

# MEMBERS #

func _ready() -> void:
	MusicManager.play()
	for character : Character in _get_character_list():
		%ItemList.add_item("CharacterName" + character.code)

func _get_character_list() -> Array[Character]:
	return SaveManager.characters_remaining

func _on_character_selected(character: Character) -> void:
	SaveManager.intertact_with_character(character)

func _on_item_list_item_activated(index: int) -> void:
	_on_character_selected(SaveManager.characters[index])

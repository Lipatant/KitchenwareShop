extends Node

# MEMBERS #

func _ready() -> void:
	MusicManager.play()
	for character : Character in SaveManager.characters_remaining:
		%ItemList.add_item("CharacterName" + character.code)

func _on_item_list_item_activated(index: int) -> void:
	SaveManager.intertact_with_character(SaveManager.characters[index])

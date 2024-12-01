extends Node

# EXPORTS #

@export var main_menu_resource : PackedScene

# MEMBERS #

var _character : Character :
	set(_character_):
		_character = _character_
		_refresh_character()

# METHODS #

func _ready() -> void:
	MusicManager.play()
	_character = SaveManager.characters.front() if SaveManager.characters else null

func _on_main_menu_button_pressed() -> void:
	SceneManager.change_scene_to_packed(main_menu_resource)

func _refresh_character() -> void:
	%CharacterName.text = "CharacterName" + (_character.code if _character else "Unknown")
	%CharacterRecipe.text = ("CharacterRecipe" + _character.code) if _character else ""
	%CharacterRecipeDescription.text = ("CharacterRecipe" + _character.code + "Description") if _character else ""

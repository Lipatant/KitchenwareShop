extends Node
class_name SceneChoiceElement

# MEMBERS #

var character : Character = null :
	set(character_):
		character = character_
		_refresh_character()

# SIGNALS #

signal on_character_pressed(character: Character)

# METHODS #

func _ready() -> void:
	_refresh_character()

func _on_character_button_pressed() -> void:
	on_character_pressed.emit(character)

func _refresh_character() -> void:
	%CharacterPortrait.texture = character.texture_neutral if character else null
	%CharacterButton.text = "CharacterName" + (character.code if character else "Unknown")

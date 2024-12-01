extends Node
class_name SceneChoice

# EXPORTS #

@export var _choice_element_resource : PackedScene

# MEMBERS #

func _ready() -> void:
	MusicManager.play()
	for character : Character in _get_character_list():
		_add_choice_element(character)

func _add_choice_element(character: Character) -> SceneChoiceElement:
	var choice_element: SceneChoiceElement = _choice_element_resource.instantiate()
	%ChoiceElementContainer.add_child(choice_element)
	choice_element.character = character
	choice_element.on_character_pressed.connect(_on_choice_element_character_pressed)
	return choice_element

func _get_character_list() -> Array[Character]:
	return SaveManager.characters_remaining

func _on_character_selected(character: Character) -> void:
	SaveManager.intertact_with_character(character)

func _on_choice_element_character_pressed(character: Character) -> void:
	_on_character_selected(character)

extends Node

# EXPORTS #

@export var main_menu_resource : PackedScene

# MEMBERS #

var _character : Character
var _event : Event
var _lines : Array
var _speech_tween : Tween
var _wait_for_choice : bool

# SIGNALS #

signal speech_finished()
signal speech_pressed()

# METHODS #

func _ready() -> void:
	set_character_name()
	set_emotion()
	play(SaveManager.current_event, SaveManager.current_character)

func play(event: Event, character: Character = null) -> void:
	_character = character
	_event = event
	_lines = event.code.split("\n", false)
	_wait_for_choice = !event.choices.is_empty()
	set_emotion()
	MusicManager.play(_character.theme)
	play_next()

func play_next() -> void:
	while !_lines.is_empty():
		if !_play_line(_lines.pop_front()):
			return
	if _wait_for_choice:
		_wait_for_choice = false
		for choice : Event in _event.choices:
			%Choice.add_item("CharacterSpeech" + choice.choice_name)
		%Choice.visible = true
	else:
		SaveManager.end_event()

# PRIVATE MEMBERS #

func _emit_speech_finished() -> void:
	speech_finished.emit()

func _on_character_speech_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			speech_pressed.emit()

func _on_choice_item_activated(index: int) -> void:
	%Choice.visible = false
	play(_event.choices[index], _character)

func _on_skip_all_button_pressed() -> void:
	SaveManager.end_event()

func _on_main_menu_button_pressed() -> void:
	SceneManager.change_scene_to_packed(main_menu_resource)

func _on_speech_pressed() -> void:
	if !%CharacterSpeech.text:
		return
	if _speech_tween and _speech_tween.is_running():
		_speech_tween.stop()
		%CharacterSpeech.visible_characters = %CharacterSpeech.text.length()
	elif !%Choice.visible:
		play_next()

func _play_line(line: String) -> bool:
	var tokens : Array = line.split(" ", false)
	assert(tokens.size() > 0)
	return callv(tokens.pop_front(), tokens)

# EVENT FUNCTIONS #

func say(speech_code: String, emotion: String = "") -> bool:
	var line : String = tr("CharacterSpeech" + speech_code)
	var line_duration : float = 0.02 * line.length()
	%CharacterSpeech.text = line
	%CharacterSpeech.visible_characters = 0
	_speech_tween = create_tween()
	_speech_tween.tween_property(%CharacterSpeech, "visible_characters", line.length(), line_duration)
	if emotion:
		set_emotion(emotion)
	return false

func set_character_name(character_code: String = "") -> bool:
	if character_code.is_empty():
		%CharacterName.text = ""
		%CharacterNameContainer.visible = false
	else:
		%CharacterName.text = "CharacterName" + character_code
		%CharacterNameContainer.visible = true
	return true

func set_character_name_self() -> bool:
	return set_character_name(_character.code if _character else "")

func set_character_name_unknown() -> bool:
	return set_character_name("Unknown")

func set_emotion(emotion: String = "") -> bool:
	var character_emotion := Character.Emotion.NEUTRAL
	var emotion_formated : String = emotion.to_snake_case().to_upper()
	var emotion_texture_name : String
	if emotion_formated:
		assert(Character.Emotion.has(emotion_formated))
		character_emotion = Character.Emotion.get(emotion_formated)
	else:
		emotion_formated = Character.Emotion.find_key(character_emotion)
	%Emotion.text = emotion_formated
	emotion_texture_name = "texture_" + emotion_formated.to_snake_case()
	if _character and emotion_texture_name in _character:
		%CharacterPortrait.texture = _character[emotion_texture_name]
	else:
		%CharacterPortrait.texture = null
	if %CharacterPortrait.texture:
		%CharacterPortrait.visible = true
		%EmotionContainer.visible = false
	else:
		%CharacterPortrait.visible = false
		%EmotionContainer.visible = true
	return true

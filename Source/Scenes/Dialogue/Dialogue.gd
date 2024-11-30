extends Node

# MEMBERS #

var _character : Character
var _lines : Array
var _speech_tween : Tween

# SIGNALS #

signal speech_finished()
signal speech_pressed()

# METHODS #

func _ready() -> void:
	set_character_name()
	play(SaveManager.current_event, SaveManager.current_character)

func play(event: Event, character: Character = null) -> void:
	_lines = event.code.split("\n", false)
	_character = character
	MusicManager.play(_character.theme)
	play_next()

func play_next() -> void:
	while !_lines.is_empty():
		if !_play_line(_lines.pop_front()):
			return
	SaveManager.end_event()

# PRIVATE MEMBERS #

func _emit_speech_finished() -> void:
	speech_finished.emit()

func _on_character_speech_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			speech_pressed.emit()

func _on_speech_pressed() -> void:
	if !%CharacterSpeech.text:
		return
	if _speech_tween and _speech_tween.is_running():
		_speech_tween.stop()
		%CharacterSpeech.visible_characters = %CharacterSpeech.text.length()
	else:
		play_next()

func _play_line(line: String) -> bool:
	var tokens : Array = line.split(" ", false)
	assert(tokens.size() > 0)
	return callv(tokens.pop_front(), tokens)

# EVENT FUNCTIONS #

func say(speech_code: String) -> bool:
	var line : String = tr("CharacterSpeech" + speech_code)
	var line_duration : float = 0.02 * line.length()
	%CharacterSpeech.text = line
	%CharacterSpeech.visible_characters = 0
	_speech_tween = create_tween()
	_speech_tween.tween_property(%CharacterSpeech, "visible_characters", line.length(), line_duration)
	#_speech_tween.tween_callback(_emit_speech_finished)
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

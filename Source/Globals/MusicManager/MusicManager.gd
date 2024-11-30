extends Node

# MEMBERS #

var volume_additional : float = 1.0 :
	set(volume_additional_):
		volume_additional = volume_additional_
		_refresh_volume_additional()
var volume_additional_previous : float = 1.0 :
	set(volume_additional_previous_):
		volume_additional_previous = volume_additional_previous_
		_refresh_volume_additional_previous()

var _audio_stream : AudioStreamPlayer
var _audio_stream_synchronized : AudioStreamSynchronized
var _audio_transition_tween_fade_in : Tween
var _audio_transition_tween_fade_out : Tween
var _current_stream_identifier : int = 0
var _previous_stream_identifier : int = 0
var _stream_identifiers : Dictionary

# METHODS #

func _ready() -> void:
	_audio_stream = %AudioStreamPlayer
	_audio_stream_synchronized = _audio_stream.stream
	_synchronize_audio_stream_synchronized()
	play()
	_audio_stream.play()

func play(stream: AudioStream = null) -> void:
	var stream_identifier : int = 0
	if stream:
		stream_identifier = _stream_identifiers.get(stream.resource_path, -1)
		assert(stream_identifier > 0)
	if stream_identifier != _current_stream_identifier:
		stop()
		if _audio_transition_tween_fade_in:
			_audio_transition_tween_fade_in.kill()
		_current_stream_identifier = stream_identifier
		volume_additional = 0.0
		_audio_transition_tween_fade_in = create_tween()
		_audio_transition_tween_fade_in.tween_property(self, "volume_additional", 1.0, 1.0)

func stop() -> void:
	if _current_stream_identifier > 0:
		if _audio_transition_tween_fade_out:
			_audio_transition_tween_fade_out.kill()
		_previous_stream_identifier = _current_stream_identifier
		_current_stream_identifier = 0
		volume_additional_previous = 1.0
		_audio_transition_tween_fade_out = create_tween()
		_audio_transition_tween_fade_out.tween_property(self, "volume_additional_previous", 0.0, 1.0)

# PRIVATE METHODS #

func _refresh_volume_additional() -> void:
	if _current_stream_identifier > 0:
		_set_stream_volume(_current_stream_identifier, volume_additional)

func _refresh_volume_additional_previous() -> void:
	if _previous_stream_identifier > 0:
		_set_stream_volume(_previous_stream_identifier, volume_additional_previous)

func _set_stream_volume(identifier: int, volume: float) -> void:
	_audio_stream_synchronized.set_sync_stream_volume(identifier, 60.0 * (volume - 1.0))

func _synchronize_audio_stream_synchronized() -> void:
	var stream : AudioStream
	for i in range(_audio_stream_synchronized.stream_count):
		if i > 0:
			stream = _audio_stream_synchronized.get_sync_stream(i)
			if stream:
				_stream_identifiers[stream.resource_path] = i
				_audio_stream_synchronized.set_sync_stream_volume(i, -60.0)

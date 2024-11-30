extends Node

# MEMBERS #

var volume_additional : float = 0.0 :
	set(volume_additional_):
		volume_additional = volume_additional_
		_refresh_volume_additional()

var _audio_stream : AudioStreamPlayer
var _audio_stream_synchronized : AudioStreamSynchronized
var _current_stream_identifier : int = 0
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
		_current_stream_identifier = stream_identifier
		_refresh_volume_additional()

func stop() -> void:
	if _current_stream_identifier > 0:
		_audio_stream_synchronized.set_sync_stream_volume(_current_stream_identifier, 0.0)
		_current_stream_identifier = 0

# PRIVATE METHODS #

func _refresh_volume_additional() -> void:
	if _current_stream_identifier > 0:
		_set_stream_volume(_current_stream_identifier, volume_additional)

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

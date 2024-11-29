extends Node

# MEMBERS #

var volume_additional : float = 0.0 :
	set(volume_additional_):
		volume_additional = volume_additional_
		_refresh_volume_additional()

var _audio_stream : AudioStreamPlayer
var _audio_stream_synchronized : AudioStreamSynchronized
var _stream_identifiers : Dictionary

# METHODS #

func _ready() -> void:
	var stream : AudioStream
	_audio_stream = %AudioStreamPlayer
	_audio_stream_synchronized = _audio_stream.stream
	for i in range(_audio_stream_synchronized.stream_count):
		stream = _audio_stream_synchronized.get_sync_stream(i)
		if stream:
			_stream_identifiers[stream.resource_path] = i
			if i > 0:
				_audio_stream_synchronized.set_sync_stream_volume(i, -60.0)
	_refresh_volume_additional()
	_audio_stream.play()

func _refresh_volume_additional() -> void:
	_audio_stream_synchronized.set_sync_stream_volume(1, 60.0 * (volume_additional - 1.0))

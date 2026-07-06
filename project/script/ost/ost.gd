extends Node

@export var is_overworld: bool = false
@onready var players: Array[AudioStreamPlayer] = [$a, $b]
@onready var tension: Node = $tension
@onready var mixer: Node = $mixer

const DURATION: float = 0.5

var current: int = 0
var player: AudioStreamPlayer:
	get: return players[current]

var _set_previous: Callable
var _get_record: Callable

func _set_level_type(previous: Callable, record: Callable) -> void:
	_set_previous = previous
	_get_record = record

func fade_track(that: AudioStreamPlayer) -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(that, "volume_db", -80.0, DURATION)
	tween.tween_property(players[_fade_next()], "volume_db", 0.0, DURATION)
	tween.tween_callback(func(): that.stop() ; _end_fade())

func _ready() -> void:
	if is_overworld:
		_set_level_type(_set_previous_world, func(): return mixer.record)
	else:
		_set_level_type(_set_previous_dungeon, func(): return mixer.record[tension.state])
	mixer.is_overworld = is_overworld
	mixer.ost.update.connect(set_tracks)
	tension.change_danger.connect(set_playback)

func set_tracks() -> void:
	mixer.set_tracks.call()
	next_playback(true)

func next_playback(finished: bool = false) -> void:
	mixer.next_track()
	set_playback(finished)

func load_music(track: String) -> void: player.load_music(track)

func _set_previous_dungeon() -> void:
	var previous = mixer.record[tension.previous_state] # FOR DUNGEON
	if not previous is Dictionary:
		mixer.record[tension.previous_state] = {
			"track": previous, "position": player.get_playback_position() }
	else:
		previous.position = player.get_playback_position()

func _set_previous_world() -> void: pass

func set_playback(finished: bool) -> void:
	_set_previous.call() # _set_previous_world()
	if not finished:
		
		_start_fade()
	else:
		_end_fade()

func _fade_next() -> int: return (current + 1) % players.size()
func _start_fade() -> void:
	if player.playing: fade_track(player)
	current = _fade_next()

func _end_fade() -> void:
	player.set_record_playback(_get_record.call())

func _finished() -> void:
	var record: Variant = _get_record.call()
	if record is Dictionary: record.position = 0.0
	next_playback(true)

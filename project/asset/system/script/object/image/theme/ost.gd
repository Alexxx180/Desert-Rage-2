extends Node

@onready var players: Array[AudioStreamPlayer] = [$a, $b]
@onready var tension: Node = $tension
@onready var mixer: Node = $mixer
@onready var fade: AnimationPlayer = $fade

var current: int = 0
var animation: Array[String] = ["fade_b", "fade_a"]
var record: Variant:
	get: return mixer.record#[tension.state]
var player: AudioStreamPlayer:
	get: return players[current]

func _ready() -> void:
	SoundtrackSystem.update.connect(set_tracks)
	tension.change_danger.connect(set_playback)

func set_tracks() -> void:
	# SoundtrackSystem.user.music.world.ambient.type.peace
	mixer.set_tracks(SoundtrackSystem.user.music.level.caves)
	next_playback(true)

func next_playback(finished: bool = false) -> void:
	mixer.next_track()
	set_playback(finished)

func load_music(track: String) -> void: player.load_music(track)

func _set_previous() -> void:
	# var previous = mixer.record[tension.previous_state] # FOR CAVES
	var previous = mixer.record
	if not previous is Dictionary:
		pass
		# mixer.record[tension.previous_state] = {
		#	"track": previous, "position": player.get_playback_position() }
	else:
		previous.position = player.get_playback_position()

func set_playback(finished: bool) -> void:
	_set_previous()
	if not finished:
		_start_fade()
	else:
		_end_fade()

func _fade_next() -> void:
	current = (current + 1) % animation.size()

func _start_fade() -> void:
	_fade_next()
	if not fade.is_playing():
		fade.play(animation[current])

func _end_fade() -> void:
	player.set_record_playback(record)

func _finished() -> void:
	if record is Dictionary: record.position = 0.0
	next_playback(true)

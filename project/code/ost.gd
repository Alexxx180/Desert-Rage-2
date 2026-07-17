class_name SoundtrackSystem extends RefCounted

signal update()

# var _ui: SoundtrackUI
# var ui: SoundtrackUI:
	# get: return Def.ref(self, _ui, &"_ui", new_soundtrack_ui)
var _json: Dictionary = {
	"COPY": "res://asset/resource/media/ost/%s.json",
	"USER": "user://%s.json"
}
# func new_soundtrack_ui() -> SoundtrackUI: return SoundtrackUI.new()

var save: bool = false
var _copy: Dictionary = { "music": {} }
var _user: Dictionary
var user: Dictionary:
	get: return _user
var copy: Dictionary:
	get: return _copy

var _valid: Dictionary = {
	"music": { "copy": false, "user": false }
}

func is_valid(type: String) -> bool:
	return _valid[type].copy and _valid[type].user

func update_ost() -> void: update.emit()

func get_file(metadata: Dictionary) -> bool:
	metadata.track = "F:/media/ost/music/songs/group/english/p-t/t/Three_Days_Grace_-_I_Hate_Everything_About_You_47958582.mp3"
	return true

func get_value(ui: Dictionary, keys: Array) -> Dictionary:
	var context: Dictionary = { "ui": ui, "ost": user["music"] }
	for key in keys:
		context.ost = context.ost[key]
		context.ui = context.ui[key]
	return context

func _ready() -> void: reimport()

func reset() -> void: _init_vault("music", true)

func reimport() -> void: _init_vault("music")

func _set_vault(from: String, to: String, force: bool = false) -> void:
	Vault.copy(from, to, force)
	_copy.music = Vault.get_json(from, func(s): _valid.music.copy = s)
	_user.music = Vault.get_json(to, func(s): _valid.music.user = s)

func _init_vault(type: String, force: bool = false) -> void:
	_set_vault(_json.COPY % type, _json.USER % type, force)

func _save_manifest(type: String) -> void:
	Vault.set_json(_json.USER % type, _user[type])

func save_changes() -> void:
	if save:
		update_ost()
		_save_manifest("music")
	save = false

func _exit_tree() -> void:
	save_changes()




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





var caption: String = "origin"
var i: int = 0
var music: Array
var _mixed: bool = false
var set_tracks: Callable

var record: Variant:
	get: return music[i]
var ost: SoundtrackSystem
var is_overworld: bool:
	set(value):
		set_tracks = set_world_tracks if value else set_dungeon_tracks

func _set_number(tracks: Dictionary) -> void:
	i = tracks.at if tracks.has("at") else 0

func set_track(track: Dictionary) -> void:
	music = track.set
	_set_number(track)

func _has_level(_ost: Dictionary) -> bool:
	return _ost.name.has(caption) and _ost.name[caption].mix
# func set_tracks(ost: Dictionary) -> void: pass

func set_world_tracks() -> void:
	set_track(ost.user.music.world.ambient.type)
	# _mixed = ost.type.theme.mix

func set_dungeon_tracks() -> void:
	var _ost: Dictionary = ost.user.music.level.caves
	_mixed = _ost.type.theme.mix
	if _has_level(_ost):
		set_track(_ost.name[caption])
	else:
		set_track(_ost.type.theme)

func next_track() -> void:
	i = (i + 1) % music.size()



func stop_timing() -> void: pass
func start_timing() -> void:
	var paused: bool = stream_paused
	stop()
	_load_music()
	if paused: stream_paused = true

func set_record_playback(record: Variant) -> void:
	if record is Dictionary:
		load_music(record.track)
		seek(record.position)
	else:
		load_music(record)






signal change_danger(finished: bool)

@onready var reorder: Timer = $reorder

var environment: Array[String] = ["ambient", "heating", "rampage"]
var _enemies: int = 0
var _adjust: Vector2i = Vector2.ZERO
var _selection: int = 0
var _previous: int = _selection
var _spawn: bool = false

var previous_state: String:
	get: return environment[_previous]
var state: String:
	get: return environment[_selection]

func _ready() -> void: timeout.connect(sync_enemy_music)

func add_enemy(_body) -> void:
	_adjust.x += 1
	reorder.start()
	#match_enemy()

func drop_enemy(_body) -> void:
	_adjust.y += 1
	reorder.start()
	#match_enemy()

func sync_enemy_music() -> void:
	var delta: int = _adjust.x - _adjust.y
	_enemies += delta
	_adjust = Vector2.ZERO
	if delta != 0:
		match_enemy()

func add_spawn(_body) -> void: _spawn = true
func drop_spawn(_body) -> void: _spawn = false

func match_enemy() -> void:
	_previous = _selection
	match _enemies:
		0: _selection = 0
		1, 2:
			if _selection != 2:
				_selection = 1
		_: _selection = 2 if _spawn else 1
	if _selection != _previous:
		change_danger.emit(false)

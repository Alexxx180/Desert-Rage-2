extends Node

const COMBAT: Dictionary = { "ambient": 0, "heating": 1, "rampage": 2, "absent": 3 }

func from_set(entry: Dictionary, key: Variant) -> Variant: return entry.theme.set[key]
func from_theme(entry: Dictionary, key: Variant) -> Variant: return entry.theme[key]

func no(ui) -> int: return ui.i
func name(ui) -> String: return ui.event.name

func form(status: String, key: Variant, track: String) -> Dictionary:
	var form: Dictionary = { "caption": status, "track": track }
	if key is String: form.name = key
	return key

func play_entry(board: BehaviorBlackboard, entry: Dictionary, ui: Control) -> void:
	entry.play.call(board, ui)

func select_entry(board: BehaviorBlackboard, entry: Dictionary, ui: Control) -> void:
	entry.theme.at = ui.i
	play_entry(board, entry, ui)

func an_entry(op: String, entry: Dictionary, ui: Control) -> void:
	get(op + "entry").call(entry, ui)

func an_ost(ost: Variant) -> String:
	return ost.track if ost is Dictionary else ost

func a_status(metadata: Dictionary) -> String:
	if not metadata.has("name"): return metadata.caption
	else: return metadata.name + " - " + metadata.caption

func get_status(player: AudioStreamPlayer, track: String, status: String) -> String:
	match player.load_music(track):
		OK: return status
		FAILED: return track + "? " + tr("MISS") + ": " + status
	return track + " ≠ .mp3, .ogg: " + status

func set_rampage(board: BehaviorBlackboard, status: String) -> void:
	var rampage: int = COMBAT.absent
	if COMBAT.has(status): rampage = COMBAT[status]
	board.set_value("level_rampage", rampage)

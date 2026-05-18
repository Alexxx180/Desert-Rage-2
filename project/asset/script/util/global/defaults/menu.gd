class_name Menu extends RefCounted

enum { PAUSE, GAME }

var state: int

var navigation: Array

func is_hud_opened() -> bool:
	var result: bool = true
	for n in navigation:
		var last: bool = n.hud.logic.is_opened_last
		result = result and (not last)
	return not result

func connect_menu(node: Control) -> void:
	match node.name:
		"game": game_connect()
		"pause": pause_connect(node.options)
		"saves": saves_connect()
		"sound": sound_connect()
		"settings": settings_connect()

func game_connect() -> void: pass
func settings_connect() -> void:
	HUD.settings.back.connect(_resume_level)
	HUD.settings.sound.connect(sound_show)

func saves_connect() -> void:
	HUD.saves.back.connect(_resume_level)
	
func sound_connect() -> void:
	HUD.sound.back.connect(sound_back)
	
func pause_connect(options: VBoxContainer) -> void:
	options.resume.connect(pause_resume)
	options.saves.connect(func(): toggle_menu(HUD.saves))
	options.settings.connect(func(): toggle_menu(HUD.settings))
	options.main.connect()

func sound_show() -> void: _sound_level(false, Node.PROCESS_MODE_INHERIT)
func sound_back() -> void: _sound_level(true, Node.PROCESS_MODE_DISABLED)

func _sound_level(pause: bool, mode: Node.ProcessMode) -> void:
	HUD.sound.visible = !pause
	if PAUSE:
		HUD.settings.visible = pause
	else:
		set_level_mode(mode)

func _pause_level(pause: bool, mode: Node.ProcessMode) -> void:
	if PAUSE:
		HUD.pause.visible = pause
	else:
		set_level_mode(mode)

func _resume_level() -> void:
	HUD.level.show()
	HUD.game.show()
	_pause_level(true, Node.PROCESS_MODE_INHERIT)

func toggle_menu(menu: Control) -> void:
	menu.show()
	HUD.level.hide()
	_pause_level(false, Node.PROCESS_MODE_DISABLED)

func main_menu() -> void:
	HUD.pause.hide()
	HUD.stats.tree.change_scene_to_file(Def.main_menu)

func pause_set() -> void: _pause_toggle(true, Node.PROCESS_MODE_DISABLED)
func pause_resume() -> void: _pause_toggle(false, Node.PROCESS_MODE_INHERIT)
func _pause_toggle(next: bool, mode: Node.ProcessMode) -> void:
	HUD.pause.visible = next
	set_level_mode(mode)

func set_level_mode(mode: Node.ProcessMode) -> void: HUD.level.process_mode = mode

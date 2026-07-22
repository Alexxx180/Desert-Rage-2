extends CanvasLayer

var state: int = 0
var hero: int = 0
var _preserves: Preserves ; var _aura: AuraResource ; var _animation: CharacterAnimation
var levels: LevelRoot ; var _interact: WorldInteraction
#var _inventory: HeroInventory ;

# @onready var ost: SoundtrackSystem = SoundtrackSystem.new()
# @onready var stats: SessionStats = SessionStats.new(get_tree())

var menu: Menu = Menu.new()

# var inventory: HeroInventory:
# 	get: return Def.ref(self, _inventory, &"_inventory", new_hero_inventory)
var interact: WorldInteraction:
	get: return Def.ref(self, _interact, &"_interact", new_interaction)
var preserves: Preserves:
	get: return Def.ref(self, _preserves, &"_preserves", new_preserve)
var aura: AuraResource:
	get: return Def.ref(self, _aura, &"_aura", new_aura_resource)
var animation: CharacterAnimation:
	get: return Def.ref(self, _animation, &"_animation", new_character_animation)

var level: Node2D
var world: WorldInput = WorldInput.new()

func new_interaction() -> WorldInteraction: return WorldInteraction.new()
func new_menu() -> Menu: return Menu.new()
func new_character_animation() -> CharacterAnimation: return CharacterAnimation.new()
# func new_hero_inventory() -> HeroInventory: return HeroInventory.new()
func new_preserve() -> Preserves: return Preserves.new()
func new_world_input() -> WorldInput: return WorldInput.new()
func new_aura_resource() -> AuraResource: return AuraResource.new()

func next() -> int: return (HUD.hero + 1) & Def.ROCK
func _ready() -> void: layer = 2 # TODO
func _input(event: InputEvent) -> void:
	if HUD.level != null:
		world.input(event)

"""


var xp: RefCounted
var tree: SceneTree
var level: String:
	get: return Def.level % [location.name, group_level(), location.part]

var location: Dictionary = {
	"name": "cave/origin",
	"level": 0, "part": 0,
	"save": false
}
var progress: PackedInt32Array

func _init(t: SceneTree) -> void: tree = t

func assign(path: String) -> void:
	var i: int = path.find("-", 1)
	location.level = int(path.substr(0, i))
	location.part = int(path.substr(i + 1))
	location.save = true
	print("Session stats assign: ", location)

func _file(access: FileAccess.ModeFlags) -> FileAccess:
	return FileAccess.open(Def.progress, access)

func load_scene(scene: String) -> void:
	print_debug(tree.change_scene_to_file(scene))

func save_progress() -> void:
	if location.save:
		_file(FileAccess.WRITE).store_string(JSON.stringify(location))

func group_level(diff: int = 0) -> String:
	var _level: int = location.level + diff
	var path: String = "%d"
	if _level > 0: path = "+/%d"
	elif _level < 0: path = "-/%d"
	return path % abs(_level)

func _parseable(text: String) -> bool:
	var processor: JSON = JSON.new()
	var parsed: bool = processor.parse(text) == OK
	if parsed:
		location = processor.data
		location.save = false
		load_scene(level)
	return parsed

func load_progress() -> bool:
	var exist: bool = FileAccess.file_exists(Def.progress)
	return exist and _parseable(_file(FileAccess.READ).get_as_text())

func _ready() -> void:
	pass
	#var options: VBoxContainer = get_node("../hud/back/options")
	#options.continue.pressed.connect()
	#options.start.pressed.connect(game_start)

func game_exit() -> void: tree.quit()
func game_start() -> void: load_scene(Def.first_level)
func game_continue() -> void: if not load_progress(): load_scene(Def.first_level)




static func copy(from: String, to: String, force: bool = false) -> void:
	var dir: DirAccess = DirAccess.open("user://")
	print("COPY FROM? ", from)
	if force:
		print("FORCE DELETE: ", to, " = ", dir.remove(to))
	if not dir.file_exists(to):
		print("COPY! ", to, " = ", dir.copy(from, to))

static func _parse_json(path: String) -> Dictionary:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var text: String = file.get_as_text()
	var processor: JSON = JSON.new()
	return { "json": processor, "result": processor.parse(text) == OK }

static func get_json(path: String, feedback: Callable) -> Dictionary:
	if not FileAccess.file_exists(path): return {}

	var parsed: Dictionary = _parse_json(path)
	if not parsed.result: return {}
	
	feedback.call(true)
	return parsed.json.data

static func set_json(path: String, value: Dictionary) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	var json: String = JSON.stringify(value)
	file.store_string(json)
"""

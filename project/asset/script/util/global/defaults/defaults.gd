extends CanvasLayer

enum { OPEN_MENU, TRANSIT }

@export_group("Session Logic")
@onready var TEXTURE := PlaceholderTexture2D.new()
@onready var ost: SoundtrackSystem = SoundtrackSystem.new()
@onready var stats: SessionStats = SessionStats.new(get_tree())

var REF: Dictionary = {}

var state: int = 1
var hero: int = 0
var _pause: Control ; var _game: Control ; var _settings: Control ; var _sound: Control ; var _information: Control
var _status: GameStatuses ; var _menu: Menu ; var _preserves: Preserves ; var _aura: AuraResource
var _skills: SkillManager ; var _pillar: PillarChains ; var _deploy: HeroDeploy

func create_menu(node: Control, path: StringName, caption: StringName) -> Control:
	return node if node != null else menu.connect_menu(Def.lazy(self, node, path, caption))

var game: Control:
	get: return create_menu(_game, Def.game, &"_game")
var pause: Control:
	get: return create_menu(_pause, Def.pause, &"_pause")
var settings: Control:
	get: return create_menu(_settings, Def.settings, &"_settings")
var information: Control:
	get: return create_menu(_information, Def.information, &"_information")
var sound: Control:
	get: return create_menu(_sound, Def.sound, &"_sound")
var menu: Menu:
	get: return Def.ref(self, _menu, &"_menu", new_menu)

var preserves: Preserves:
	get: return Def.ref(self, _preserves, &"_preserves", new_preserve)
var skills: SkillManager:
	get: return Def.ref(self, _skills, &"_skills", new_skills)
var status: GameStatuses:
	get: return Def.ref(self, _status, &"_status", new_game_statuses)
var aura: AuraResource:
	get: return Def.ref(self, _aura, &"_aura", new_aura_resource)
var pillar: PillarChains:
	get: return Def.ref(self, _pillar, &"_pillar", new_pillar_chains)
var deploy: HeroDeploy:
	get: return Def.ref(self, _deploy, &"_deploy", new_hero_deploy)

var level: Node2D
var _world: WorldInput = WorldInput.new()

func new_menu() -> Menu: return Menu.new()
func new_preserve() -> Preserves: return Preserves.new()
func new_skills() -> SkillManager: return SkillManager.new()
func new_world_input() -> WorldInput: return WorldInput.new()
func new_game_statuses() -> GameStatuses: return GameStatuses.new()
func new_aura_resource() -> AuraResource: return AuraResource.new()
func new_pillar_chains() -> PillarChains: return PillarChains.new()
func new_hero_deploy() -> HeroDeploy: return HeroDeploy.new()

func _ready() -> void: layer = 2 # TODO
func _input(event: InputEvent) -> void: _world.input(event)

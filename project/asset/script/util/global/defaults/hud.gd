extends CanvasLayer

@onready var ost: SoundtrackSystem = SoundtrackSystem.new()
@onready var stats: SessionStats = SessionStats.new(get_tree())

var state: int = 0
var hero: int = 0
var _pause: Control ; var _game: Control ; var _settings: Control ; var _sound: Control ; var _information: Control
var _status: GameStatuses ; var _menu: Menu ; var _preserves: Preserves ; var _aura: AuraResource
var _animation: CharacterAnimation ; # var _inventory: HeroInventory ;
var levels: LevelRoot ; var _interact: WorldInteraction
func create_menu(node: Control, path: StringName, caption: StringName) -> Control:
	return node if node != null else menu.connect_menu(Def.lazy(self, node, path, caption))

var game: Control:
	get: return create_menu(_game, Def.game, &"_game")
var pause: Control:
	get: return create_menu(_pause, Def.pause, &"_pause")
"""
var settings: Control:
	get: return create_menu(_settings, Def.settings, &"_settings")
var information: Control:
	get: return create_menu(_information, Def.information, &"_information")
var sound: Control:
	get: return create_menu(_sound, Def.sound, &"_sound")
"""
var menu: Menu:
	get: return Def.ref(self, _menu, &"_menu", new_menu)

# var inventory: HeroInventory:
# 	get: return Def.ref(self, _inventory, &"_inventory", new_hero_inventory)
var interact: WorldInteraction:
	get: return Def.ref(self, _interact, &"_interact", new_interaction)
var preserves: Preserves:
	get: return Def.ref(self, _preserves, &"_preserves", new_preserve)
var status: GameStatuses:
	get: return Def.ref(self, _status, &"_status", new_game_statuses)
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
func new_game_statuses() -> GameStatuses: return GameStatuses.new()
func new_aura_resource() -> AuraResource: return AuraResource.new()

func next() -> int: return (HUD.hero + 1) & Def.ROCK
func _ready() -> void: layer = 2 # TODO
func _input(event: InputEvent) -> void: world.input(event)

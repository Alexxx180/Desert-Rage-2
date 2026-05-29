extends CanvasLayer

@export_group("Runtime Constants")
@onready var NODE: Node = Node.new()
@onready var ENTITY := CharacterBody2D.new()
@onready var STATIC := StaticBody2D.new()
@onready var TEXTURE := PlaceholderTexture2D.new()
@export_group("Session Logic")
@onready var ost: SoundtrackSystem = SoundtrackSystem.new()
@onready var stats: SessionStats = SessionStats.new(get_tree())

var REF: Dictionary = {}

var game: Control:
	get: return Works.uploads(self, Def.game % "game", "game", REF, menu.connect_menu)
var pause: Control:
	get: return Works.uploads(self, Def.pause, "pause", REF, menu.connect_menu)
var settings: Control:
	get: return Works.uploads(self, Def.settings, "settings", REF, menu.connect_menu)
var information: Control:
	get: return Works.uploads(self, Def.information, "information", REF, menu.connect_menu)
var sound: Control:
	get: return Works.uploads(self, Def.sound, "sound", REF, menu.connect_menu)
var menu: Menu:
	get: return Works.loads("preserve", REF, new_menu)
var input: WorldInput:
	get: return Works.loads("input", REF, new_world_input)

var preserve: Preserves:
	get: return Works.loads("preserve", REF, new_preserve)
var skills: SkillManager:
	get: return Works.loads("skills", REF, new_skills)
var status: GameStatuses:
	get: return Works.loads("status", REF, new_game_statuses)
var aura: AuraResource:
	get: return Works.loads("status", REF, new_aura_resource)
var pillar: PillarChains:
	get: return Works.loads("pillar", REF, new_pillar_chains)
var deploy: HeroDeploy:
	get: return Works.loads("pillar", REF, new_hero_deploy)

var _level: Node2D
var level: Node2D:
	set(next): _level = next; _level.setup()

func new_preserve() -> Preserves: return Preserves.new()
func new_skills() -> SkillManager: return SkillManager.new()
func new_menu() -> Menu: return Menu.new()
func new_world_input() -> WorldInput: return WorldInput.new()
func new_game_statuses() -> GameStatuses: return GameStatuses.new()
func new_aura_resource() -> AuraResource: return AuraResource.new()
func new_pillar_chains() -> PillarChains: return PillarChains.new()
func new_hero_deploy() -> HeroDeploy: return HeroDeploy.new()

func _ready() -> void: layer = 2 # TODO


func _continue_process() -> int: return FAILED

func check_combo(mark: Tick, slots: Array) -> bool:
	return mark.blackboard.g(slots[0]).released

func fight_combo(mark: Tick) -> Node:
	var tools: Dictionary = mark.blackboard.g("tools")
	var combo: Node = tools.hero.view.animation.moves.combo
	combo.start_fight("active")
	return combo

func tick(mark: Tick, act: BehaviorAction) -> int:
	if check_combo(mark, act.get_metadata()):
		# print("GOT A COMBO!")
		act.take_effect(mark)
		return _continue_process()
	return FAILED

func x1(mark: Tick) -> void:
	mark.blackboard.g("group").xp.level.multiply.hit()
	# return self

func notify(mark: Tick, caption: String) -> void:
	# mark.blackboard.get_value("ui").set_slot_combo(caption)
	var tools: Dictionary = mark.blackboard.g("tools")
	var hero: CharacterBody2D = tools.hero
	if tools.combos == null:
		var size: int = mark.blackboard.g("combo").query.size()
		# if not mark.actor.combo.prefers(size): return TODO FIXME uncomment after settings fully implemented
		var combo: Label = mark.actor.combos.instantiate()
		combo.tools = tools
		hero.group.lay.execute.layer.add_child(combo)
		tools.combos = combo
	tools.combos.text = caption
	tools.combos.position = hero.position - Vector2(300, 160) # x = 120


func _body(text: String, no: int, type: String = "hands") -> void:
	var mark: Tick
	basis.fight_combo(mark).fight_body(type).x(mark, no).notify(mark, text)

var basis: ComboBasis = ComboBasis.new()

func get_metadata() -> Array[int]:
	var p: int = Skills.PUNCH
	var k: int = Skills.KICK
	return [k, p, p]

func take_effect(mark: Tick) -> void:
	# HUD.xp.level.multiply.by_slots(slots) # mark.blackboard.g("group")
	
	basis.x(mark, Skills.TRIPLE).vfx_hint(mark, mark.actor.kick)

	basis.notify(mark, "Выпад")

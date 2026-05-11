class_name Def

const DIRECTION: Vector2i = Vector2i(24, 20)
const VECTI: Vector2i = Vector2i(-1, -1)
const ARRAY: Array = []
const BYTE: PackedByteArray = []
const DICT: Dictionary = {}
const INT: int = -1

static func FUNC(): pass
static func among(from: float, x: float, to: float) -> bool: return (from <= x) and (x <= to)
static func vec2() -> Array: return [Vector2.AXIS_X, Vector2.AXIS_Y]
static func vec2i(axis: int) -> Vector2i: return Vector2i(axis, axis)
static func truth(_empty: Object) -> bool: return true # combined with implicit func for readability
static func entity(o: CharacterBody2D) -> bool: return o == HUD.ENTITY
static func ic(text: String, result: Variant) -> Variant: print(text % result) ; return result
static func ics(text: String, state: Array = Def.ARRAY) -> Variant: print(text % state) ; return state[0]
# LOADS
const first_level: String = "res://now/dungeon/cave/origin/0/0/level.tscn"
const level: String = "res://now/dungeon/%s/%s/%d/level.tscn"
const main_menu: String = "res://now/credits/main/main.tscn"
const fight: String = "res://now/see/fight.tscn"
const ground: String = "res://now/see/ground.tscn"
const whip: String = "res://now/see/whip.tscn"
const pull: String = "res://now/see/ledges.tscn"
const ledges: String = "res://now/see/ledges.tscn"
const health: String = "res://now/work/health/%s.tscn"
const ability: String = "res://now/work/lockers/ability/%s.tscn"
const activator: String = "res://now/work/lockers/ability/%s.tscn"
const music: String = "res://now/work/music.tscn" # const hero: String = "res://now/work/hero/%s/%s.tscn"
const hero: String = "res://now/work/hero/%s/%s.tscn"
const ray: String = "res://now/work/hero/ray/ray.tscn"
const rock: String = "res://now/work/hero/rock/rock.tscn"
const group: String = "res://now/work/group/%s.tscn"
const hud: String = "res://now/hud/%s.tscn"
const credits: String = "res://now/credits.tscn"
const settings: String = "res://now/settings.tscn"
const sound: String = "res://now/sound.tscn"
const information: String = "res://now/information.tscn"
const pause: String = "res://now/hud/status/pause.tscn"
const slots: String = "res://now/hud/status/slots.tscn"
const enemy: String = "res://now/hud/status/enemy.tscn"
const hints: String = "res://now/hud/hints/%s.tscn"
const hp: String = "res://now/hud/markers/health.tscn"
const items: String = "res://now/hud/markers/items.tscn"
const actions: String = "res://now/work/hero/actions/%s.tscn"
const xp: String = "res://now/hud/status/xp.tscn"
const hits: String = "res://now/hud/status/hits.tscn"
const game: String = "res://now/hud/game/%s.tscn"
const mirror: String = "res://now/see/mirror/%s.tscn"
const input: String = "res://now/work/hero/%s/%s.tscn"
const world: String = "res://now/work/hero/world/%s.tscn"
const progress: String = "user://progress.txt"
# PRELOADS
const rain: PackedScene = preload("res://pre/particle/rain/rain.tscn")
const sand: PackedScene = preload("res://pre/particle/sand.tscn")
const fire: PackedScene = preload("res://pre/particle/fire/fire.tscn")
const kick: PackedScene = preload("res://pre/particle/fight/kick.tscn")
const punch: PackedScene = preload("res://pre/particle/fight/punch.tscn")

const dialog: PackedScene = preload("res://pre/ui/dialog.tscn")
const combo: PackedScene = preload("res://pre/ui/combo.tscn")
const chat: PackedScene = preload("res://pre/ui/log/chat.tscn")
const item: PackedScene = preload("res://pre/ui/log/item.tscn")
const levels: PackedScene = preload("res://pre/ui/log/levels.tscn")
const multiply: PackedScene = preload("res://pre/multiply.tscn")

const ailments: PackedScene = preload("res://pre/ui/status/ailments.tscn")
const stats: PackedScene = preload("res://pre/ui/status/stats.tscn")
const bag: PackedScene = preload("res://pre/ui/status/items.tscn")
const chats: PackedScene = preload("res://pre/ui/menu/chat.tscn")
const priorities: PackedScene = preload("res://pre/ui/menu/priorities.tscn")

const grabber: GradientTexture2D = preload("res://pre/ui/grabber.tres")
const root: Script = preload("res://pre/level.gd")
const master: MasterManifest = preload("res://asset/resource/media/stats/master.tres")

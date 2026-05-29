class_name Def

enum { JUMP = 200000, SINGULARITY = 45000, GRAVITY = 700000 } # JUMP = -75000, GRAVITY = 375000 / 150 - 750
enum { HERO, BOX }
enum { STANDING, LAYER, PERSPECTIVE, ACTING, GRAB }
enum { DEAD, FREEZE }

enum { ALT1, ALT2, ALT3, ALT4, EXECUTE = 0, TRANSPORT = 3, MAX4 = 16, MAX8 = 64,
	BOOKS = 2, HOOKS = 4, LOGIC = 7, TRANSITION = 8, CHATS = 6, CHEST = 9 } # LAYER ID

enum { BLUE_OFF, BLUE_ON, RED_OFF, RED_ON, GREEN_OFF, GREEN_ON, WHITE_OFF, WHITE_ON, BLACK_OFF, BLACK_ON,
	BRONZE_OFF, BRONZE_ON, SILVER_OFF, SILVER_ON, GOLD_OFF, GOLD_ON, PLATINUM_OFF, PLATINUM_ON, PLACE, TELEPORT_ON,
	SOURCE_OFF, SOURCE_ON, LEVER_OFF, LEVER_ON, PLATE_OFF, PLATE_ON, TELEPORT_OFF, SPIKER, COMFORTER, SUPPLIER,
	COOLER, SMALL_BOX, FIRE_BOX, LARGE_BOX }

enum { U_LADDER, U_ENTRY, U_WALL_OFF, U_WALL_ON, D_LADDER, D_ENTRY, D_WALL_OFF, D_WALL_ON, STAND_OFF, STAND_ON, DESCENT, EXIT,
	WATER_UP, WATER, WATER_DOWN }

enum { POST_UP, BOSS, ICE, THICK_ICE, POST, ENEMY, PUDDLE_OFF, PUDDLE_ON, SPRING_OFF, SPRING_ON, LOAD_OFF, LOAD_ON, PAGE }

enum { HINTS, BOOK, PAGES, ENEMIES }
enum { RAY, ROCK, EYE_SEEKER }

const manual: PackedByteArray = [1, 3, 7, 10, 20, 21] ## Hints count shown
const levels: PackedByteArray = [1, 7, 9, 13, 25, 26] ## Level number

const step: PackedByteArray = [28, 28, 15, 15]
const push: PackedByteArray = [14, 20, 20, 20]

const hp: PackedByteArray = [100, 100, 93, 93]
const ap: PackedByteArray = [ 20,  20,  2,  2]

const power: PackedByteArray = [5, 5, 5, 5]
const defen: PackedByteArray = [5, 5, 5, 5]
const influ: PackedByteArray = [5, 5, 5, 5]
const react: PackedByteArray = [5, 5, 5, 5]

const hints: PackedStringArray = ["MM", "MJ", "MB", "ML", "CN", "AA", "AE", "AF", "AT",
	"SR", "AW", "AH", "AM", "RG", "RM", "BY", "BK", "RG", "FG", "LO", "IM", "LG", "AY",
	"CM", "CF", "IM", "EN", "PS", "RS", "ST", "BOOKS_STRING-ENEMY_STRING"]

static func to(field: int, off: int) -> Vector2i: return Vector2i(field & (2 << off), field >> off)
static func to8(field: int) -> Vector2i: return to(field, 3)
static func to4(field: int) -> Vector2i: return to(field, 2)

static func from(pos: Vector2i, off: int) -> int: return (pos.y << off) | pos.x
static func from8(pos: Vector2i) -> int: return from(pos, 3)
static func from4(pos: Vector2i) -> int: return from(pos, 2)

const DIR: PackedVector2Array = [Vector2i(24, 20), Vector2i(-1, -1)]
const ARRAY: Array = []
const DICT: Dictionary = {}
const INT: int = -1

static func FUNC(): pass
static func among(a: float, x: float, b: float) -> bool: return (a <= x) and (x <= b)
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
const hint: String = "res://now/hud/hints/%s.tscn"
const mhealth: String = "res://now/hud/markers/health.tscn"
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
const loglevels: PackedScene = preload("res://pre/ui/log/levels.tscn")
const multiply: PackedScene = preload("res://pre/multiply.tscn")
const ailments: PackedScene = preload("res://pre/ui/status/ailments.tscn")
const stats: PackedScene = preload("res://pre/ui/status/stats.tscn")
const bag: PackedScene = preload("res://pre/ui/status/items.tscn")
const chats: PackedScene = preload("res://pre/ui/menu/chat.tscn")
const priorities: PackedScene = preload("res://pre/ui/menu/priorities.tscn")

const grabber: GradientTexture2D = preload("res://pre/ui/grabber.tres")
const root: Script = preload("res://pre/level.gd")
const master: MasterManifest = preload("res://asset/resource/media/stats/master.tres")

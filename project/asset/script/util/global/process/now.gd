class_name Def

enum { LOGIC = 0, FLOOR0 = 0, FLOOR4 = 4, FLOOR = 4, PUDDLE_OFF0 = 4, PUDDLE_OFF4 = 8,
	PUDDLE_ON0 = 8, PUDDLE_ON4 = 12, ICE_FLOOR0 = 12, ICE_FLOOR4 = 16,
	BLUE_OFF = 0, U_WATER = 0, BLUE_ON, U_EXIT = 1, RED_OFF, U_WALL_OFF = 2, RED_ON,
	U_WALL_ON = 3, ENTRY = 3, WALL = 3, GREEN_OFF, U_LADDER = 4, GREEN_ON, D_LADDER = 5,
	WHITE_OFF, ENEMY = 6, WHITE_ON, BOSS = 7, BLACK_OFF, M_WATER = 8,
	TAGS = 8, BLACK_ON, M_EXIT = 9, CHESTS = 9, BRONZE_OFF, D_WALL_OFF = 10, BRONZE_ON,
	D_WALL_ON = 11, SILVER_OFF, H_SPRING_OFF = 12, SILVER_ON, H_SPRING_ON = 13, GOLD_OFF,
	B_SPRING_OFF = 14, GOLD_ON, B_SPRING_ON = 15, PLATINUM_OFF, D_WATER = 16, PLATINUM_ON,
	D_EXIT = 17, PLACE, SLIDE = 18, TELEPORT_ON, PILLAR = 19, SOURCE_OFF, STAND_OFF = 20,
	SOURCE_ON, STAND_ON = 21, LEVER_OFF, SECRET_OFF = 22, LEVER_ON, SECRET_ON = 23, PLATE_OFF,
	PAGE = 24, PLATE_ON, TELEPORT_OFF, SPIKER, COMFORTER, SUPPLIER, COOLER, SMALL_BOX, FIRE_BOX, LARGE_BOX }

enum { INT = -1, HERO, DEPLOYED = 0, TILE = 0, DEAD, OVERWORLD = 1, ID = 1, FREEZE,
	CASUAL = 2, ALT = 2, BOX, TYPE = 3, LAYER, COORDS = 4, PERSPECTIVE, ACTING, GRAB, CAMERA,
	TILESET4 = 16, TILE32 = 32, TILE48 = 48, TILESET8 = 64,
	DEPLOY_DELTA = 4096, JUMP = 200000, SINGULARITY = 45000, GRAVITY = 700000 }

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

const DIR: PackedVector2Array = [Vector2i(24, 20), Vector2i(-1, -1)]

static func to(field: int, off: int) -> Vector2i: return Vector2i(field & (2 << off), field >> off)
static func to256(field: int) -> Vector2i: return to(field, 8)
static func to8(field: int) -> Vector2i: return to(field, 3)
static func to4(field: int) -> Vector2i: return to(field, 2)

static func from(pos: Vector2i, off: int) -> int: return (pos.y << off) | pos.x
static func from256(pos: Vector2i) -> int: return from(pos, 8)
static func from8(pos: Vector2i) -> int: return from(pos, 3)
static func from4(pos: Vector2i) -> int: return from(pos, 2)

static func FUNC(): pass
static func among(a: float, x: float, b: float) -> bool: return (a <= x) and (x <= b)
# LOADS
const first_level: StringName = &"res://now/dungeon/cave/origin/0/0/level.tscn"
const level: StringName = &"res://now/dungeon/%s/%s/%d/level.tscn"
const main_menu: StringName = &"res://now/credits/main/main.tscn"
const fight: StringName = &"res://now/see/fight.tscn"
const ground: StringName = &"res://now/see/ground.tscn"
const whip: StringName = &"res://now/see/whip.tscn"
const pull: StringName = &"res://now/see/ledges.tscn"
const ledges: StringName = &"res://now/see/ledges.tscn"
const health: StringName = &"res://now/work/health/%s.tscn"
const ability: StringName = &"res://now/work/lockers/ability/%s.tscn"
const activator: StringName = &"res://now/work/lockers/ability/%s.tscn"
const music: StringName = &"res://now/work/music.tscn" # const hero: StringName = &"res://now/work/hero/%s/%s.tscn"
const hero: StringName = &"res://now/work/hero/%s/%s.tscn"
const ray: StringName = &"res://now/work/hero/ray/ray.tscn"
const rock: StringName = &"res://now/work/hero/rock/rock.tscn"
const group: StringName = &"res://now/work/group/%s.tscn"
const hud: StringName = &"res://now/hud/%s.tscn"
const credits: StringName = &"res://now/credits.tscn"
const settings: StringName = &"res://now/settings.tscn"
const sound: StringName = &"res://now/sound.tscn"
const information: StringName = &"res://now/information.tscn"
const pause: StringName = &"res://now/hud/status/pause.tscn"
const slots: StringName = &"res://now/hud/status/slots.tscn"
const enemy: StringName = &"res://now/hud/status/enemy.tscn"
const hint: StringName = &"res://now/hud/hints/%s.tscn"
const mhealth: StringName = &"res://now/hud/markers/health.tscn"
const items: StringName = &"res://now/hud/markers/items.tscn"
const actions: StringName = &"res://now/work/hero/actions/%s.tscn"
const xp: StringName = &"res://now/hud/status/xp.tscn"
const hits: StringName = &"res://now/hud/status/hits.tscn"
const game: StringName = &"res://now/hud/game/%s.tscn"
const mirror: StringName = &"res://now/see/mirror/%s.tscn"
const input: StringName = &"res://now/work/hero/%s/%s.tscn"
const world: StringName = &"res://now/work/hero/world/%s.tscn"
const progress: StringName = &"user://progress.txt"
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

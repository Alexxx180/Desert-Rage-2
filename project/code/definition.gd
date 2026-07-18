class_name Def

enum { LOGIC = 0, FLOOR = 1, ENTRY = 2, WALLS = 3, BLUE_OFF = 0, U_WATER = 0, BLUE_ON, U_EXIT = 1, RED_OFF, U_WALL_OFF = 2, RED_ON,
	U_WALL_ON = 3, WALL = 3, LEDGE = 4, GREEN_OFF, U_LADDER = 4, GREEN_ON, D_LADDER = 5,
	WHITE_OFF, ENEMY = 6, WHITE_ON, BOSS = 7, HINT = 7, TAGS = 7, BLACK_OFF, M_WATER = 8,
	BLACK_ON, M_EXIT = 9, CHESTS = 9, GROUND = 9, BRONZE_OFF, D_WALL_OFF = 10, BRONZE_ON,
	D_WALL_ON = 11, SILVER_OFF, H_SPRING_OFF = 12, SILVER_ON, H_SPRING_ON = 13, GOLD_OFF,
	B_SPRING_OFF = 14, GOLD_ON, B_SPRING_ON = 15, PLATINUM_OFF, D_WATER = 16, PLATINUM_ON,
	D_EXIT = 17, PLACE, SLIDE = 18, TELEPORT_ON, PILLAR = 19, SOURCE_OFF, G_SECRET_OFF = 20,
	SOURCE_ON, G_SECRET_ON = 21, LEVER_OFF, W_SECRET_OFF = 22, LEVER_ON, W_SECRET_ON = 23,
	PLATE_OFF, PAGE = 24, PLATE_ON, TELEPORT_OFF, SPIKER, COMFORTER, SUPPLIER, COOLER,
	SMALL_BOX, FIRE_BOX, LARGE_BOX, STAND_OFF, STAND_ON } # tiles

enum { N = -1, HERO, DEPLOYED = 0, NO = 0, PLATE = 0,
	OVERWORLD = 1,  LEVER = 1, STATUS = 1, CASUAL = 2, OFFSET = 2,  LAYER, LEVEL = 14,
	DEPLOY_DELTA = 4096, JUMP_POWER = 200000, MOVE = 11, GRAVITY = 700000 } # 550

enum { FLOORS, PUDDLE_OFF, PUDDLE_ON, ICE_FLOOR, ICE_THICK,
	ICE_MECH = 0, ALT1 = 3, ALT2 = 2, ALT3 = 1, HELP = 1, ALT4 = 0,
	ID = 0, TYPE = 1, ALT = 2, ATLAS = 3, COORDS = 4, T4 = 16, T8 = 64 } # alternatives
enum { DEAD, OPEN_MENU = 0, FREEZE, TRANSIT = 1, BOX, ACTING, JUMP, FALL, CAMERA, GRAB } # status
enum { PARTY = 2, RAY = 0, ROCK, EYE_SEEKER } # enemy name

const manual: PackedByteArray = [1, 3, 7, 10, 20, 21] ## Hints count shown
const levels: PackedByteArray = [1, 7, 9, 13, 25, 26] ## Level number

const step: PackedByteArray = [28, 28, 15, 15]
const push: PackedByteArray = [14, 20, 20, 20]

const hp: PackedByteArray = [100, 100, 93, 93]
const ap: PackedByteArray = [ 20,  20,  2,  2]

const power: PackedByteArray = [5, 5, 5, 5]
const shell: PackedByteArray = [5, 5, 5, 5]
const impac: PackedByteArray = [5, 5, 5, 5]
const react: PackedByteArray = [5, 5, 5, 5]

const hints: PackedStringArray = ["MM", "MJ", "MB", "ML", "CN", "AA", "AE", "AF", "AT",
	"SR", "AW", "AH", "AM", "RG", "RM", "BY", "BK", "RG", "FG", "LO", "IM", "LG", "AY",
	"CM", "CF", "IM", "EN", "PS", "RS", "ST", "BOOKS_STRING-ENEMY_STRING"]
const pages: PackedStringArray = []

const DIR: PackedVector2Array = [Vector2i(24, 20), Vector2i(-1, -1)]
const x_direction: PackedByteArray = [0, 5, 2]
const y_direction: PackedByteArray = [2, 0, 1]
const rotation: PackedByteArray = [135, 0, -135, -45, -90, 135, 45, 90]

static func rotate(dir: Vector2i) -> int: return rotation[direct(dir)]
static func direct(dir: Vector2i) -> int: return x_direction[dir.x] + y_direction[dir.y] # x_direction[dir.x]
static func offset(hero: int, no: int = 0) -> int: return hero * OFFSET + no

static func y(field: int, off: int = LEVEL) -> int: return field >> off
static func x(field: int, off: int = LEVEL) -> int: return field & ((1 << off) - 1)

static func to(field: int, off: int) -> Vector2i: return Vector2i(x(field, off), y(field, off))
static func tomap(field: int) -> Vector2i: return to(field, LEVEL)
static func to8(field: int) -> Vector2i: return to(field, 3)

static func yof(y1: int, off: int = LEVEL) -> int: return y1 << off
static func of(x1: int, y1: int, off: int = LEVEL) -> int: return y1 << off | x1
static func ofmap(pos: Vector2i) -> int: return of(pos.x, pos.y, LEVEL) # CTRL + LMB - the more the LEVEL the larger the map
static func of8(pos: Vector2i) -> int: return of(pos.x, pos.y, 3)

static func ref(parent: Object, object: Variant, caption: StringName, feedback: Callable) -> Variant:
	if object == null:
		object = feedback.call()
		parent.set(caption, object)
	return object

static func refn(parent: Node, node: Node, caption: StringName, feedback: Callable) -> Variant:
	if node == null:
		node = feedback.call()
		node.name = caption
		parent.set(caption, node)
		parent.add_child(node)
	return node

static func add(parent: Node, path: StringName, caption: StringName) -> Variant:
	var node: Node = load(path).instantiate()
	node.name = caption
	parent.set(caption, node)
	parent.add_child(node)
	return node

static func preadd(parent: Node, path: PackedScene, caption: StringName) -> Variant:
	var node: Node = path.instantiate()
	node.name = caption
	parent.set(caption, node)
	parent.add_child(node)
	return node

static func lazy(parent: Node, node: Variant, path: StringName, caption: StringName) -> Variant:
	return node if node != null else add(parent, path, caption)

static func pre(parent: Node, node: Variant, path: PackedScene, caption: StringName) -> Variant:
	return node if node != null else preadd(parent, path, caption)

static func lazy_at(parent: Node, sibling: Node, path: String, caption: StringName) -> Variant:
	var node: Node = parent.get(caption)
	if node == null:
		node = load(path).instantiate()
		node.name = caption
		parent.set(caption, node)
		sibling.add_sibling(node)
	return node

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
# const ability: StringName = &"res://now/work/lockers/ability/%s.tscn"
# const activator: StringName = &"res://now/work/lockers/ability/%s.tscn"
const music: StringName = &"res://now/work/music.tscn" # const hero: StringName = &"res://now/work/hero/%s/%s.tscn"
const ray: StringName = &"res://now/entity/ray.tscn"
const rock: StringName = &"res://now/entity/rock.tscn"
const group: StringName = &"res://now/entity/group.tscn"
const hud: StringName = &"res://now/hud/%s.tscn"
const credits: StringName = &"res://now/credits.tscn"
const settings: StringName = &"res://now/settings.tscn"
const sound: StringName = &"res://now/sound.tscn"
const information: StringName = &"res://now/information.tscn"
const pause: StringName = &"res://now/hud/status/pause.tscn"
const slots: StringName = &"res://now/hud/status/slots.tscn"
const enemy: StringName = &"res://now/hud/status/enemy.tscn"
const hint: StringName = &"res://now/hud/hints/hints.tscn"
const mhealth: StringName = &"res://now/hud/markers/health.tscn"
const items: StringName = &"res://now/hud/markers/items.tscn"
const actions: StringName = &"res://now/work/hero/actions/%s.tscn"
const xp: StringName = &"res://now/hud/status/xp.tscn"
const hits: StringName = &"res://now/hud/status/hits.tscn"
const game: StringName = &"res://now/hud/game.tscn"
const stats: StringName = &"res://now/hud/game/stats.tscn"
const input: StringName = &"res://now/work/hero/named/%s.tscn"
const world: StringName = &"res://now/work/hero/world/%s.tscn"
const progress: StringName = &"user://progress.txt"
const ability: StringName = &"res://now/hud/game/ability.tscn"
const priorities: StringName = &"res://now/hud/game/priorities.tscn"
const title: StringName = &"res://pre/ui/menu/title.tscn"
const fire: StringName = &"res://pre/particle/fire/fire.tscn"
const rain: StringName = &"res://pre/particle/rain/rain.tscn"
const card: StringName = &"res://now/hud/hud/priorities/card.tscn"

const mirror: Array[StringName] = [&"res://now/see/mirror/ray.tscn", &"res://now/see/mirror/rock.tscn"]

# PRELOADS
# const sand: PackedScene = preload("res://pre/particle/sand.tscn")
# const throw: PackedScene = preload("res://pre/particle/fight/kick.tscn")

const dialog: PackedScene = preload("res://pre/ui/dialog.tscn")
const combo: PackedScene = preload("res://pre/ui/combo.tscn")
const multiply: PackedScene = preload("res://pre/multiply.tscn")
const ailments: PackedScene = preload("res://pre/ui/status/ailments.tscn")
const bag: PackedScene = preload("res://pre/ui/status/items.tscn")

const help: CompressedTexture2DArray = preload("res://icon/help/z_master.svg")
const grabber: GradientTexture2D = preload("res://pre/ui/grabber.tres")
const root: Script = preload("res://code/level/root.gd")

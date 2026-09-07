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

static func map(field: int) -> Vector2i: return Vector2i(x(field, LEVEL), y(field, LEVEL))
static func map8(field: int) -> Vector2i: return Vector2i(x(field, 3), y(field, 3))

static func unit(x1: int, y1: int, off: int = LEVEL) -> int: return y1 << off | x1
static func join(pos: Vector2i) -> int: return unit(pos.x, pos.y, LEVEL) # CTRL + LMB - the more the LEVEL the larger the map
static func join8(pos: Vector2i) -> int: return unit(pos.x, pos.y, 3)

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
const saves: StringName = &"user://saves.bin"
const ost: StringName = &"user://ost.bin"

const first_level: StringName = &"res://def/dungeon/cave/origin/0/0/level.tscn"
const level: StringName = &"res://def/dungeon/%s/%s/%d/level.tscn"
const credits: StringName = &"res://def/dungeon/credits.tscn"
const main_menu: StringName = &"res://def/hud/main.tscn"
const fight: StringName = &"res://def/see/fight.tscn"
const music: StringName = &"res://def/work/music.tscn"
const ray: StringName = &"res://def/entity/ray.tscn"
const rock: StringName = &"res://def/entity/rock.tscn"
const settings: StringName = &"res://def/settings.tscn"
const sound: StringName = &"res://def/sound.tscn"
const information: StringName = &"res://def/information.tscn"
const pause: StringName = &"res://def/hud/status/pause.tscn"
const slots: StringName = &"res://def/hud/status/slots.tscn"
const enemy: StringName = &"res://def/hud/status/enemy.tscn"
const hint: StringName = &"res://def/hud/hints/hints.tscn"
const items: StringName = &"res://def/hud/markers/items.tscn"
const actions: StringName = &"res://def/work/hero/actions/%s.tscn"
const xp: StringName = &"res://def/hud/status/xp.tscn"
const hits: StringName = &"res://def/hud/status/hits.tscn"
const game: StringName = &"res://def/hud/game.tscn"
const stats: StringName = &"res://def/hud/game/stats.tscn"
const input: StringName = &"res://def/work/hero/named/%s.tscn"
const world: StringName = &"res://def/work/hero/world/%s.tscn"
const ability: StringName = &"res://def/hud/game/ability.tscn"
const priorities: StringName = &"res://def/hud/game/priorities.tscn"
const title: StringName = &"res://pre/ui/menu/title.tscn"
const fire: StringName = &"res://pre/particle/fire/fire.tscn"
const rain: StringName = &"res://pre/particle/rain/rain.tscn"
const card: StringName = &"res://def/hud/game/priorities_card.tscn"
const dialog: StringName = &"res://def/hud/util/dialog.tscn"
const combo: StringName = &"res://def/hud/util/combo.tscn"

const mirror: Array[StringName] = [&"res://def/see/mirror/ray.tscn", &"res://def/see/mirror/rock.tscn"]

# PRELOADS
const help: CompressedTexture2DArray = preload("res://icon/help/z_master.svg")
const root: Script = preload("res://code/node/level_root.gd")


enum { MASK = 2, MASK2 = 3, MASK3 = 4, BYTE = 8, SHORT = 16, INTEGER = 32, BIG = 64 }

static func bit(no: int) -> int: return 1 << no
static func one(n: int) -> bool: return n > 0 and (n & (n - 1)) == 0

static func of(value: int, index: int) -> bool:
	var state: int = bit(index)
	return value & state == state

static func to(value: int, index: int, next: bool) -> int:
	var state: int = bit(index)
	return value & ~state | (state * int(next))

static func to1(value: int, index: int) -> int: return value | bit(index)
static func to0(value: int, index: int) -> int: return value & ~bit(index)
static func to_(value: int, index: int) -> int: return value ^ bit(index)

static func b(state: PackedByteArray, select: int, index: int, value: int) -> void:
	state[select] = to(state[select], index, value)

static func b0(state: PackedByteArray, select: int, index: int) -> void:
	state[select] = to0(state[select], index)

static func b1(state: PackedByteArray, select: int, index: int) -> void:
	state[select] = to1(state[select], index)

static func n0(state: PackedInt64Array, select: int, index: int) -> void:
	state[select] = to0(state[select], index)

static func n1(state: PackedInt64Array, select: int, index: int) -> void:
	state[select] = to1(state[select], index)

static func i0(state: PackedInt32Array, select: int, index: int) -> void:
	state[select] = to0(state[select], index)

static func i1(state: PackedInt32Array, select: int, index: int) -> void:
	state[select] = to1(state[select], index)

static func of_x(mask: int, field: int, no: int) -> int:
	return (field >> (mask * no)) & (mask - 1)

static func to_x(mask: int, field: int, no: int, next: int) -> int:
	return field & ~((mask - 1) << (mask * no)) | (next << (mask * no))

static func edit_x(mask: int, field: int, no: int, increment: int) -> int:
	return to_x(mask, field, no, of_x(mask, field, no) + increment)

static func bytes_to_int(fields: PackedByteArray, mask: int) -> int:
	var value: int = 0 ; for i in range(0, len(fields)): value |= fields[i] << (i * mask)
	return value

static func byte(item: int, slot: int) -> int:
	return of_x(Def.BYTE, item, slot)

static func short(item: int) -> Vector2i:
	return Vector2i(byte(item, 0), byte(item, 1))

"""
static func iterate_set_bits(mask: int) -> int: # Handle negative integers safely if treating as an unsigned bitmask
	while mask != 0:
		var bit_index: int = ctz(mask) # 1. Find the index of the lowest set bit (0 to 63)
		print("Found active bit at index: ", bit_index) # 2. Execute your logic with the active index
		mask = mask & (mask - 1) # # 3. Clear the lowest set bit to move to the next one
"""

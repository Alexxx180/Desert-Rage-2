class_name Def

enum { N = -1, HERO, DEPLOYED = 0, NO = 0, PLATE = 0,
	OVERWORLD = 1,  LEVER = 1, STATUS = 1, CASUAL = 2, OFFSET = 2,  LAYER, LEVEL = 14,
	DEPLOY_DELTA = 4096, JUMP_POWER = 200000, MOVE = 11, GRAVITY = 700000 } # 550
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

enum { PART_BYTE = 2, HALF_BYTE = 4, BYTE = 8, SHORT = 16, INTEGER = 32, BIG = 64 }

static func one(n: int) -> bool: return n > 0 and (n & (n - 1)) == 0
static func of(value: int, index: int) -> bool: return value & (1 << index) == (1 << index)
static func to(value: int, index: int, next: bool) -> int: return value & ~(1 << index) | (int(next) << index)
static func to1(value: int, index: int) -> int: return value | (1 << index)
static func to0(value: int, index: int) -> int: return value & ~(1 << index)
static func to_(value: int, index: int) -> int: return value ^ (1 << index)

static func b(state: PackedByteArray, select: int, index: int, value: int) -> void: state[select] = to(state[select], index, value)
static func b0(state: PackedByteArray, select: int, index: int) -> void: state[select] = to0(state[select], index)
static func b1(state: PackedByteArray, select: int, index: int) -> void: state[select] = to1(state[select], index)

static func part(item: int, slot: int) -> int: return (item >> (slot << PART_BYTE)) & 3
static func half(item: int, slot: int) -> int: return (item >> (slot << HALF_BYTE)) & 15
static func byte(item: int, slot: int) -> int: return (item >> (slot << BYTE)) & 255
static func short(item: int, slot: int) -> int: return (item >> (slot << SHORT)) & 65535
static func number(item: int, slot: int) -> int: return (item >> (slot << INTEGER)) & 4_294_967_295
static func to_part(item: int, slot: int, next: int) -> int: return item & ~(3 << (slot << PART_BYTE)) | (next << (slot << PART_BYTE))
static func to_half(item: int, slot: int, next: int) -> int: return item & ~(15 << (slot << PART_BYTE)) | (next << (slot << PART_BYTE))
static func to_byte(item: int, slot: int, next: int) -> int: return item & ~(255 << (slot << PART_BYTE)) | (next << (slot << PART_BYTE))
static func to_short(item: int, slot: int, next: int) -> int: return item & ~(65535 << (slot << PART_BYTE)) | (next << (slot << PART_BYTE))
static func to_number(item: int, slot: int, next: int) -> int: return item & ~(4_294_967_295 << (slot << PART_BYTE)) | (next << (slot << PART_BYTE))

static func short_of(item: int) -> Vector2i: return Vector2i(byte(item, 0), byte(item, 1))

"""
static func iterate_set_bits(mask: int) -> int: # Handle negative integers safely if treating as an unsigned bitmask
	while mask != 0:
		var bit_index: int = ctz(mask) # 1. Find the index of the lowest set bit (0 to 63)
		print("Found active bit at index: ", bit_index) # 2. Execute your logic with the active index
		mask = mask & (mask - 1) # # 3. Clear the lowest set bit to move to the next one
"""


const OPENED: PackedStringArray = [
	"What's happening outside - То что происходит снаружи", "Breathe",
	"Coming from inside - Исходит из того что внутри", "Let go",
	"Within yourself - Сам в себе", "Look up",
	"Nothing to be contained", "Release",
	"There are always more", "Less",
	"Enemy is not it seems", "See",
	"Debt is paid in full", "Pay",
	"That are all those numbers", "Numb",
	"It's really curious", "Cure",
	"No risk means no transformation", "Form",
	"Confrontation through one pride heart is unavoidable", "Void",
	"That darkness - how it easily to enslave everyone", "Dark",
	"No dangers - no problems - no ...", "Problem",
]

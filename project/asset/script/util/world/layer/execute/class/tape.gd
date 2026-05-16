class_name MTape extends RefCounted

enum { EXECUTE = 0, TRANSPORT = 3 } # LAYER ID
enum { BOOKS = 2, HOOKS = 4, LOGIC = 7, TRANSITION = 8, CHATS = 6, CHEST = 9 }

enum { BLUE_OFF, BLUE_ON, RED_OFF, RED_ON, GREEN_OFF, GREEN_ON, WHITE_OFF, WHITE_ON, BLACK_OFF, BLACK_ON,
	BRONZE_OFF, BRONZE_ON, SILVER_OFF, SILVER_ON, GOLD_OFF, GOLD_ON, PLATINUM_OFF, PLATINUM_ON, PLACE, TELEPORT_ON,
	SOURCE_OFF, SOURCE_ON, LEVER_OFF, LEVER_ON, PLATE_OFF, PLATE_ON, TELEPORT_OFF, SPIKER, COMFORTER, SUPPLIER,
	COOLER, BOX, FIRE_BOX, LARGE_BOX }

enum { LADDER_UP, ENTRY_B, EXIT_B, WALL_B, LADDER_DOWN, ENTRY, EXIT, STAND_OFF, STAND_ON, DESCENT, EXIT_DOWN,
	WATER_UP, WATER, WATER_DOWN }

enum { POST_UP, BOSS, ICE, THICK_ICE, POST, ENEMY, PUDDLE_OFF, PUDDLE_ON, SPRING_OFF, SPRING_ON, LOAD_OFF, LOAD_ON, PAGE }

func to(field: int, off: int) -> Vector2i: return Vector2i(field & (2 << off), field >> off)
func to8(field: int) -> Vector2i: return to(field, 3)
func to4(field: int) -> Vector2i: return to(field, 2)

func from(pos: Vector2i, off: int) -> int: return (pos.y << off) | pos.x
func from8(pos: Vector2i) -> int: return from(pos, 3)
func from4(pos: Vector2i) -> int: return from(pos, 2)

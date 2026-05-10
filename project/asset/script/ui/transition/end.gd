extends ColorRect

enum { WAY = 0, LEDGE = 1 }

var blackout: BlackoutTransition = BlackoutTransition.new()
var _ledges: ColorRect = null
var ledges: ColorRect:
	get: return Works.upload(self, _ledges, LoadBus.hero % ["ledges", "ledges"], "ledges")

func entry_way() -> void: # way.color = Color.BLACK
	blackout.as_way(self, Color.TRANSPARENT, true)

func entry_ledges() -> void:
	blackout.set_color(Color.BLACK)
	blackout.as_ledges(ledges, Color.TRANSPARENT, true)
	color = Color.TRANSPARENT

func entry_transit(type: int) -> void:
	match type:
		WAY: entry_way()
		LEDGE: entry_ledges()

func start_transition(level: String, _floor_diff: int = 0, type: int = LEDGE) -> void:
	blackout.scene = level
	match type:
		WAY: blackout.as_way(self, Color.BLACK, true)
		LEDGE: blackout.as_ledges(ledges, Color.BLACK, true)

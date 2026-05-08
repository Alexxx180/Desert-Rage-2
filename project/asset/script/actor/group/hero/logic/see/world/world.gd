extends RayCast2D

enum { WHIP = 240, CHAINS = 177 } # -417 MAX for whip (chains)

@onready var deploy: RayCast2D = $deploy

var _ledges: Area2D = null
var ledges: Area2D:
	get: return Works.upload(self, _ledges, LoadBus.ledges, "ledges")

var _pull: ShapeCast2D = null
var pull: ShapeCast2D:
	get: return Works.upload(self, _pull, LoadBus.pull, "pull")

var _whip: ShapeCast2D = null
var whip: ShapeCast2D:
	get: return Works.upload(self, _whip, LoadBus.whip, "whip")

var _ground: Area2D = null
var ground: Area2D:
	get: return Works.upload(self, _ground, LoadBus.ground, "ground")

var _fight: Node2D = null
var fight: Node2D:
	get: return Works.upload(self, _fight, LoadBus.fight, "fight")

func set_direction(direction: Vector2i) -> void:
	target_position = Def.DIRECTION * direction

func set_pull() -> void:
	pull.position = target_position

func set_ground() -> void:
	ground.target_position = target_position

func set_fight(direction: Vector2i) -> void:
	fight.set_direction(direction)

func set_whip(direction: Vector2i) -> void:
	whip.target_position = Def.vec2i(240) * direction

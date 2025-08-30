extends AdvancedCharacterAnimation

@onready var dead: Node = $dead
@onready var timer: Timer = $timer

func _ready() -> void: direct()

func direct_animations() -> Array[String]:
	return ["rolling"]

func move(motion: Vector2) -> bool:
	var turned: bool = super.move(motion)
	if turned: request("enemy", "active")
	#else: request("enemy", "passive")
	return turned

func dead_animation() -> void:
	dead.start()
	interrogate()

func interrogate() -> void:
	timer.start()

func interrogation_end() -> void:
	dead.health.aura.stop_blinking()
	dead.health.aura.diffusion()
	request("enemy", "dead")

func dead_animation_end() -> void:
	dead.effect()
	request("enemy", "active")

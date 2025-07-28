extends AdvancedCharacterAnimation

@onready var moves: Node = $moves
@onready var effect: Node = $effect
@onready var syncer: Node = $syncer

func _ready() -> void:
	direct()
	effect.moves = moves
	syncer.moves = moves

func direct() -> void:
	super.direct()
	if not Input.is_action_pressed("action"): blend("pull_forward")

func move(motion: Vector2) -> bool:
	var turned: bool = super.move(motion)
	if turned: moves.set_base_stance("move")
	else: moves.set_base_stance("idle")
	return turned

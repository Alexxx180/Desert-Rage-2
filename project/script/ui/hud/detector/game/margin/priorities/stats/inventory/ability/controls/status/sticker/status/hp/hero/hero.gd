extends ProgressBar # @export var right: bool = false

@onready var health: Label = $health
@onready var back: TextureRect = $back

const MAX: float = 0.99

var _litmus: HBoxContainer = null
var litmus: HBoxContainer:
	get:
		if _litmus == null:
			_litmus = get_parent().litmus.instantiate()
			var space: Control = $control
			space.add_sibling(_litmus)
			remove_child(space)
		return _litmus

func change(hp: Node) -> void:
	value = hp.points ; show() #health.change(hp)
	health.change(hp)
	var portion: float = hp.points / hp.maximum
	back.texture.fill_to.x = 0.07 + MAX * portion

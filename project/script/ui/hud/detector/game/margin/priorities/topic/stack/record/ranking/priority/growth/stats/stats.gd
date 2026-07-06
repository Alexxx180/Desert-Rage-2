extends Label

@onready var number: Label = $number

var addon: Array[Array] = [[0, 1], [1, 3], [2, 3]]
var icons: Array[String] = ["⚔️", "🔥", "🛡", "🫧"]
var priorities: Array[String] = ["📈", "⚖️", "🪨"]

func set_priority(no: int) -> void:
	text = priorities[no] ; hide_number()

func hides() -> void: text = '' ; hide_number()
func hide_number() -> void: number.text = ''

func toggle(no: int, _method: String) -> void:
	text = "%s\r\n%s" % [addon[no].front(), addon[no].back()]
	# number.text += (method)

extends Node

signal update_logic_order(vendor: Node)

@onready var buttons: Node = $buttons

var vendor: bool: set = set_vendor
var reorder: bool: set = set_reorder
var order_a: bool: set = set_order_a
var order_x: bool: set = set_order_x
var press: bool = false

func update() -> void: update_logic_order.emit(self.buttons)
func set_prop(prop: String, value: bool) -> void: buttons.set(prop, value) ; update()

func set_vendor(value: bool) -> void:
	buttons.vendor = value
	if value:
		buttons.order_a = value
		buttons.order_x = value
	update()

func set_reorder(value: bool) -> void: set_prop("reorder", value)
func set_order_a(value: bool) -> void: set_prop("order_a", value)
func set_order_x(value: bool) -> void: set_prop("order_x", value)

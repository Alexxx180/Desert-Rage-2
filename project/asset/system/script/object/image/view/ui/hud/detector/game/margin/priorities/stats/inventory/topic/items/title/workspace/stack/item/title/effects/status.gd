extends HBoxContainer

@onready var aura: PanelContainer = $aura
@onready var resource: PanelContainer = $resource
@onready var no_enemy: PanelContainer = $no_enemy
@onready var no_poison: PanelContainer = $no_poison
@onready var no_cough: PanelContainer = $no_cough

func hides() -> void: for i in get_children(): i.hide()

func saura() -> String:
	aura.show()
	return "aura shown"

func sresource() -> String:
	resource.show()
	return "resource shown"

func set_refill(item: IUse) -> void:
	hides()
	item.imagine(self)

func set_effect(item: Variant) -> void:
	hides()
	var sticker = get(item.effect)
	if sticker:
		sticker.show()

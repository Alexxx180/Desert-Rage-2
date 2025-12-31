extends HBoxContainer

@onready var aura: PanelContainer = $aura
@onready var resource: PanelContainer = $resource
@onready var no_enemy: PanelContainer = $no_enemy
@onready var no_poison: PanelContainer = $no_poison
@onready var no_cough: PanelContainer = $no_cough

func hides() -> void: for i in get_children(): i.hide()

func determine_ar(item: UseItem) -> void:
	if item.supply > item.power: resource.show()
	else: aura.show()

func set_refill(item: UseItem, type: int) -> void:
	hides()
	match type:
		UseItem.AURA, UseItem.BOTH: aura.show()
		UseItem.RESOURCE: resource.show()
		UseItem.AR: determine_ar(item)

func set_effect(item: Variant) -> void:
	hides()
	get(item.effect).show()

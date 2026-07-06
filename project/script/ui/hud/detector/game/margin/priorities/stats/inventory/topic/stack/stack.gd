extends VBoxContainer

@onready var bag: HFlowContainer = $bag# $items/bag
@onready var status: HFlowContainer = $status
@onready var sticker: MarginContainer = $sticker

func connect_group(group: Node2D) -> void:
	group.deploy.select_hero.connect(func(_h): status.select_hero(group))

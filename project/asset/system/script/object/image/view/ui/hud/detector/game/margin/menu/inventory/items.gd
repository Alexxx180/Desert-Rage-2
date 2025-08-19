extends HFlowContainer

@onready var primary: Array[PanelContainer] = [$slot_0, $slot_1, $slot_2, $slot_3, $slot_4]
@onready var equipment: Array[PanelContainer] = [$weapon, $artifact, $armor, $legs, $boots]

@onready var items: Array[Node] = get_children()

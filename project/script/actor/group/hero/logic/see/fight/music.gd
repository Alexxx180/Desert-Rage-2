extends Node2D

@onready var nearby: Area2D = $nearby
@onready var spawn: Area2D = $spawn

func controls(group: Node2D) -> void:
	if not group.has_node("../../ost"): return
	var tension: Node = group.get_node("../../ost").tension
	
	if group.get_parent().lay == null: return
	
	nearby.body_entered.connect(tension.add_enemy)
	nearby.body_exited.connect(tension.drop_enemy)

	spawn.body_entered.connect(tension.add_spawn)
	spawn.body_exited.connect(tension.drop_spawn)

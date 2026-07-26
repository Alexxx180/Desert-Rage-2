extends Camera2D

func _ready() -> void: get_parent().set_script(Def.root)

@export_flags_2d_physics var result: PackedInt32Array = [0, 0]
@export_flags_2d_physics var chests: PackedInt32Array = [0, 0]
@export_flags_2d_physics var pages: PackedInt32Array = [0, 0]
@export_flags_2d_physics var books: PackedInt32Array = [0, 0]
@export_flags_3d_navigation var enemy_navigation: PackedInt32Array = [  ## AI strategy. Move | C = to, F = from
	0, 0]
@export var enemy_proportion: PackedFloat32Array = []
@export_flags_3d_physics var enemy: int
@export_flags_3d_render var mode: int

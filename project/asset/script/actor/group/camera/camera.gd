extends Camera2D

func _ready() -> void: get_parent().set_script(Def.root)

@export_group("Deployment")
@export_flags_3d_render var mode: int
@export_flags_3d_physics var enemy: int
@export var proportion: PackedFloat32Array = []

@export_group("Save state")
@export_flags_2d_physics var chests: int
@export_flags_2d_physics var pages: PackedInt32Array = [0, 0]
@export_flags_2d_physics var books: PackedInt32Array = [0, 0]

@export var hints_texture: CompressedTexture2DArray
@export_flags_3d_navigation var eye_seeker_navigation: int ## AI strategy. Move | C = to, F = from
@export_flags_3d_navigation var spider_navigation: int ## AI strategy. Move | C = to, F = from

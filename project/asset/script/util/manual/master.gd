class_name MasterManifest extends Resource

@export_group("Manual")
@export var progress_hints: PackedByteArray = [1, 3, 7, 10, 20, 21] ## Hints count shown
@export var progress_level: PackedByteArray = [1, 7, 9, 13, 25, 26] ## Level number
@export var texture: CompressedTexture2DArray
@export var hints: String = "MM-MJ-MB-ML-CN-AA-AE-AF-AT-SR-AW-AH-AM-RG-RM-BY-BK-RG-FG-LO-IM-LG-AY-CM-CF-IM-EN-PS-RS-ST"

@export_group("Group Stats")
@export var ray: PackedVector4Array = [Vector4i(100, 20, 14, 28), Vector4i(5, 5, 5, 5)] ## [0] Aura Resource Push Run [1] Power Influence Vitality Reaction
@export var rock: PackedVector4Array = [Vector4i(100, 20, 20, 28), Vector4i(5, 5, 5, 5)] ## [0] Aura Resource Push Run [1] Power Influence Vitality Reaction

@export_group("Enemy Stats")
@export var eye_seeker: PackedVector4Array = [Vector4i(93, 1, 20, 15), Vector4i(5, 5, 5, 5)] ## [0] Aura Resource Push Run [1] Power Influence Vitality Reaction
@export_flags_3d_navigation var eye_seeker_navigation: int ## AI strategy. Move | C = to, F = from
@export var spider: PackedVector4Array = [Vector4i(93, 1, 20, 15), Vector4i(5, 5, 5, 5)] ## [0] Aura Resource Push Run [1] Power Influence Vitality Reaction
@export_flags_3d_navigation var spider_navigation: int ## AI strategy. Move | C = to, F = from

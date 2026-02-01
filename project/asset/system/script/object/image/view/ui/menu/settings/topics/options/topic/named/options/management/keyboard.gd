extends HFlowContainer

enum { M = 0, S = 1 }

func _ready() -> void:
	var options: Array = [
		[$movement, [$forward, $backward, $left, $right]],
		[$skills, [$hands, $legs, $skill_1, $skill_2]],
		[$quick, [$team, $group, $quick_heal, $quick_refresh]],
		[$luggage, [$inventory, $equipment, $ability, $priorities]],
		[$options, [$map, $settings, $main_menu, $soundtrack, $checkpoint,
			$fast_save, $fast_load, $saves, $fullscreen, $photo_mode]]
	]
	for i in options: i[M].connect_collapsing(i[S])

func get_items() -> Array[Control]:
	return [$preset, $forward, $backward, $left, $right,
		$hands, $legs, $action_one, $action_two, $team,
		$group, $heal, $refresh, $analyze, $information,
		$settings, $main_menu, $soundtrack, $checkpoint,
		$fast_save, $fast_load, $export_progress,
		$import_progress, $fullscreen, $photo_mode]

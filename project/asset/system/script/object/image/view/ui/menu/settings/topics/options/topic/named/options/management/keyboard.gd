extends HFlowContainer

func get_items() -> Array[Control]:
	return [$preset, $forward, $backward, $left, $right,
		$hands, $legs, $action_one, $action_two, $team,
		$group, $heal, $refresh, $analyze, $information,
		$settings, $main_menu, $soundtrack, $checkpoint,
		$fast_save, $fast_load, $export_progress,
		$import_progress, $fullscreen, $photo_mode]

extends BehaviorSelector

@export_category("Level")
@export var caption: int:
	set(value):
		$ambient.caption = value
		$heating.caption = value
		$rampage.caption = value
@export var boss: String:
	set(value): $boss.level_boss = value

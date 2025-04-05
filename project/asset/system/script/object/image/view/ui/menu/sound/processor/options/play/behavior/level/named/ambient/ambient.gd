extends BehaviorSequence

@export_category("Level")
@export var rampage: int:
	set(value): $assert.rampage = value
@export var caption: int:
	set(value): $theme/named.caption = value

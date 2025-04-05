extends BehaviorSequence

@export var level_boss: String:
	set(value):
		$theme/named.caption = value
		$assert.has_boss = true

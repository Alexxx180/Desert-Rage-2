extends Node

var skill: SkillsHeader = SkillsHeader.new()

func controls(hero: CharacterBody2D, skills: Node) -> void:
	skill.setup(hero, skills)
	connect_pull(hero.logic.see.world.skills.pull)
	connect_transition(hero.logic.see.world.skills.transition)
	connect_act(hero.logic.see.world.skills.act)
	connect_press(hero.logic.see.world.skills.press)
	# connect_activation() # TODO FIXME ENABLE ACTIVATION
	connect_stomp(hero.logic.see.fight.small_circle)

func connect_pull(pull: Node2D) -> void:
	pull.box.body_entered.connect(skill.start_forward)
	pull.box.body_exited.connect(skill.stop_forward)

func connect_transition(transition: Area2D) -> void:
	transition.body_entered.connect(skill.transit)

func connect_stomp(circle: Area2D) -> void:
	circle.body_entered.connect(skill.stomp_encounter)
	circle.body_exited.connect(skill.stomp_diverge)

func connect_activation() -> void:
	skill.skills.act.activate.connect(skill.activator.trigger.activate)
	skill.skills.press.activate.connect(skill.activator.button.activate)
	skill.skills.press.deactivate.connect(skill.activator.button.deactivate)

func connect_act(act: Area2D) -> void:
	act.body_entered.connect(skill.encounter_act)
	act.body_exited.connect(skill.diverge_act)

func connect_press(press: Node2D) -> void:
	press.body_entered.connect(skill.encounter_press)
	press.body_exited.connect(skill.diverge_press)

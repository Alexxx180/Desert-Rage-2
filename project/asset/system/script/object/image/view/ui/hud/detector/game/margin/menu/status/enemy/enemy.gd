extends PanelContainer

@onready var health: ProgressBar = $health
@onready var contested: ProgressBar = $contested
@onready var caption: Label = $margin/contents/caption
@onready var interrogate: Label = $margin/contents/interrogate
@onready var damage: HBoxContainer = $margin/contents/damage
@onready var hits: HBoxContainer = $margin/contents/hits

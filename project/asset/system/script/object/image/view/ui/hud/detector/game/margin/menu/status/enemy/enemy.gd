extends PanelContainer

@onready var health: ProgressBar = $hp/health
@onready var contested: ProgressBar = $hp/contested
@onready var caption: Label = $margin/contents/caption
@onready var interrogate: Label = $margin/contents/interrogate
@onready var damage: HBoxContainer = $margin/contents/damage
@onready var hits: HBoxContainer = $margin/contents/hits

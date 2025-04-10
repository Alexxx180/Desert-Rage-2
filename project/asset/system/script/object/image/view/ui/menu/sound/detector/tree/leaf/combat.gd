extends HBoxContainer

@onready var content: Dictionary = {
	"ambient": $content/ambient,
	"heating": $content/heating,
	"rampage": $content/rampage
}

var i: int

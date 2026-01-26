extends Resource

class_name HelpHint

@export var texture: Texture2D
@export var caption: String = ""

func key(kind: String) -> String: return tr("H" + caption + kind)

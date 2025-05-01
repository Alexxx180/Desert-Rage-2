extends FileDialog

class_name OpenPresetDialog

var _feedback: Callable
var result_file: String = ""

func _ready() -> void:
	file_selected.connect(selected)

func selected(file: String) -> void:
	if FileAccess.file_exists(file):
		result_file = file
		_feedback.call(file)
	else:
		result_file = ""

func show_dialog(feedback: Callable) -> void:
	_feedback = feedback
	show()

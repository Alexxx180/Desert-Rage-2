extends OpenPresetDialog

class_name SavePresetDialog

func selected(file: String) -> void:
	result_file = file
	_feedback.call(file)

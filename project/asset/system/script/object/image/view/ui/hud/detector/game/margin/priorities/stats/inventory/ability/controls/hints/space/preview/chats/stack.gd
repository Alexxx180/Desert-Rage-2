extends PanelContainer

var _stack: HBoxContainer = null
var stack: HBoxContainer:
	get: return Works.upload(self, _stack, Defaults.now.hints % name, name)

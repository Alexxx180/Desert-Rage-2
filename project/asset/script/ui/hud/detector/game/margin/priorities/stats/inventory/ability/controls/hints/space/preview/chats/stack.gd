extends PanelContainer

var _stack: HBoxContainer = null
var stack: HBoxContainer:
	get: return Works.upload(self, _stack, LoadBus.hints % name, name)

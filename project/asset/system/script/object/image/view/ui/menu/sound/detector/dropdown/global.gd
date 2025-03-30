extends Node

var sound: Dictionary

func _ready() -> void:
	sound = {
		"overworld": {
			"ambient": {
				"list": [],
				"set": {
					"village": {
						"theme": {
							"set": [],
							"mix": false
						},
						"list": {
							"monster": ""
						}
					},
					"cutscene": {
						"theme": {
							"set": [],
							"mix": false
						},
						"list": {
							"opening": "",
						}
					}
				}
			},
			"battle": {
				"theme": {
					"set": [],
					"mix": true
				},
				"list": {
					"ray": "",
					"rock": "",
					"mix": 0
				}
			},
			"boss": {
				"theme": {
					"set": [],
					"mix": true
				},
				"list": {
					"spider": ""
				}
			}
		},
		"location": {
			"caves": {
				"list": {
					"theme": {
						"mix": true,
						"degree": [
							{
								"ambient": "",
								"danger": "",
								"battle": ""
							}
						]
					},
					"boss": {
						"theme": [],
						"mix": true
					}
				},
				"set": {
					"origin": {
						"mix": true,
						"degree": [
							{
								"ambient": "",
								"danger": "",
								"battle": ""
							}
						]
					}
				}
			}
		}
	}

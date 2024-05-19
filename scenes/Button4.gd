extends Button

@onready var panel = $"../.."

func _on_pressed():
	panel.hide()

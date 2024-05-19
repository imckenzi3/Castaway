extends Button

@onready var panel = $"../../Panel"
@onready var panel_2 = $"../../Panel2"

func _on_pressed():
	panel.show()
	panel_2.show()

extends Camera2D

const MIN_ZOOM = 0.1
const MAX_ZOOM = Vector2(1.5, 1.5)
	
func _unhandled_input(event):
	const MAX_ZOOM = Vector2(2.5, 2.5)
	
	if event.is_action_pressed("zoom_in"):
		if self.zoom > MAX_ZOOM:
			self.zoom -= Vector2(0.1, 0.1)
		print(zoom)
	if event.is_action_pressed("zoom_out"):
			self.zoom += Vector2(0.1, 0.1)




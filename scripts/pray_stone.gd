extends Label


func _process(delta):
	self.text = str("Total Fish =", Global.fish)

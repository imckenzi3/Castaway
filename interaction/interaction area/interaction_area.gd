extends Area2D
class_name InteractionArea

@export var action_name: String = "interact" #text will be shown above object to indicate can be interacted with

var interact: Callable = func(): #any object with an interaction_area can override this callable
	pass 

func _on_body_entered(body):
	InteractionManager.register_area(self)

func _on_body_exited(body):
	InteractionManager.unregister_area(self)

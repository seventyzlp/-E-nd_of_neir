extends Area2D

var velovity = Vector2(0,-1)
var speed = 1000

func _process(delta):
	global_position += velovity.rotated(rotation) * speed * delta
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func _on__area_entered(area):
	if area.is_in_group("enemy"):
		queue_free()

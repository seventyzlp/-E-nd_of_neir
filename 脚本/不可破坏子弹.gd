extends Node2D

var speed = 200
func _process(delta):
	position += transform.x * speed * delta
	
# 离开屏幕消失
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	

# 碰撞交互
func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		queue_free()
		

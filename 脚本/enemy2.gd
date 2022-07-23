extends PathFollow2D

var hp = 10
var alive = true
#var once = true

func _process(delta):
	if unit_offset < 1 and alive:
		unit_offset += 0.3 * delta
	if unit_offset >= 1:
		queue_free()
	
	if hp <= 0:
		queue_free()
		

func _on_Area2D_area_entered(area):
	if area.is_in_group("bullet"):
		hp -= 1

extends Node2D

var enemy1 = preload("res://场景/enemy1.tscn")

func creat_enemy():
	var _enemy = Global.instance_node(enemy1, Vector2(rand_range(100, 924), 20), Global.world, global_rotation)
	

# 倒计时产生
func _on_Timer_ct_timeout():
	randomize()
	creat_enemy()
	$Timer_ct.wait_time = int(rand_range(10,15))
	#print($Timer_ct.wait_time)

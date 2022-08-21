extends Node2D

var enemy1 = preload("res://场景/enemy1.tscn")
var difficulity = 0

func creat_enemy():
	var _enemy = Global.instance_node(enemy1, Vector2(rand_range(100, 924), 20), Global.world, global_rotation)
	

# 倒计时产生
func _on_Timer_ct_timeout():
	randomize()
	creat_enemy()
	$Timer_ct.wait_time = int(rand_range(5,7))
	#print($Timer_ct.wait_time) 


func _on__Player_die(): # 停止生成敌人，让敌人自己走掉
	$Timer_ct.stop() # 停止生成敌人
func _on__Player_back(): # 主角恢复之后重新生成敌人
	$Timer_ct.start()

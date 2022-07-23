extends Path2D

var enemy2 = preload("res://场景/enemy2.tscn")
var time = 0

func _ready():
	spawn_enemy2()

func _process(_delta):
	if time >= 5:
		$Timer.wait_time = int(rand_range(6, 10))
		$Timer.start()
		time = 0

func spawn_enemy2():
	for i in 5:
		var _enemy2 = Global.instance_node(enemy2, Vector2(global_position.x, global_position.y - 50), self, global_rotation)
		yield(get_tree().create_timer(1), "timeout") # 间隔3秒产生敌人
		time += 1
		

func _on_Timer_timeout():
	spawn_enemy2()


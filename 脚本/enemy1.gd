extends Area2D

var velovity = Vector2(0,1)
var speed = 20
var hp = 10
var alive = true

var attack_wait = 0.2
var pan_speed = 100
var spawn_point_count = 4
var r = 20
var enemy_bullet1 = preload("res://场景/可破坏子弹.tscn")
var enemy_bullet2 = preload("res://场景/不可破坏子弹.tscn")
var pattern = 0
var start_attack = true
var attack_once = true
var switch_once = true


func attack():
	if pattern == 0:
		$"Timer_攻击间隔".stop()
	elif pattern == 1:
		pan_speed = 100
		attack_wait = 0.5
		spawn_point_count = 10
		$"旋转".rotation_degrees = 0
		$"Timer_攻击间隔".wait_time = attack_wait
		$"Timer_攻击间隔".start()
	elif pattern == 2:
		pan_speed = -100
		attack_wait = 0.5
		spawn_point_count = 6
		$"旋转".rotation_degrees = 0
		$"Timer_攻击间隔".wait_time = attack_wait
		$"Timer_攻击间隔".start()
	elif pattern == 3:
		pan_speed = 0
		attack_wait = 0.9
		spawn_point_count = 12
		$"旋转".rotation_degrees = 0
		$"Timer_攻击间隔".wait_time = attack_wait
		$"Timer_攻击间隔".start()
	set_spwan()
func _process(delta):
	global_position += velovity.rotated(rotation) * speed * delta
	if hp <= 0 and alive: # 血量检测
		$Label.visible = false
		speed = 0
		$CollisionShape2D.call_deferred("set_disabled", true)
		$"Timer_攻击间隔".stop()
		alive = false
		start_attack = false
		hp = 0
		queue_free()
		
	var pan = $"旋转".rotation_degrees + pan_speed * delta
	$"旋转".rotation_degrees = fmod(pan, 360)
	
	if start_attack:
		if pattern == 0 and switch_once:
			$"Timer_转换方式".start()
			switch_once = false
			print("开始转换倒计时")
		if pattern != 0 and attack_once:
			attack()
			$"Timer_攻击结束".start()
			attack_once = false
			
			
# 离开屏幕后消失
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
# 碰撞特效
func _on_enemy1_area_entered(area):
	if area.is_in_group("bullet"):
		hp -= 1
		
#子弹生成，旋转弹幕
func set_spwan():
	var step = 2 * PI / spawn_point_count
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(r, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		$"旋转".add_child(spawn_point)
# 攻击结束
func _on_Timer_attackend_timeout():
	pattern = 0
	switch_once = true
	for node in $"旋转".get_children():
		$"旋转".remove_child(node) # 重置子弹出生点
		

# 按照间隔生成子弹
func _on_Timer_attackwait_timeout():
	if pattern == 1 or pattern == 3: # 进行一个子弹的切换，目前还没有办法做到隔一个切换一个
		for s in $"旋转".get_children():
			var bullet1 = Global.instance_node(enemy_bullet1, s.global_position, Global.world, s.global_rotation)
			#var bullet2 = Global.instance_node(enemy_bullet2, s.global_position, Global.world, s.global_rotation)
	elif pattern == 2:
		for s in $"旋转".get_children():
			#var bullet1 = Global.instance_node(enemy_bullet1, s.global_position, Global.world, s.global_rotation)
			var bullet2 = Global.instance_node(enemy_bullet2, s.global_position, Global.world, s.global_rotation)
# 攻击方式转换
func _on_Timer_ChangePattern_timeout():
	attack_once = true
	pattern = int(rand_range(1,4))
	
	

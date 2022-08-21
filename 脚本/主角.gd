extends KinematicBody2D

var g = 50
var Max_Speed = 300
var fraktion = 20
var velocity = Vector2.ZERO

var _bullet = preload("res://场景/子弹.tscn")
var start_shoot = true

var hp = 3
var dead_times = 0
signal Player_die # 角色已经死掉信号
signal Player_back # 角色愿意再战信号
signal friends # 死亡次数足够，召唤僚机信号
signal nofriends
#export(PackedScene) var friends_plane # 提前实例化

func _physics_process(delta): # 主进程
	# 移动
	if hp >0 : hero_move(delta)
	# 设置射击
	if Input.is_action_pressed("ui_accept") and start_shoot and hp > 0:
		shoot()
		$attack_music.stop()
		start_shoot = false
		$"射击延时".start()
	HP()
	if dead_times >= 8:
		emit_signal("friends") # 死了4次之后触发僚机开始乱杀
func hero_move(delta):
	var move = Vector2.ZERO
	move.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move.y = - Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down")
	move = move.normalized()
	
	if move != Vector2.ZERO:
		velocity += move * g * delta
		velocity = velocity.clamped(Max_Speed * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, fraktion * delta)
	
	move_and_collide(velocity)
	# 限制飞机在屏幕范围
	global_position.x = clamp(global_position.x, 20, 1004)
	global_position.y = clamp(global_position.y, 20, 560)
func shoot():
	var bullet = Global.instance_node(_bullet, $Position2D.global_position, Global.world, global_rotation)
	$attack_music.play()
func _on__timeout():
	start_shoot = true
	get_tree().create_timer(1)
	$attack_music.stop()
func _on_Area2D_area_entered(area):
	if area.is_in_group("enemy"): # 收到伤害有短暂无敌时间
		hp -= 1
		print("撞击扣血")
		$be_attacked1.play()
		$Area2D/CollisionShape2D.call_deferred("set_disabled", true)
		$CollisionShape2D.call_deferred("set_disabled", true)
		$"无敌时间".start()
	if area.is_in_group("enemy_bullet"):
		hp -= 1
		print("中弹扣血")
		$Area2D/CollisionShape2D.call_deferred("set_disabled", true)
		$CollisionShape2D.call_deferred("set_disabled", true)
		$"无敌时间".start()
		$be_attacked1.play()
	$be_attacked1.stop()

func HP():
	if hp <= 0:
		dead_times += 1
		hp = 0
		$"贴图".visible = false
		$Area2D/CollisionShape2D.call_deferred("set_disabled", true)
		$CollisionShape2D.call_deferred("set_disabled", true) #主角死掉之后禁用碰撞
		emit_signal("Player_die") # 玩家死亡之后触发死亡事件
		emit_signal("nofriends")
	if hp == 1:
		$"贴图".play("hp1")
	elif hp == 2:
		$"贴图".play("hp2")
	elif hp == 3:
		$"贴图".play("hp3")
		if dead_times < 4:
			emit_signal("nofriends")
			# print(dead_times)
		
func _on_2_again():
	hp = 3
	dead_times += 1
	$".".position = Vector2(515, 413) # 初始化
	$"贴图".visible = true
	$Area2D/CollisionShape2D.call_deferred("set_disabled", false)
	$CollisionShape2D.call_deferred("set_disabled", false) 
	emit_signal("Player_back") # 进行一个信号的传递
	emit_signal("nofriends")
func _on__timeout_ranbow(): # 解除无敌状态
	$Area2D/CollisionShape2D.call_deferred("set_disabled", false)
	$CollisionShape2D.call_deferred("set_disabled", false) 



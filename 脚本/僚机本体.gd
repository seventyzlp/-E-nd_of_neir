extends Node2D

# 僚机的血量控制
var hp = 3
var _bullet = preload("res://场景/子弹.tscn") # 预读取子弹
var start_shoot = false
var reborn = true
var friends = false

func HP(): 
	if hp == 0:
		$"僚机贴图".visible = false # 僚机死掉之后隐藏
		$Area2D/CollisionShape2D.call_deferred("set_disabled", true) #僚机死掉之后禁用碰撞
		if reborn:
			reborn = false
			$"复活延时".start()
	elif hp == 1:
		$"僚机贴图".play("hp1")
	elif hp == 2:
		$"僚机贴图".play("hp2")
	elif hp == 3:
		$"僚机贴图".play("hp3")
		
func shoot(): # 生成子弹
	
	var bullet = Global.instance_node(_bullet, $Position2D.global_position, Global.world, global_rotation)

func _process(delta):
	HP() # 血量控制检测
	if Input.is_action_pressed("ui_accept") and hp > 0 and start_shoot:
		shoot()
		start_shoot = false
		$"射击延时".start()
	if friends:
		$Area2D/CollisionShape2D.call_deferred("set_disabled", false)
		$"僚机贴图".visible = true
		start_shoot = true
	else:
		$Area2D/CollisionShape2D.call_deferred("set_disabled", true)
		$"僚机贴图".visible = false
		start_shoot = false
		
func _on_Area2D_area_entered(area):
	if area.is_in_group("enemy"):
		hp -= 2 # 撞击扣血
		$be_attacked2.play() # 播放受到攻击的音效
		$be_attacked.start()
	elif area.is_in_group("enemy_bullet"):
		hp -= 1 # 子弹击中扣血
		$be_attacked2.play() # 播放受到攻击的音效
		$be_attacked.start()
func _on__timeout(): # 限制射击速度
	start_shoot = true
	print("倒计时结束")
func _on_be_attacked_timeout():
	$be_attacked2.stop()
func _on_reborn_timeout(): # 倒计时结束，僚机重生
	hp = 3
	$"僚机贴图".visible = true 
	$Area2D/CollisionShape2D.call_deferred("set_disabled", false) 
	reborn = true # 防止无限复活重置倒计时
	start_shoot = true # 可以进行攻击
func _on__nofriends(): # 在时机未到的时候禁用僚机
	friends = false
func _on__friends(): # 时候到了启用僚机
	friends = true
	start_shoot = true

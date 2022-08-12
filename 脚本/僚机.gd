extends PathFollow2D
var t = 0.0
# 僚机一共有6架循环飞行，受到攻击之后会立刻死掉

func _on__friends(delta): # 触发僚机效果
	$".".visible = true # 可见
	t += delta
	# position = curve.interpolate_baked(t * curve.get_baked_length(), true) # 在曲线上找点并且匀速沿着移动
	

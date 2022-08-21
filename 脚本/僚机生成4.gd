extends PathFollow2D

var t = 0.0
# 僚机一共有6架循环飞行，受到攻击之后会立刻死掉
var distance = 0

func _on__friends(): # 触发僚机效果
	pass # 召唤僚机
	
	
func _process(delta): # 僚机效果其实一直存在，但是不显示
	$".".offset = 400 + distance
	$"../僚机4".position = $".".position
	distance += 10

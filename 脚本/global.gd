extends Node

var world = null # 获取当前场景用于创建子弹

func instance_node(node, location, parent, rotation):
		var node_instance = node.instance()
		parent.add_child(node_instance)
		node_instance.global_position = location
		node_instance.global_rotation = rotation
		return node_instance
	

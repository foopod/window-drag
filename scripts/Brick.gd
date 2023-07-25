extends RigidBody2D

var area

var row
var column

func _on_body_entered(body):
	if body.name == "Ball":
		Global.iconData[row][column] = false
		queue_free()

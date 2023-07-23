extends RigidBody2D

var area

var row
var column

# Called when the node enters the scene tree for the first time.
func _ready():
	area = get_node('Area2D')
	pass # Replace with function body.

func _on_body_entered(body):
	if body.name == "Ball":
		Global.iconData[row][column] = false
		queue_free()

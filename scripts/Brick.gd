extends RigidBody2D

var area

var row
var column

# Called when the node enters the scene tree for the first time.
func _ready():
	area = get_node('Area2D')
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var list = area.get_overlapping_bodies()
	for body in list:
		if body.name == "Ball":
			await get_tree().create_timer(0.03).timeout
			Global.iconData[row][column] = false
			queue_free()
	pass

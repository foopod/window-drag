extends RigidBody2D

var area

# Called when the node enters the scene tree for the first time.
func _ready():
	area = get_node("Area2D")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var list = area.get_overlapping_bodies()
	for body in list:
		if body.name == "Ball":
			queue_free()
	pass

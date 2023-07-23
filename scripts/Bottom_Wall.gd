extends CollisionShape2D

@export var brick_scene: PackedScene

var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body : Node):
	if body.name == "Ball":
		var count = 0
		for row in Global.iconData.size():
			for column in Global.iconData[row].size():
				if !Global.iconData[row][column]:
					if count > 5:
						pass
					else:
						count += 1
						var brick = brick_scene.instantiate()
						Global.iconData[row][column] = true
						brick.position = Vector2(60 + 100 * column, 200 + 100 * row)
						brick.row = row
						brick.column = column
						var sprite = brick.get_child(0)
						sprite.frame = rng.randi_range(0,9)
						%LevelOne.add_child(brick)
	pass # Replace with function body.

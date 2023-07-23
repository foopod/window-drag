extends Node2D

@export var brick_scene: PackedScene

var rowCount = 12
var colCount = 19

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	for row in rowCount:
		Global.iconData.append([])
		for col in colCount:
			if row < 5:
				Global.iconData[row].append(true)
				var brick = brick_scene.instantiate()
				brick.position = Vector2(60 + 100 * col, 200 + 100 * row)
				brick.row = row
				brick.column = col
				var sprite = brick.get_child(0)
				sprite.frame = rng.randi_range(0,9)
				add_child(brick)
			else:
				Global.iconData[row].append(false)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

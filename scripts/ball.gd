extends RigidBody2D

var rng = RandomNumberGenerator.new()

@export var brick_scene: PackedScene

@export var min_speed_no_icons = 600
@export var min_speed_added_per_icon = -2

func _integrate_forces(state):
	# Min speed inversely related to no. of icons visible by linear function
	var min_speed = min_speed_no_icons + Global.get_count_icons() * min_speed_added_per_icon
	var velocity : Vector2 = state.get_linear_velocity()
	var speed = velocity.length()
	if speed < min_speed && speed != 0:
		state.set_linear_velocity(min_speed * velocity.normalized())

func _on_body_entered(body):
	if body.name == "WorldBorderBottom":
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
						%BricksContainer.add_child(brick)
						
						# If we're adding an icon to the last row,
						# then we start a countdown to game over. 
						if row == Global.iconData.size() - 1 && !Global.is_game_over:
							await get_tree().create_timer(3).timeout
							Global.game_over()

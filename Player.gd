extends KinematicBody2D

const gravity = 900
const jump_power = 500
const floor_ = Vector2(0, -1)
const speed = 100

const rock = preload("res://Rock.tscn")

var is_throwing = false

var money = 0

var velocity  = Vector2()

func if_transporter_under_player_add_x_velocity():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if "Transporter" in collision.collider.name :
			print('on transporter')
			velocity.x += 30

func addMoney():
	money += 1

func _physics_process(delta):
	
	if Input.is_action_just_pressed("ui_accept") && is_on_floor() && !is_throwing:
		is_throwing = true
		$AnimatedSprite.play("throw")
	
	if is_throwing:
		return
	
	if is_on_floor() :
		$RunDust.show() 
	else :
		$RunDust.hide()
		
	
	if Input.is_action_pressed("ui_up")  && is_on_floor():
		velocity.y = -jump_power

		$JumpDust.show()
		$AnimatedSprite.frame = 0
		$JumpDust.frame = 0
		$JumpDust.play()
		$AnimatedSprite.play("jump")
		
	
	if Input.is_action_pressed("run_left"):
		$Position2D.position.x = abs($Position2D.position.x) * -1
		$AnimatedSprite.flip_h = true
		velocity.x = -2 * speed
		$AnimatedSprite.play("run")
		$RunDust.play("run")
		$RunDust.flip_h = true
		$RunDust.position.x = 15
	elif Input.is_action_pressed("run_right"):
		$Position2D.position.x = abs($Position2D.position.x)
		$AnimatedSprite.flip_h = false
		velocity.x = 2 * speed
		$AnimatedSprite.play("run")
		$RunDust.play("run")
		$RunDust.flip_h = false
		$RunDust.position.x = -15
	elif Input.is_action_pressed("ui_left") :
		$Position2D.position.x = abs($Position2D.position.x) * -1
		velocity.x = -speed
		$AnimatedSprite.flip_h = true
		if is_on_floor():
			$AnimatedSprite.play("walk")
	elif Input.is_action_pressed("ui_right") :
		$Position2D.position.x = abs($Position2D.position.x)
		velocity.x = speed
		$AnimatedSprite.flip_h = false
		if is_on_floor() :
			$AnimatedSprite.play("walk")
			
	else:
		velocity.x = 0
		$AnimatedSprite.play("idle")
		$RunDust.hide()
		$RunDust.stop()
		$RunDust.frame = 0
		
	if_transporter_under_player_add_x_velocity()
	velocity.y += (gravity * delta)
	velocity = move_and_slide(velocity, floor_)

func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "throw" && $AnimatedSprite.frame == 2:
		var r = rock.instance()
		r.global_position = $Position2D.global_position
		r.direction = sign($Position2D.position.x)
		r.set_as_toplevel(true)
		get_parent().add_child(r)
		is_throwing = false
		
		


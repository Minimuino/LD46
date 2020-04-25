extends KinematicBody2D

export (int) var speed = 300
export (float) var friction = .92

var velocity = Vector2()
var emergency_key_hits = 0
var grabbed_item
var grabbed_by
var grab_offset
var input_enabled = true

func _ready():
    $Bubbles.emitting = true
    $Sprite.frame = 0

func _input(event):
    if grabbed_by != null and event.is_action_pressed("ui_select"):
        emergency_key_hits += 1

func get_input(delta: float):
    var new_velocity = Vector2()
    if Input.is_action_pressed('ui_right'):
        new_velocity.x += 1
    if Input.is_action_pressed('ui_left'):
        new_velocity.x -= 1
    if Input.is_action_pressed('ui_down'):
        new_velocity.y += 1
    if Input.is_action_pressed('ui_up'):
        new_velocity.y -= 1
    if new_velocity.length() == 0:
        velocity *= friction
    else:
        velocity = new_velocity.normalized() * speed
    look_at(get_global_mouse_position())
    if Input.is_action_just_pressed("ui_accept"):
        $Sprite.frame = 1
        $ClawStreamPlayer.play()
        var bodies = $HoldArea.get_overlapping_bodies()
        for body in bodies:
            if body.is_in_group("trash"):
                body.grab(self, Vector2(0, -90).rotated(PI/2), true)
                grabbed_item = body
                break
    if Input.is_action_just_released("ui_accept"):
        $Sprite.frame = 0
        if grabbed_item != null and is_instance_valid(grabbed_item):
            grabbed_item.release()
            grabbed_item = null  

func _physics_process(delta):
    if input_enabled and grabbed_by == null:
        get_input(delta)
    elif emergency_key_hits > 10:
        release()
    velocity = move_and_slide(velocity)
    if grabbed_by != null:
        var parent_rotation = grabbed_by.get_global_transform().get_rotation()
        global_transform.origin = grabbed_by.get_global_transform().origin + grab_offset.rotated(parent_rotation)

func apply_shock():
    input_enabled = false
    $ShockStreamPlayer.play()
    $ShockSprite.visible = true
    $ShockSprite.play("default")
    velocity = Vector2(0, 0)
    if grabbed_item != null:
        grabbed_item.release()
        yield(get_tree().create_timer(.1), "timeout")
        grabbed_item.apply_impulse(Vector2(), Vector2(100, 100))
        grabbed_item = null
    yield(get_tree().create_timer(1.6), "timeout")
    input_enabled = true
    $ShockSprite.stop()
    $ShockSprite.visible = false

func grab(node: Node2D, offset: Vector2):
    grabbed_by = node
    grab_offset = offset
    get_parent().start_tension()

func release():
    grabbed_by = null
    grab_offset = null
    emergency_key_hits = 0
    get_parent().end_tension()

func is_free():
    return grabbed_by == null

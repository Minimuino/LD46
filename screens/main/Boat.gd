extends KinematicBody2D

const TRASH_LIMIT = 5
const SPEED = 200

export (PackedScene) var trash
export (int) var sprite

var rods = []
var trash_onboard = []
var leaving = false

func _ready():
    $AnimatedSprite.frame = sprite
    rods = [$Rod1, $Rod2, $Rod3, $Rod4]
    for rod in rods:
        rod.get_node("AnimationPlayer").play("rod_down")

func _process(_delta):
    for rod in rods:
        if rod.get_node("AnimationPlayer").is_playing():
            rod.update_hook_position(rod.get_node("Path2D/PathFollow2D").position)
    if trash_onboard.size() > TRASH_LIMIT:
        leave()
    if get_global_transform().origin.x > 5000 or get_global_transform().origin.x < -500:
        destroy()

func _physics_process(_delta):
    if leaving:
        var _velocity = move_and_slide(Vector2(-SPEED, 0))

func leave():
    if leaving:
        return
    leaving = true
    for rod in rods:
        rod.get_node("AnimationPlayer").play("rod_up")
        rod.disable_capture()
    $TrashTimer.stop()
    $AudioStreamPlayer2D.play()

func destroy():
    print("Freeing boat " + str(self))
    for rod in rods:
        rod.remove()
    for trash in trash_onboard:
        trash.queue_free()
    self.queue_free()
    get_parent().remove_boat()

func _on_TrashTimer_timeout():
    var new_trash = trash.instance()
    new_trash.position = $TrashSpawnPosition.global_position
    get_parent().add_child(new_trash)
    yield(get_tree().create_timer(.1), "timeout")
    new_trash.apply_impulse(Vector2(-40, 0), Vector2(50, -60))

func add_trash_onboard(new_trash):
    trash_onboard.append(new_trash)
    new_trash.grab(self, get_rel_pos(new_trash).origin)

func _on_Rod1AnimationPlayer_animation_finished(anim_name):
    if anim_name == "rod_up" and not leaving:
        $Rod1.confirm_capture()
        $Rod1/AnimationPlayer.play("rod_down")

func _on_Rod2AnimationPlayer_animation_finished(anim_name):
    if anim_name == "rod_up" and not leaving:
        $Rod2.confirm_capture()
        $Rod2/AnimationPlayer.play("rod_down")

func _on_Rod3AnimationPlayer_animation_finished(anim_name):
    if anim_name == "rod_up" and not leaving:
        $Rod3.confirm_capture()
        $Rod3/AnimationPlayer.play("rod_down")

func _on_Rod4AnimationPlayer_animation_finished(anim_name):
    if anim_name == "rod_up" and not leaving:
        $Rod4.confirm_capture()
        $Rod4/AnimationPlayer.play("rod_down")

func _on_Rod1_captured():
    $Rod1/AnimationPlayer.play("rod_up")

func _on_Rod2_captured():
    $Rod2/AnimationPlayer.play("rod_up")

func _on_Rod3_captured():
    $Rod3/AnimationPlayer.play("rod_up")

func _on_Rod4_captured():
    $Rod4/AnimationPlayer.play("rod_up")

func get_rel_pos(body):
    return get_global_transform().inverse() * body.get_global_transform()

func _on_RodN_game_over():
    get_parent().get_node("HUD").show_game_over()

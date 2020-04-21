extends Node2D

signal captured
signal game_over

var capture_enabled = false
var grabbed_item = null

func _ready():
    $Line2D.add_point(Vector2(0, 0))
    $Hook.move_local_y(rand_range(100, 200))
    $Line2D.add_point($Hook.position)

func update_hook_position(new_position: Vector2):
    $Hook.position = new_position
    $Line2D.set_point_position(1, new_position)

func confirm_capture():
    if grabbed_item == null:
        return
    if grabbed_item.is_in_group("fish"):
        grabbed_item.queue_free()
        GameData.store("total_fishes", GameData.get("total_fishes") - 1)
    if grabbed_item.is_in_group("trash"):
        grabbed_item.release()
        get_parent().add_trash_onboard(grabbed_item)
        GameData.store("total_trash_returned", GameData.get("total_trash_returned") + 1)
    if grabbed_item.is_in_group("player"):
        if not grabbed_item.is_free():
            emit_signal("game_over")
    grabbed_item = null

func _on_HookArea_body_entered(body):
    if capture_enabled:
        body.grab($Hook, Vector2(-30, 60))
        grabbed_item = body
        capture_enabled = false
        emit_signal("captured")

func remove():
    if grabbed_item != null and is_instance_valid(grabbed_item):
        grabbed_item.release()
    queue_free()

func enable_capture():
    capture_enabled = true

func disable_capture():
    capture_enabled = false

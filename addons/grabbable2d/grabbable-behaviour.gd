extends RigidBody2D
class_name Grabbable2D

signal grabbed
signal released

var grabbed_by
var grab_offset
var rotation_enabled

func _physics_process(delta):
    if grabbed_by != null:
        var parent_rotation = grabbed_by.get_global_transform().get_rotation()
        global_transform.origin = grabbed_by.get_global_transform().origin + grab_offset.rotated(parent_rotation)
        if rotation_enabled:
            rotation = parent_rotation

func grab(node: Node2D, offset: Vector2, rotate: bool = false):
    grabbed_by = node
    grab_offset = offset
    rotation_enabled = rotate
    set_deferred("mode", MODE_STATIC)
    emit_signal("grabbed")

func release():
    grabbed_by = null
    grab_offset = null
    set_deferred("mode", MODE_RIGID)
    emit_signal("released")

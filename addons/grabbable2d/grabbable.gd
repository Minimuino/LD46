tool
extends EditorPlugin

func _enter_tree():
    # Add the new type with a name, a parent type, a script and an icon
    add_custom_type("Grabbable2D", "RigidBody2D", preload("grabbable-behaviour.gd"), preload("icon.png"))

func _exit_tree():
    remove_custom_type("Grabbable2D")

extends Node2D

signal bite

func _on_Area2D_body_entered(body):
    emit_signal("bite")

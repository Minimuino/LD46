extends Area2D

signal shock_player

func _ready():
    $AnimatedSprite.play("move")

func _on_Eel_body_entered(body):
    if body.is_in_group("player"):
        body.apply_shock()

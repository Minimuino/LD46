extends Grabbable2D

func _ready():
    $Sprite.frame = randi() % 3

func _on_Self_grabbed():
    $CollisionShape2D.set_deferred("disabled", true)

func _on_Self_released():
    $CollisionShape2D.set_deferred("disabled", false)

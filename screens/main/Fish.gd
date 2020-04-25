extends Grabbable2D

export (int) var min_speed = 100
export (int) var max_speed = 400

func _ready():
    $Sprite.frame = randi() % 5
    yield(get_tree().create_timer(2), "timeout")
    $Bubbles.emitting = true

func _process(_delta):
    if get_global_transform().origin.x > 5000 or get_global_transform().origin.x < -500:
        queue_free()

func flip_v():
    $Sprite.flip_v = true

func _on_Self_grabbed():
    $AudioStreamPlayer2D.play()

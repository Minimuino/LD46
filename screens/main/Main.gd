extends Node2D

export (PackedScene) var Fish
export (PackedScene) var Trash
export (int) var trash_count = 20
export (int) var fish_count = 80

var boat_count = 4

func _ready():
    GameData.store("total_fishes", fish_count)
    for i in range(trash_count):
        $TrashSpawnPath/TrashSpawnPosition.offset = randi()
        var new_trash = Trash.instance()
        new_trash.position = $TrashSpawnPath/TrashSpawnPosition.position
        add_child(new_trash)

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()

func _process(delta):
    if boat_count <= 0:
        $HUD.show_you_win()
    if GameData.get("total_fishes") <= 0:
        $HUD.show_game_over()

func remove_boat():
    boat_count -= 1

func _on_FishSpawnTimer_timeout():
    $FishPath1/FishSpawnPosition.offset = randi()
    $FishPath2/FishSpawnPosition.offset = randi()
    var fish1 = Fish.instance()
    var fish2 = Fish.instance()
    add_child(fish1)
    add_child(fish2)
    fish1.position = $FishPath1/FishSpawnPosition.position
    fish2.position = $FishPath2/FishSpawnPosition.position
    fish1.rotation = $FishPath1/FishSpawnPosition.rotation - PI/2
    fish2.rotation = $FishPath2/FishSpawnPosition.rotation + PI/2
    fish2.flip_v()
    fish1.linear_velocity = Vector2(rand_range(fish1.min_speed, fish1.max_speed), 0)
    fish1.linear_velocity = fish1.linear_velocity.rotated(fish1.rotation)
    fish2.linear_velocity = Vector2(rand_range(fish2.min_speed, fish2.max_speed), 0)
    fish2.linear_velocity = fish2.linear_velocity.rotated(fish2.rotation)

func _on_OutsideArea_body_entered(body):
    if body.is_class("RigidBody2D"):
        body.gravity_scale = 1

func _on_OutsideArea_body_exited(body):
    if body.is_class("RigidBody2D"):
        body.gravity_scale = .10

func start_tension():
    $Music.stop()
    $TensionMusic.play()
    $HUD.show_press_space()
    
func end_tension():
    $Music.play()
    $TensionMusic.stop()
    $HUD.hide_press_space()

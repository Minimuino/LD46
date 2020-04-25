extends CanvasLayer

func show_press_space():
    $Control/PressSpace.visible = true
    $Control/PressSpace.play("default")

func hide_press_space():
    $Control/PressSpace.visible = false
    $Control/PressSpace.stop()

func show_game_over():
    get_tree().paused = true
    $Control/PressSpace.visible = false
    $GameOverLabel.visible = true
    $MainMenuButton.visible = true
    $RestartButton.visible = true
    if GameData.get("total_fishes") <= 0:
        $LostByFishesLabel.visible = true
    else:
        $LostByCaptureLabel.visible = true

func show_you_win():
    $Control/PressSpace.visible = false
    $MainMenuButton.visible = true
    $RestartButton.visible = true
    $ScoreLabel.visible = true
    $ScoreLabel.text = "Well Done! You saved " + str(GameData.get("total_fishes")) + " fishes!"

func _process(_delta):
    $FishLabel.text = str(GameData.get("total_fishes")) + "/" + str(get_parent().fish_count)

func _on_MainMenuButton_pressed():
    GameState.go_to_title_scene()

func _on_RestartButton_pressed():
    GameState.go_to_main_scene()

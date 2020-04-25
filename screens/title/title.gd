extends Node

export (PackedScene) var next_scene

func _ready():
    pass

func _input(event):
    if event.is_action_pressed("ui_select"):
        GameState.set_scene(next_scene, true)
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()

func _on_StartButton_pressed():
    GameState.set_scene(next_scene, true)

func _on_HowToPlayButton_pressed():
    $HowToPlay.visible = true

func _on_BackButton_pressed():
    $HowToPlay.visible = false

func _on_ToggleFullscreenButton_pressed():
    OS.window_fullscreen = !OS.window_fullscreen

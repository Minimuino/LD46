extends Path2D

func _process(_delta):
    $PathFollow2D2.unit_offset = $PathFollow2D.unit_offset + .25
    $PathFollow2D3.unit_offset = $PathFollow2D.unit_offset + .50
    $PathFollow2D4.unit_offset = $PathFollow2D.unit_offset + .75

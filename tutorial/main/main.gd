extends Node

export (PackedScene) var Mob
export (PackedScene) var Player
export (PackedScene) var Hud

var score
var hud

func _ready():
	randomize()
	$MobTimer.connect("timeout", self, "_on_MobTimer_timeout")
	$ScoreTimer.connect("timeout", self, "_on_ScoreTimer_timeout")
	$StartTimer.connect("timeout", self, "_on_StartTimer_timeout")
	
	hud = Hud.instance()
	hud.connect("start_game", self, "new_game")
	add_child(hud)

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	hud.show_game_over()

func new_game():
	
	score = 0
	
	var player = Player.instance()
	player.start($StartPosition.position)
	add_child(player)
	
	$StartTimer.start()
	
	hud.update_score(score)
	hud.show_message("Get Ready")

func _on_StartTimer_timeout():
	
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	
	score += 1
	hud.update_score(score)

func _on_MobTimer_timeout():
	
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

extends Node

@export var lock: Lock;
@export var indicator: Indicator;
@export var score_label: Label;
@export var gameController: GameController;

@export var min_spawn_distance: float = 60;

@export_group("Lock Speed")
@export var max_lock_speed: float = 7.0;
@export var lock_speed: float = 2.0:
	set(speed):
		lock_speed = min(speed, max_lock_speed);
		indicator.rotation_speed = lock_speed;
@export var lives: int = 1;

var score: int = 0:
	set(new_score):
		score = new_score;
		score_label.text = str(score);
		if score < 100:
			score_label.add_theme_font_size_override("font_size", 260);
		elif score >= 100:
			score_label.add_theme_font_size_override("font_size", 190);
		elif score >= 1000:
			score_label.add_theme_font_size_override("font_size", 145);


func _ready():
	gameController.missed_arcs.connect(func():
		DebugUI.log("arc missed");
		lives -= 1;
		DebugUI.log("lives %s" % lives);
		if lives <= 0:
			_lose();
	);
	gameController.selected_arc.connect(func(arc_name):
		DebugUI.log("arc selected: %s" % arc_name);
		_update_score(arc_name);
		_scale_difficulty();
		_choose_lock_angle();
	);

	Ads.on_reward_failed_to_earn.connect(func():
		DebugUI.log("Reward Failed to Earn");
		ScreenManager.switch_to("TryAgain");
	);

	Ads.on_reward_earned.connect(func(type: String, amount: int):
		DebugUI.log("Reward Earned %s %s" % [type, amount]);
		lives += 1;
		GlobalState.allow_extra_life = false;
		ScreenManager.switch_to("TapToResume");
	);


func start() -> void:
	indicator.direction = T.Direction.CLOCKWISE;


func init() -> void:
	score = 0;
	lives = 1;
	_scale_difficulty();
	indicator.direction = T.Direction.NONE;
	GlobalState.allow_extra_life = true;
	_choose_lock_angle();

	var logs := PackedStringArray();
	logs.append("score: %s" % score);
	logs.append("lives: %s" % lives);
	logs.append("lock angle: %s" % lock.angle);
	logs.append("lock angle: %s" % lock.angle);
	DebugUI.log("\n".join(logs));


func restart() -> void:
	if lives > 0:
		DebugUI.log("Resuming game...");
		indicator.direction = previous_direction;
	else:
		DebugUI.log("Starting new game...");
		DebugUI.log("lives: %s" % lives);
		GlobalState.allow_extra_life = true;
		Themes.get_random_theme();
		score = 0;
		lives = 1;
		_scale_difficulty();
		indicator.direction = T.Direction.CLOCKWISE;

	_choose_lock_angle();


func _scale_difficulty() -> void:
	lock_speed = 2.0 + 0.125 * int(score / 5.0);


func _update_score(arc_name: String) -> void:
	score += _get_point_value(arc_name);


func _get_point_value(arc_name: String) -> int:
	indicator.emit();
	match arc_name:
		'red':
			EventBus.crit.emit();
			return 3;
		'orange':
			return 2;
		'yellow':
			return 1;
		_:
			return 0;


var previous_direction: T.Direction;
func _lose() -> void:
	previous_direction = indicator.direction as T.Direction;
	indicator.direction = T.Direction.NONE;
	EventBus.lost.emit(score);


func _choose_lock_angle() -> void:
	var angle := rad_to_deg(indicator.rotation);
	lock.reverse = indicator.direction == T.Direction.COUNTER_CLOCKWISE;
	lock.angle = randf_range(
		angle + min_spawn_distance,
		angle + 360 - min_spawn_distance
	);

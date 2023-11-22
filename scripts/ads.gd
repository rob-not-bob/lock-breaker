extends Node

var ADS = {
	"android": {
		"banner": {
			"test": "ca-app-pub-3940256099942544/6300978111",
			"prod": "ca-app-pub-3502216226418364/3112329634"
		}
	},
	"ios": {
		"banner": {
			"test": "ca-app-pub-3940256099942544/2934735716",
			"prod": "NOT-YET-IMPLEMENTED"
		}
	}
}

func _ready():
	MobileAds.initialize();

var _ad_view: AdView;
func _create_ad_view() -> void:
	#free memory
	if _ad_view:
		destroy_ad_view()

	var unit_id: String
	if OS.get_name() == "Android":
			unit_id = ADS.android.banner.test;
	elif OS.get_name() == "iOS":
		unit_id = ADS.ios.banner.test;

	_ad_view = AdView.new(unit_id, AdSize.BANNER, AdPosition.Values.BOTTOM)

func _on_load_banner_pressed():
	start_time = Time.get_ticks_msec();
	print('set start time to ', start_time);
	if _ad_view == null:
		_create_ad_view()

	var ad_request := AdRequest.new()
	_ad_view.load_ad(ad_request)


func destroy_ad_view() -> void:
	if _ad_view:
		_ad_view.destroy()
		_ad_view = null


var MIN_AD_TIME_SECONDS: int = 60;
var start_time: int;
func load_banner():
	if not start_time:
		_on_load_banner_pressed();
		return;

	var ad_duration_seconds: float = (Time.get_ticks_msec() - start_time) / 1000.0;
	if ad_duration_seconds > MIN_AD_TIME_SECONDS:
		_on_load_banner_pressed();
	else:
		print("Not enough time has passed to show new ad. Duration: ", ad_duration_seconds, " seconds");


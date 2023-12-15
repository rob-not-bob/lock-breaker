extends Node

const adConfig = preload("res://scripts/adConfig.gd");
const AdType = adConfig.AdType;
const Platform = adConfig.Platform;
const Env = adConfig.Env;

func _ready():
	MobileAds.initialize();


# Returns the ad id for adType if defined
func _get_ad_id(adType: AdType) -> String:
	var platformAds: Dictionary;
	match OS.get_name():
		"Android":
			platformAds = adConfig.ADS[Platform.Android];
		"iOS":
			platformAds = adConfig.ADS[Platform.IOS];
		_:
			return "NA";

	var env := Env.Test if OS.is_debug_build() else Env.Prod;

	return platformAds.get(adType)[env];


# Destroys any existing adType in _ads dict
func _destroy_ad_view(adType: AdType) -> void:
	if _ads.get(adType):
		_ads[adType].destroy();
		_ads[adType] = null;


# Initializes the ad into the _ads dict
func _initAd(adType: AdType, adId: String) -> void:
	match adType:
		AdType.Banner:
			_ads[adType] = AdView.new(adId, AdSize.BANNER, AdPosition.Values.BOTTOM);
		AdType.RewardedInterstitial:
			var rewarded_interstitial_ad_load_callback := RewardedInterstitialAdLoadCallback.new()
			rewarded_interstitial_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
					print(adError.message)

			rewarded_interstitial_ad_load_callback.on_ad_loaded = func(rewarded_interstitial_ad : RewardedInterstitialAd) -> void:
					print("rewarded interstitial ad loaded" + str(rewarded_interstitial_ad._uid))
					_ads[adType] = rewarded_interstitial_ad;

			return RewardedInterstitialAdLoader.new().load(adId, AdRequest.new());

var _ads = {};
func _load_ad(adType: AdType) -> void:
	if _ads.get(adType):
		_destroy_ad_view(adType);
	
	var ad_id: String = _get_ad_id(adType);
	if ad_id == "NA":
		return;

	_initAd(adType, ad_id);


func _on_load_banner_pressed():
	start_time = Time.get_ticks_msec();
	if _ads.get(AdType.Banner) == null:
		_load_ad(AdType.Banner);

	var ad_request := AdRequest.new()
	_ads[AdType.Banner].load_ad(ad_request)


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


package lime;


import lime.utils.Assets;


class AssetData {

	private static var initialized:Bool = false;
	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();	
	
	public static function initialize():Void {
		
		if (!initialized) {
			
			path.set ("assets/maps/tiles.png", "assets/maps/tiles.png");
			type.set ("assets/maps/tiles.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/level1.tmx", "assets/level1.tmx");
			type.set ("assets/level1.tmx", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/princess.png", "assets/princess.png");
			type.set ("assets/princess.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/xswx.tmx", "assets/xswx.tmx");
			type.set ("assets/xswx.tmx", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/tiles.png", "assets/tiles.png");
			type.set ("assets/tiles.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/princess.json", "assets/princess.json");
			type.set ("assets/princess.json", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("flixel/sounds/beep.ogg", "flixel/sounds/beep.ogg");
			type.set ("flixel/sounds/beep.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("flixel/sounds/flixel.ogg", "flixel/sounds/flixel.ogg");
			type.set ("flixel/sounds/flixel.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("flixel/fonts/nokiafc22.ttf", "flixel/fonts/nokiafc22.ttf");
			type.set ("flixel/fonts/nokiafc22.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			path.set ("flixel/fonts/monsterrat.ttf", "flixel/fonts/monsterrat.ttf");
			type.set ("flixel/fonts/monsterrat.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			path.set ("flixel/images/ui/button.png", "flixel/images/ui/button.png");
			type.set ("flixel/images/ui/button.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("flixel/images/logo/default.png", "flixel/images/logo/default.png");
			type.set ("flixel/images/logo/default.png", Reflect.field (AssetType, "image".toUpperCase ()));
			
			
			initialized = true;
			
		} //!initialized
		
	} //initialize
	
	
} //AssetData

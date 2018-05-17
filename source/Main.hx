package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.util.FlxSave;
import flixel.system.FlxSound;
import flixel.FlxG;
class Main extends Sprite
{	
	public static var LOGGER:CapstoneLogger;
	public static var SAVE:FlxSave;
	public function new()
	{
		super();
		var gameId:Int = 1803;
		var gameKey:String = "c892cc326c959b61794b7ff5860e2e44";
		var gameName:String = "islandescape";
		var categoryId:Int = 2;
		var useDev:Bool = true;
		Main.LOGGER = new CapstoneLogger(gameId, gameName, gameKey, categoryId, useDev);
		Main.SAVE = new FlxSave();
		Main.SAVE.bind("levels");
		if (Main.SAVE.data.levels == null) {
			Main.SAVE.data.levels = new Array<Int>();
			Main.SAVE.data.levels.push(1);
			Main.SAVE.flush();
		}
		// Retrieve the user (saved in local storage for later)
		var userId:String = Main.LOGGER.getSavedUserId();
		if (userId == null)
		{
			userId = Main.LOGGER.generateUuid();
			Main.LOGGER.setSavedUserId(userId);
		}
		Main.LOGGER.startNewSession(userId, this.onSessionReady);
	}

	private function onSessionReady(sessionRecieved:Bool):Void
	{
		addChild(new FlxGame(640, 480, StartState, true));
	}


		

}
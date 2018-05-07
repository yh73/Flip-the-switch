package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{	
	public static var LOGGER:CapstoneLogger;
	public function new()
	{
		super();
		var gameId:Int = 1803;
		var gameKey:String = "c892cc326c959b61794b7ff5860e2e44";
		var gameName:String = "islandescape";
		var categoryId:Int = 1;
		var useDev:Bool = true;
		Main.LOGGER = new CapstoneLogger(gameId, gameName, gameKey, categoryId, useDev);
		
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
		addChild(new FlxGame(640, 480, MenuState));
	}

}
package; 

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class EndState extends FlxState
{
	// public var player:FlxSprite;
	// public var floor:FlxObject;
	// public var exit:FlxSprite;

	private var _btnPlay:FlxButton;
	private var intro:FlxText;
	private var switchOn:FlxSprite;
	private var switchOff:FlxSprite;
	private static var youDied:Bool = false;
	
	override public function create():Void 
	{   
        intro = new FlxText(160,80, "More coming soon", 30);
        //add(_btnPlay);
		switchOff = new FlxSprite(195, 130).loadGraphic("assets/switchOff.png");
		switchOn = new FlxSprite(195, 81).loadGraphic("assets/switchOn.png");
		intro.alignment = FlxTextAlign.CENTER;
		add(switchOff);
		add(switchOn);
		add(intro);
		switchOff.kill();
		super.create();
		
	}

	private function onTimer(Timer:FlxTimer):Void {
		FlxG.switchState(new StartState());
	}

	override public function update(elapsed:Float):Void 
	{	
		if (FlxG.mouse.overlaps(switchOff, null) && FlxG.mouse.justPressed) {
			switchOn.kill();
			switchOff.revive();
			var timer = new FlxTimer();
			Main.LOGGER.logLevelStart(0);
			timer.start(0.1, onTimer, 1);
		}
		
		super.update(elapsed);
	}
	
}
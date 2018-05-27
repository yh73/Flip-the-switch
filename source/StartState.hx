package; 

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class StartState extends FlxState
{
	// public var player:FlxSprite;
	// public var floor:FlxObject;
	// public var exit:FlxSprite;

	private var _btnPlay:FlxButton;
	private var intro:FlxText;
	private var switchOn:FlxSprite;
	private var switchOff:FlxSprite;
	private static var youDied:Bool = false;
	private var menu:MenuState;
	private var popup:Popup;
	override public function create():Void 
	{   
        intro = new FlxText(180,80, "Flip the Switch", 30);
        //add(_btnPlay);
		menu = new MenuState();
		switchOff = new FlxSprite(195, 130).loadGraphic("assets/switchOff.png");
		switchOn = new FlxSprite(195, 81).loadGraphic("assets/switchOn.png");
		intro.alignment = FlxTextAlign.CENTER;
		add(switchOff);
		add(switchOn);
		add(intro);
		switchOn.kill();
		super.create();
	}

	private function onTimer(Timer:FlxTimer):Void {
		FlxG.switchState(menu);
	}

	override public function update(elapsed:Float):Void 
	{	
		if (FlxG.mouse.overlaps(switchOff, null) && FlxG.mouse.justPressed) {
			
			switchOff.kill();
			switchOn.revive();
			var timer = new FlxTimer();
			// Main.LOGGER.logLevelStart(0);
			timer.start(0.1, onTimer, 1);
		}
		
		super.update(elapsed);
	}
	
}
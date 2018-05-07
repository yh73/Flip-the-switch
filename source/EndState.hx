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
        intro = new FlxText(130,80, "More Coming Soon", 30);
		add(intro);
		super.create();
		
	}

	private function onTimer(Timer:FlxTimer):Void {
		FlxG.switchState(new PlayState(10));
	}

	override public function update(elapsed:Float):Void 
	{	
		super.update(elapsed);
	}
	
}
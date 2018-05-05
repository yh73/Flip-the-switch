package; 

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

class MenuState extends FlxState
{
	// public var player:FlxSprite;
	// public var floor:FlxObject;
	// public var exit:FlxSprite;

	private var _btnPlay:FlxButton;
	private var intro:FlxText;

	private static var youDied:Bool = false;
	
	override public function create():Void 
	{   
        _btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		intro = new FlxText(80,260, "E to interact, B to open backpack, Space to shoot", 16);
        add(_btnPlay);
		intro.alignment = FlxTextAlign.CENTER;
		add(intro);
        _btnPlay.screenCenter();

		super.create();
		
	}

	private function clickPlay():Void
    {
        FlxG.switchState(new PlayState(3));
    }

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}
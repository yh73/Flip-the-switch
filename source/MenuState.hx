package; 

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class MenuState extends FlxState
{
	// public var player:FlxSprite;
	// public var floor:FlxObject;
	// public var exit:FlxSprite;

	private var _btnPlay:FlxButton;
	private var intro:FlxText;
	private var switchOn:FlxSprite;
	private var switchOff:FlxSprite;
    private var levels:FlxTypedGroup<FlxButton>;
	private static var youDied:Bool = false;
	
	override public function create():Void 
	{   
        levels = new FlxTypedGroup<FlxButton>();
        intro = new FlxText(180,60, "Flip the Switch", 30);
        //add(_btnPlay);
        var i: Int;
        for (i in 0...25) {
            var level = new FlxButton(120 + i % 5 * 80, 120 + Std.int(i / 5) * 60, Std.string(i + 1), loadLevel);
            levels.add(level);
            if (Main.SAVE.data.levels.length <= i) {
                level.visible = false;
            }
        }
		add(intro);
        add(levels);
		super.create();
		
	}

	private function loadLevel():Void {
        var levelNumber = Std.int((FlxG.mouse.x - 120) / 80) + 5 * Std.int((FlxG.mouse.y - 120) / 60);
		FlxG.switchState(new PlayState(levelNumber));
	}

	override public function update(elapsed:Float):Void 
	{	
		super.update(elapsed);
	}
	
}
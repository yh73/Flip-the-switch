package; 

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
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
            level.loadGraphic("assets/unselected.png");
            level.label.size = 14;
            level.label.color = FlxColor.WHITE;
            levels.add(level);
        }
		add(intro);
        add(levels);
		super.create();
		
	}

	private function loadLevel():Void {
        var levelNumber = Std.int((FlxG.mouse.x - 120) / 80) + 5 * Std.int((FlxG.mouse.y - 120) / 60);
		if (levelNumber < Main.SAVE.data.levels.length && levelNumber < 22) {
            Main.LOGGER.logLevelStart(levelNumber);
            FlxG.switchState(new PlayState(levelNumber));
        } else if (levelNumber >= 22) {
            FlxG.switchState(new EndState());
        }
	}

	override public function update(elapsed:Float):Void 
	{	
        var i = 0;
        for (level in levels) {
            if (Main.SAVE.data.levels.length <= i){
                level.loadGraphic("assets/locked.png");
                level.label.visible = false;
            } else if (FlxG.mouse.overlaps(level, null) ) {
                level.loadGraphic("assets/selected.png");
            } else {
                level.loadGraphic("assets/unselected.png");
            }
            i++;
        }
		super.update(elapsed);
	}
	
}
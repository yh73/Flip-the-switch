
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledMap;

class Block extends FlxSprite {
    public var block:FlxSprite;
    var level:Level;
    var state:PlayState;

    override public function new(X:Float = 0, Y:Float = 0, l:Level, playstate: PlayState) {
        super(-100, -100);
        block = new FlxSprite(X, Y);
		block.loadGraphic("assets/block.png");
        level = l;
        state = playstate; 
	
    }

    override public function update(elapsed:Float):Void 
    {
        updateBlock();
        if (FlxG.overlap(state.slingshot.playerBullets, level.buttonGroup)
			|| (FlxG.overlap(state.player, level.buttonGroup) && FlxG.keys.anyJustPressed([E]))) {
			moveBlock();
		}
    }

    public function updateBlock():Void
	{
		if (FlxG.overlap(state.player, block)) {
			if (block.velocity.y > 0) {
				state.player.y++;
			}
			else if (block.velocity.y < 0) {
				state.player.y--;
			}
		}
		else if (FlxG.overlap(state.player, level.waterGroup)) {
			FlxG.switchState(new PlayState(state._levelNumber));
		}
		if (block.velocity.y > 0) {
			FlxG.overlap(block, level.waterFront, stopSprite);
		}
		else if (block.velocity.y < 0) {
			FlxG.overlap(block, level.waterBack, stopSprite);
		}
	}

	private function stopSprite(Object1:FlxSprite, Object2:FlxObject):Void
	{
		Object1.velocity.y = 0;
	}


	public function moveBlock():Void
	{
		if (FlxG.overlap(block, level.waterBack)) {
			block.velocity.y = 60;
		}
		else if (FlxG.overlap(block, level.waterFront)) {
			block.velocity.y = -60;
		}
	}


}
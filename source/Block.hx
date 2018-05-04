
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
		if (FlxG.overlap(state.player, block)) {
			if (block.velocity.y > 0) {
				state.player.y++;
			}
			else if (block.velocity.y < 0) {
				state.player.y--;
			}
			else if (block.velocity.x > 0) {
				state.player.x++;
			}
			else if (block.velocity.x < 0) {
				state.player.x--;
			}

		}
		if (block.velocity.y > 0) {
			FlxG.overlap(block, level.waterFront, stopBlockY);
		}
		else if (block.velocity.y < 0) {
			FlxG.overlap(block, level.waterBack, stopBlockY);
		}
		else if (block.velocity.x > 0) {
			FlxG.overlap(block, level.waterRight, stopBlockX);
		}
		else if (block.velocity.x < 0) {
			FlxG.overlap(block, level.waterLeft, stopBlockX);
		}
    }

	private function stopBlockY(Object1:FlxSprite, Object2:FlxObject):Void
	{
		Object1.velocity.y = 0;
	}

	private function stopBlockX(Object1:FlxSprite, Object2:FlxObject):Void
	{
		Object1.velocity.x = 0;
	}
}
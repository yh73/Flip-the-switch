
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
	public var currSpeedX:Float;
	public var currSpeedY:Float;
	public var needMove:Bool;
    var level:Level;
    var state:PlayState;

    override public function new(X:Float = 0, Y:Float = 0, l:Level, playstate: PlayState) {
        super(-100, -100);
        block = new FlxSprite(X, Y);
		block.loadGraphic("assets/block.png");
		currSpeedX = 0;
		currSpeedY = 0;
		needMove = false;
        level = l;
        state = playstate; 
    }

    override public function update(elapsed:Float):Void 
    {
		if (FlxG.overlap(state.player, block) 
			&& !FlxG.overlap(state.player, level.doorGroup)
			&& !FlxG.overlap(state.player, level.collisionGroup)) {
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
			FlxG.overlap(block, level.waterFrontGroup, stopBlock);
		}
		else if (block.velocity.y < 0) {
			FlxG.overlap(block, level.waterBackGroup, stopBlock);
		}
		else if (block.velocity.x > 0) {
			FlxG.overlap(block, level.waterRightGroup, stopBlock);
		}
		else if (block.velocity.x < 0) {
			FlxG.overlap(block, level.waterLeftGroup, stopBlock);
		}
		
		if (!needMove) {
			FlxG.overlap(block, level.collisionGroup, stopBlock);
			FlxG.overlap(block, level.doorGroup, stopBlock);
		}
		

    }

	private function stopBlock(Object1:FlxSprite, Object2:FlxObject):Void
	{
		Object1.velocity.x = Object1.velocity.y = 0;
	}
}
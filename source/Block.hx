
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
	public var name:String;

    override public function new(X:Float = 0, Y:Float = 0, blockName:String, l:Level, playstate: PlayState) {
        super(-100, -100);
        block = new FlxSprite(X, Y);
		block.loadGraphic("assets/block.png");
		currSpeedX = 0;
		currSpeedY = 0;
		name = blockName;
		needMove = false;
        level = l;
        state = playstate; 
    }

    override public function update(elapsed:Float):Void 
    {
		if ((state.player.playerBlock == name) 
			&& !FlxG.overlap(state.player, level.doorGroup)
			&& !FlxG.overlap(state.player, level.collisionGroup)) {
			if (block.velocity.y > 0) {
				state.player.y += 75.0/60;
			}
			else if (block.velocity.y < 0) {
				state.player.y -= 75.0/60;
			}
			else if (block.velocity.x > 0) {
				state.player.x += 75.0/60;
			}
			else if (block.velocity.x < 0) {
				state.player.x -= 75.0/60;
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
		
		var item = level.blockItem[this];
		if (item != null) {
			if (block.velocity.y > 0) {
				item.y += 75.0/60;
				level.itemArea[item].y += 75.0/60;
			}
			else if (block.velocity.y < 0) {
				item.y -= 75.0/60;
				level.itemArea[item].y -= 75.0/60;		
			}
			else if (block.velocity.x > 0) {
				item.x += 75.0/60;
				level.itemArea[item].x += 75.0/60;
			}
			else if (block.velocity.x < 0) {
				item.x -= 75.0/60;
				level.itemArea[item].x -= 75.0/60;
			}
		}
    }


	private function stopBlock(Object1:FlxSprite, Object2:FlxObject):Void
	{
		Object1.velocity.x = Object1.velocity.y = 0;
	}
}
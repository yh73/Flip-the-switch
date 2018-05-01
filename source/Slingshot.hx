
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledMap;

class Slingshot extends FlxSprite {
    var player:Character;
    var powerBar:PowerBar;
    public var lifeSpan:Float;
    var percent:Float;
    public var playerBullets:FlxTypedGroup<FlxSprite>;
    var bulletLife:Map<FlxSprite, Float>;

    override public function new(charater:Character, pb:PowerBar) {
        super();
        player = charater;
        powerBar = pb;
        percent = 0;
        powerBar.kill();
        bulletLife = new Map<FlxSprite, Float>();
        // 100 bullets
		var numPlayerBullets:Int = 100;
		// Initializing the array is very important and easy to forget!
		playerBullets = new FlxTypedGroup(numPlayerBullets);
		var sprite:FlxSprite;
		
		// Create 100 bullets for the player to recycle
		for (i in 0...numPlayerBullets)
		{
			// Instantiate a new sprite offscreen
			sprite = new FlxSprite( -100, -100);
			// Create a 3x3 white box
			sprite.makeGraphic(3, 3);
			sprite.exists = false;
			// Add it to the group of player bullets
			playerBullets.add(sprite);
		}
    }

    override public function update(elapsed:Float):Void 
    {
        if (FlxG.keys.anyJustPressed([P]) && !powerBar.alive && percent == 0) {
            powerBar.revive();
        }
        else if (FlxG.keys.anyJustPressed([P]) && powerBar.alive) {
            lifeSpan = powerBar.generateResult();
            // Space bar was pressed! FIRE A BULLET
			var bullet:FlxSprite = playerBullets.recycle();
			bullet.reset(player.x + 16 - bullet.width/2, player.y);
			if (player.facing == FlxObject.RIGHT) {
					bullet.velocity.x = 400;
			}
			else if (player.facing == FlxObject.LEFT) {
					bullet.velocity.x = -400;
			}
			else if (player.facing == FlxObject.UP) {
					bullet.velocity.y = -400;
			}
			else if (player.facing == FlxObject.DOWN) {
					bullet.velocity.y = 400;
			}
            if (lifeSpan <= 0) {
                lifeSpan = 1/10;
            }
            bulletLife[bullet] = lifeSpan;
        }

        for (bullet in bulletLife.keys()) {
            var time = bulletLife[bullet];
            if (time > 0) {
                time -= elapsed;
                if (time <= 0) {
                    bullet.kill();
                }
                bulletLife[bullet] = time;
            }
        }
    }

}
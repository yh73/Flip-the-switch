
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
    public var playerBullets:FlxTypedGroup<FlxSprite>;
    var bulletLife:Map<FlxSprite, Float>;
    var backpack:Backpack;
    var needCD:Bool;
    public var cooldown:FlxSprite;
    var cdColor:FlxColor;
    var cdLength:Int;
    var cdIndex:Int;

    override public function new(charater:Character, pb:PowerBar, backpack:Backpack) {
        super(0, 0);
        makeGraphic(1,1);
        player = charater;
        powerBar = pb;
        powerBar.kill();

        // cooldown initialization
		cooldown = new FlxSprite(-100, -100);
        cdColor = new FlxColor();
        cdColor.setRGBFloat(0.5, 0.5, 0.5, 0.75);
		cooldown.exists = false;
        needCD = false;
        cdLength = 45;

        bulletLife = new Map<FlxSprite, Float>();
        // 100 bullets
		var numPlayerBullets:Int = 100;
		// Initializing the array is very important and easy to forget!
		playerBullets = new FlxTypedGroup(numPlayerBullets);
		var sprite:FlxSprite;
		this.backpack = backpack;
		// Create 100 bullets for the player to recycle
		for (i in 0...numPlayerBullets)
		{
			// Instantiate a new sprite offscreen
			sprite = new FlxSprite(-100, -100);
			// Create a 3x3 white box
			sprite.makeGraphic(3, 3);
			sprite.exists = false;
			// Add it to the group of player bullets
			playerBullets.add(sprite);
		}
    }

    override public function update(elapsed:Float):Void 
    {
        /*
        if (FlxG.keys.justPressed.SPACE && !powerBar.alive && backpack.hasSlingshot) {
            powerBar.revive();
        }
        else if (FlxG.keys.justReleased.SPACE && powerBar.alive && backpack.hasSlingshot) {
        */
        if (FlxG.keys.justPressed.SPACE && backpack.hasSlingshot && (!needCD)) {
            //Main.LOGGER.logLevelAction(LoggingInfo.USE_SLINGSHOT, {coor: player.x + ", " + player.y});
            FlxG.sound.playMusic("assets/slingshotShoot.ogg", 1, false);
            // lifeSpan = powerBar.generateResult();
            lifeSpan = 0.85;
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
            /*
            if (lifeSpan <= 0) {
                lifeSpan = 1/10;
            }
            */
            bulletLife[bullet] = lifeSpan;
            needCD = true;
            cdLength = 45;
            cdIndex = backpack.currentItemIdx;
            cooldown.makeGraphic(45, 45, cdColor);
            var cdX = FlxG.camera.scroll.x + 165 + 45 * cdIndex;
            var cdY = FlxG.camera.scroll.y + 435;
            cooldown.reset(cdX, cdY);
        } 
        /* else if (!backpack.hasLasso && !backpack.hasSlingshot) {
            powerBar.kill();
        }
        */
        else if (needCD) {
            cdLength--;
            cooldown.makeGraphic(45, cdLength, cdColor);
            var cdX = FlxG.camera.scroll.x + 165 + 45 * cdIndex;
            var cdY = FlxG.camera.scroll.y + 435;
            cooldown.reset(cdX, cdY);
            if (cdLength == 0) {
                needCD = false;
            }
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
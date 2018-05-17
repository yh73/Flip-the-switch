import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.ui.FlxUILine;

class Lasso extends FlxSprite{
    var player:Character;
    var size:Int;
    public var lifeSpan:Float;
	var powerBar:PowerBar;
    var length:Int;
    var maxLength:Float;
    public var end:FlxObject;
    public var backpack:Backpack;
    var lassoColor:FlxColor;
    var needCD:Bool;
    public var cooldown:FlxSprite;
    var cdColor:FlxColor;
    var cdLength:Int;
    var cdIndex:Int;
    static var SPEED = 25;

    override public function new(size:Int, charater:Character, powerBar:PowerBar, backpack:Backpack) {
        player = charater;
        this.size = size;
        this.powerBar = powerBar;
        this.length = 0;
        this.backpack = backpack;
        super(Std.int(player.x + 10), Std.int(player.y + size / 2));
        this.end = new FlxObject(this.x, this.y, 4, 4);
        lassoColor = new FlxColor();
        lassoColor.setRGBFloat(135.0/256, 86.0/256, 56.0/256, 1);
        //,HORIZONTAL, 0, 2, FlxColor.WHITE);
        //createFilledBar(FlxColor.TRANSPARENT, FlxColor.WHITE);
        //diff = 0;
        cooldown = new FlxSprite(-100, -100);
        cooldown.scrollFactor.set();
        cdColor = new FlxColor();
        cdColor.setRGBFloat(0.5, 0.5, 0.5, 0.75);
		cooldown.exists = false;
        needCD = false;
        cdLength = 45;
    }

    override public function update(elapsed:Float):Void {
        /*
		if (FlxG.keys.justPressed.SPACE && !powerBar.alive && length == 0 && backpack.hasLasso) {
			powerBar.revive();
		} else if (FlxG.keys.justReleased.SPACE && powerBar.alive && backpack.hasLasso) {
            //Main.LOGGER.logLevelAction(LoggingInfo.USE_LASSO, {coor: player.x + ", " +player.y});
            FlxG.sound.playMusic("assets/lassoShoot.ogg", 1, false);
			lifeSpan = powerBar.generateResult();
            maxLength = lifeSpan * 400;
		} else if (!backpack.hasLasso && !backpack.hasSlingshot) {
            powerBar.kill();
        }
        */
        if (FlxG.keys.justPressed.SPACE && backpack.hasLasso && (!needCD)) {
            FlxG.sound.playMusic("assets/lassoShoot.ogg", 1, false);
            lifeSpan = 1;
            maxLength = lifeSpan * 400;
            needCD = true;
            cdLength = 45;
            cdIndex = backpack.currentItemIdx;
            cooldown.makeGraphic(45, 45, cdColor);
            var cdX = FlxG.camera.x + 165 + 45 * cdIndex;
            var cdY = FlxG.camera.y + 435;
            cooldown.reset(cdX, cdY);
        } else if (needCD) {
            cdLength--;
            cooldown.makeGraphic(45, cdLength, cdColor);
            var cdX = FlxG.camera.x + 165 + 45 * cdIndex;
            var cdY = FlxG.camera.y + 435;
            cooldown.reset(cdX, cdY);
            if (cdLength == 0) {
                needCD = false;
            }
        }

        if (lifeSpan > 0) {
            if (length <= maxLength - SPEED) {
                length += SPEED;
            } else {
                length = Std.int(maxLength);
            }
            player.moves = false;
            player.controllable = false;
            if (player.facing == FlxObject.LEFT) {
                this.y = player.y;
                if (this.x - player.x - size/2 - SPEED <= maxLength) {
                    this.x -= SPEED;
                } else {
                    this.x = player.x + size/2 + maxLength;
                }
                end.x = this.x;
                end.y = this.y;
                makeGraphic(length, 3, lassoColor);
            } else if (player.facing == FlxObject.UP) {
                this.x = player.x + 12;
                if (this.y - player.y - size/2 - SPEED <= maxLength) {
                    this.y -= SPEED;
                } else {
                    this.y = player.y + size/2 + maxLength;
                }
                end.y = this.y;
                end.x = this.x;
                makeGraphic(3, length, lassoColor);
            } else if (player.facing == FlxObject.DOWN) {
                this.x = player.x + 12;
                this.y = player.y;
                end.y = this.y + length;
                end.x = this.x;
                makeGraphic(3, length, lassoColor);
            } else {
                this.x = player.x + 12;
                this.y = player.y;
                end.x = this.x + length;
                end.y = this.y;
                makeGraphic(length, 3, lassoColor);
            }
            lifeSpan -= 6*elapsed;
        } else {
            length = 0;
            player.moves = true;
            player.controllable = true;
            this.x = player.x + 12;
            this.y = player.y + size / 2;
            makeGraphic(1, 3, lassoColor);
        }
        super.update(elapsed);
        //indicator.x = this.x;
        /*
        if (indicator.y <= this.y || indicator.y >= (this.y + 4 * size)) {
            //indicator.velocity.y = -indicator.velocity.y;
            speed = -speed;
        }
        
        diff += speed;
        if (diff < 0) {
            diff = 1;
            speed = -speed;
        } else if (diff > 4 * size) {
            diff = 4 * size - 1;
            speed = -speed;
        }
        indicator.y = this.y + diff;
        */
    }
}
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
    public var end:FlxObject;
    public var backpack:Backpack;
    static var COLOR = FlxColor.YELLOW;
    override public function new(size:Int, charater:Character, powerBar:PowerBar, backpack:Backpack) {
        player = charater;
        this.size = size;
        this.powerBar = powerBar;
        this.length = 0;
        this.backpack = backpack;
        super(Std.int(player.x + 10), Std.int(player.y + size / 2));
        this.end = new FlxObject(this.x, this.y, 4, 4);
        //,HORIZONTAL, 0, 2, FlxColor.WHITE);
        //createFilledBar(FlxColor.TRANSPARENT, FlxColor.WHITE);
        //diff = 0;
    }

    override public function update(elapsed:Float):Void {
		if (FlxG.keys.justPressed.SPACE && !powerBar.alive && length == 0 && backpack.hasLasso) {
			powerBar.revive();
		} else if (FlxG.keys.justPressed.SPACE && powerBar.alive && backpack.hasLasso) {
            Main.LOGGER.logLevelAction(LoggingInfo.USE_LASSO, {coor: player.x + ", " +player.y});
			lifeSpan = powerBar.generateResult();
		}
        if (lifeSpan > 0) {
            length += 20;
            player.moves = false;
            player.controllable = false;
            if (player.facing == FlxObject.LEFT) {
                this.x -= 20;
                end.x = this.x;
                end.y = this.y;
                makeGraphic(length, 3, COLOR);
            } else if (player.facing == FlxObject.UP) {
                this.y -= 20;
                end.y = this.y;
                end.x = this.x;
                makeGraphic(3, length, COLOR);
            } else if (player.facing == FlxObject.DOWN) {
                end.y = this.y + length;
                end.x = this.x;
                makeGraphic(3, length, COLOR);
            } else {
                end.x = this.x + length;
                end.y = this.y;
                makeGraphic(length, 3, COLOR);
            }
            lifeSpan -= 4*elapsed;
        } else {
            length = 0;
            player.moves = true;
            player.controllable = true;
            this.x = player.x + size / 2;
            this.y = player.y + size / 2;
            makeGraphic(1, 3, COLOR);
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
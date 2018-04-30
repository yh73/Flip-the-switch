import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.ui.FlxUILine;

class Lasso extends FlxSprite{
    var player:Character;
    var size:Int;
    var lifeSpan:Float;
	var powerBar:PowerBar;
    var length:Int;
    static var COLOR = FlxColor.YELLOW;
    override public function new(size:Int, charater:Character, powerBar:PowerBar) {
        player = charater;
        this.size = size;
        this.powerBar = powerBar;
        this.length = 0;
        super(Std.int(player.x + 10), Std.int(player.y + size / 2));
        //,HORIZONTAL, 0, 2, FlxColor.WHITE);
        //createFilledBar(FlxColor.TRANSPARENT, FlxColor.WHITE);
        //diff = 0;
    }

    override public function update(elapsed:Float):Void {
		if (FlxG.keys.justPressed.SPACE && !powerBar.alive && length == 0) {
			powerBar.revive();
		} else if (FlxG.keys.justPressed.SPACE && powerBar.alive) {
			lifeSpan = powerBar.generateResult();
		}
        if (lifeSpan > 0) {
            length += 5;
            if (player.facing == FlxObject.LEFT) {
                this.x -= 5;
                makeGraphic(length, 3, COLOR);
            } else if (player.facing == FlxObject.UP) {
                this.y -= 5;
                makeGraphic(3, length, COLOR);
            } else if (player.facing == FlxObject.DOWN) {
                makeGraphic(3, length, COLOR);
            } else {
                makeGraphic(length, 3, COLOR);
            }
            lifeSpan -= elapsed;
        } else {
            length = 0;
            this.x = player.x + size / 2;
            this.y = player.y + size / 2;
            makeGraphic(length, 3, COLOR);
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

import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.addons.ui.FlxUILine;

class PowerBar extends FlxSprite{
    public var name:String;
    var player:Character;
    var size:Int;
    public var indicator:FlxUILine;
    var diff:Int;
    var speed = 5;
    override public function new(size:Int, charater:Character) {
        super(0,0);
        player = charater;
        diff = 0;
        this.size = size;
        var random = new FlxRandom();
        indicator = new FlxUILine(cast((player.x + size), Int), 
            random.int(cast((player.y - 2 * size + 1), Int), cast(player.y - 2 * size + 4 * size - 1, Int)),
            HORIZONTAL, 32, 3, FlxColor.BLACK);
        indicator.velocity.y = 200;
        loadGraphicFromSprite(FlxGradient.createGradientFlxSprite(size, size * 4, [FlxColor.RED, FlxColor.YELLOW, FlxColor.GREEN]));
    }

    override public function update(elapsed:Float):Void {
        this.x = player.x + size;
        this.y = player.y - 2 * size;
        indicator.x = this.x;
        /*
        if (indicator.y <= this.y || indicator.y >= (this.y + 4 * size)) {
            //indicator.velocity.y = -indicator.velocity.y;
            speed = -speed;
        }
        */
        diff += speed;
        if (diff < 0) {
            diff = 1;
            speed = -speed;
        } else if (diff > 4 * size) {
            diff = 4 * size - 1;
            speed = -speed;
        }
        indicator.y = this.y + diff;
    }

    public function generateResult():Float {
        this.kill();
        return (1 - (indicator.y - this.y) / (4 * size));
    }

    override public function kill() {
        super.kill();
        indicator.kill();
        //indicator.velocity.y = 0;
    }

    override public function revive() {
        super.revive();
        indicator.revive();
        //indicator.velocity.y = 200;
        var random = new FlxRandom();
        diff = 4 * size - 1;
    }
}
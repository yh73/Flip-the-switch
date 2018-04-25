
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTile;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.tile.FlxTileSpecial;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxRect;
import flixel.util.FlxSort;
import flixel.group.FlxGroup;
import java.util.*;

/**
 * ...
 * @author MrCdK
 */
class Level extends TiledMap
{
	private inline static var PATH_TILESETS = "assets/maps/tiles.png";
	
	public var backgroundGroup:FlxTypedGroup<FlxTilemapExt>;
	public var foregroundGroup:FlxTypedGroup<FlxTilemapExt>;

	public var switchonGroup:FlxTypedGroup<FlxTilemapExt>;
	public var switchoffGroup:FlxTypedGroup<FlxTilemapExt>;
	public var coverSwitchGroup:FlxTypedGroup<FlxTilemapExt>;
	
	public var collisionGroup:FlxTypedGroup<FlxObject>;
	public var characterGroup:FlxTypedGroup<Character>;
	public var doorGroup:FlxTypedGroup<FlxObject>;

	public var openMap:Map<FlxObject, FlxObject>;
	
	public var bounds:FlxRect;

	public function new(level:Dynamic, state:PlayState) 
	{
		super(level);
		
		// background and foreground groups
		backgroundGroup = new FlxTypedGroup<FlxTilemapExt>();
		foregroundGroup = new FlxTypedGroup<FlxTilemapExt>();

		// switch on/off groups
		switchonGroup = new FlxTypedGroup<FlxTilemapExt>();
		switchoffGroup = new FlxTypedGroup<FlxTilemapExt>();

		// cover-switch groups
		coverSwitchGroup = new FlxTypedGroup<FlxTilemapExt>();
		
		// events and collision groups
		characterGroup = new FlxTypedGroup<Character>();
		collisionGroup = new FlxTypedGroup<FlxObject>();
		doorGroup = new FlxTypedGroup<FlxObject>();

		openMap = new Map<FlxObject, FlxObject>();

		// The bound of the map for the camera
		bounds = FlxRect.get(0, 0, fullWidth, fullHeight);
		
		var tileset:TiledTileSet;
		var tilemap:FlxTilemapExt;
		
		// Prepare the tile animations
		//var animations = TileAnims.getAnimations(animFile);
		
		for (tiledLayer in layers)
		{
			if (tiledLayer.type != TiledLayerType.TILE)
				continue;
			var layer:TiledTileLayer = cast tiledLayer;
			
			if (layer.properties.contains("tileset"))
				tileset = this.getTileSet(layer.properties.get("tileset"));
			else
				throw "Each layer needs a tileset property with the tileset name";
			
			if (tileset == null)
				throw "The tileset is null";
			
			tilemap = new FlxTilemapExt();
			tilemap.loadMapFromArray(
				layer.tileArray,
				layer.width,
				layer.height,
				PATH_TILESETS,
				tileset.tileWidth,                      // each tileset can have a different tile width or height
				tileset.tileHeight,
				OFF,                                    // disable auto map
				tileset.firstGID                        // IMPORTANT! set the starting tile id to the first tile id of the tileset
			);
			
            /*
			var specialTiles:Array<FlxTileSpecial> = new Array<FlxTileSpecial>();
			var tile:TiledTile;
			var animData;
			var specialTile:FlxTileSpecial;
			// set the special tiles (flipped, rotated and/or animated tiles)
			tilemap.setSpecialTiles(specialTiles);
			// set the alpha of the layer
			tilemap.alpha = layer.opacity;
			*/
			
			if (layer.properties.contains("fg"))
				foregroundGroup.add(tilemap);
			else if (layer.properties.contains("switchoff"))
				switchoffGroup.add(tilemap);
			else if (layer.properties.contains("switchon"))
				switchonGroup.add(tilemap);
			else if (layer.properties.contains("cover"))
				coverSwitchGroup.add(tilemap);
			else
				backgroundGroup.add(tilemap);
		}
		
		loadObjects(state);
	}
	
	public function loadObjects(state:PlayState)
	{
		var stringOpen:Map<String, FlxObject> = new Map<String, FlxObject>();
		var stringDoor:Map<String, FlxObject> = new Map<String, FlxObject>();
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT)
				continue;
			var group:TiledObjectLayer = cast layer;

			if (group.properties.contains("open")) {
				for (o in group.objects) {
					var x:Int = o.x;
					var y:Int = o.y;
					var open:FlxObject = new FlxObject(x, y, o.width, o.height);
					open.immovable = true;
					stringOpen.set(o.name, open);
				}
			} else if (group.properties.contains("door")) {
				for (o in group.objects) {
					var x:Int = o.x;
					var y:Int = o.y;
					var door:FlxObject = new FlxObject(x, y, o.width, o.height);
					#if FLX_DEBUG
					door.debugBoundingBoxColor = 0xFFFF00FF;
					#end
					door.immovable = true;
					doorGroup.add(door);
					stringDoor.set(o.name, door);
				}
			} else {
				for (obj in group.objects)
				{
					loadObject(state, obj, group);
				}
			}
		}
		for (key in stringOpen.keys()) {
			openMap.set(stringOpen[key], stringDoor[key]);
		}
	}
	
	private function loadObject(state:PlayState, o:TiledObject, g:TiledObjectLayer)
	{
		var x:Int = o.x;
		var y:Int = o.y;
		
		switch (o.type.toLowerCase())
		{   
            
			case "player":
				var player = new Character(o.name, x, y, "assets/"+o.name+".json");
				player.setBoundsMap(bounds);
				player.controllable = true;
				FlxG.camera.follow(player);
				characterGroup.add(player);
				state.player = player;
				
			case "collision":
				var coll:FlxObject = new FlxObject(x, y, o.width, o.height);
				#if FLX_DEBUG
				coll.debugBoundingBoxColor = 0xFFFF00FF;
				#end
				coll.immovable = true;
				collisionGroup.add(coll);

			case "opensw":
				var sw = new FlxObject(x, y, o.width, o.height);
				state.sw = sw;

		}
	}
	
	public function update(elapsed:Float):Void
	{
		updateCollisions();
		updateEventsOrder();
	}

	public function updateEventsOrder():Void
	{
		characterGroup.sort(FlxSort.byY);
	}
	
	public function updateCollisions():Void
	{
		FlxG.collide(characterGroup, collisionGroup);
		FlxG.collide(characterGroup, characterGroup);
		for (open in openMap.keys()) {
			if (FlxG.overlap(characterGroup, open)) {
				if (FlxG.keys.anyJustPressed([E])) {
					openMap[open].kill();
				}
			}
		}
		FlxG.collide(characterGroup, doorGroup);
	}
	
	// private inline function isSpecialTile(tile:TiledTile, animations:Dynamic):Bool
	// {
	// return tile.isFlipHorizontally || tile.isFlipVertically || tile.rotate != FlxTileSpecial.ROTATE_0 || animations.exists(tile.tilesetID);
	// }
}
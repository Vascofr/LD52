package;

import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public var tweens:FlxTweenManager = new FlxTweenManager();
	public var timers:FlxTimerManager = new FlxTimerManager();

	var tiles = new FlxTypedGroup<Tile>();
	var gameAreaWidth:Int = 9;
	var gameAreaHeight:Int = 7;

	public static inline var TILE_WIDTH:Int = 78;
	public static inline var TILE_HEIGHT:Int = 60;

	var cursors = new FlxTypedGroup<FlxObject>();
	var cursorType:Int = 1;
	public static inline var NUM_CURSOR_TYPES:Int = 13;

	var cursorObject = new FlxObject(FlxG.mouse.x, FlxG.mouse.y, 0.1, 0.1);

	var TILL:Int = 1;
	var WATER:Int = 2;
	var SEED:Int = 3;
	public var seedType:Int = 1;

	var action:Int = 1;

	static private var justHarvested:Bool = false;
	public var harvested = [0, 0, 0, 0];

	var bg:FlxSprite;

	var day:Int = 1;
	var dayTime:Float = 0.0;
	var dayTimeTotal:Float = 25.0;
	var totalDays:Int = 12;

	var dayTimeBar:FlxSprite;

	var dayText:FlxText;

	var numMoves:Int = 15;
	var numMovesText:FlxText;

	static public var level:Int = 1;

	static public var cash:Int = 0;//++++ cash text, max cash, max day?, harvest
	public var cashText:FlxText;
	public var cashObjective:Int = 2000;

	static public var cameraHUD:FlxCamera;

	public var particles = new FlxTypedGroup<FlxSprite>();
	static public inline var MAX_PARTICLES:Int = 200;
	public var particleIndex:Int = 0;

	override public function create():Void
	{
		super.create();

		flixelInit();

		add(tweens);
		add(timers);

		justHarvested = false;




		switch (level) {
			case 1:
				numMoves = 15;
		}



		bg = new FlxSprite(0, 0, "assets/images/bg.png");
		add(bg);

		var tileX:Float = (FlxG.width - gameAreaWidth * TILE_WIDTH) * 0.5;
		var tileY:Float = ((FlxG.height + 45) - gameAreaHeight * TILE_HEIGHT) * 0.5;
		for (w in 0...gameAreaWidth) {
			for (h in 0...gameAreaHeight) {
				tiles.add(new Tile(tileX + TILE_WIDTH * w, tileY + TILE_HEIGHT * h));
			}
		}

		add(tiles);

		for (i in 0...MAX_PARTICLES) {
			particles.add(new FlxSprite(0, 0));
			particles.members[i].loadGraphic("assets/images/tiles/empty_1px.png");
			particles.members[i].exists = false;
		}
		particleIndex = 0;
		add(particles);

		if (cameraHUD == null) {
			cameraHUD = new FlxCamera();
			FlxG.cameras.add(cameraHUD);
		}

		dayTimeBar = new FlxSprite(0, FlxG.height - 18);
		dayTimeBar.makeGraphic(FlxG.width, 18, 0xffffffff);
		dayTimeBar.camera = cameraHUD;
		add(dayTimeBar);

		dayText = new FlxText(12, 5, 400, "", 24);
		dayText.font = "assets/data/PressStart2P.ttf";
		dayText.camera = cameraHUD;
		dayText.text = "Day " + day + " / " + totalDays;
		add(dayText);

		cashText = new FlxText(0, 5, FlxG.width - 12, "$0 / $" + cashObjective, 24);
		cashText.font = "assets/data/PressStart2P.ttf";
		cashText.alignment = FlxTextAlign.RIGHT;
		cashText.camera = cameraHUD;
		add(cashText);

		numMovesText = new FlxText(FlxG.width - 153, 99, 170, "Moves\n" + numMoves, 24);
		numMovesText.font = "assets/data/PressStart2P.ttf";
		numMovesText.alignment = FlxTextAlign.CENTER;
		numMovesText.camera = cameraHUD;
		add(numMovesText);

		var cursorX:Float = FlxG.mouse.x - TILE_WIDTH * 2.0;
		var cursorY:Float = FlxG.mouse.y - TILE_HEIGHT * 2.0;
		for (w in 0...5) {
			for (h in 0...5) {
				cursors.add(new FlxObject(cursorX + w * TILE_WIDTH, cursorY + h * TILE_HEIGHT, 0.1, 0.1));
				cursors.members[cursors.members.length - 1].exists = false;
			}
		}

		//  0,  1,  2,  3,  4, 
		//  5,  6,  7,  8,  9,
		// 10, 11, 12, 13, 14,
		// 15, 16, 17, 18, 19,
		// 20, 21, 22, 23, 24

		CursorType.setType(cursors, FlxG.random.int(1, NUM_CURSOR_TYPES));

		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);


		cursorObject.setPosition(FlxG.mouse.x, FlxG.mouse.y);
		cursorObject.last.set(cursorObject.x, cursorObject.y);
		justHarvested = false;
		// harvest //
		if (FlxG.mouse.pressed)
			FlxG.overlap(cursorObject, tiles, onTilePointerClick);
		// action //
		if (!justHarvested && numMoves > 0) {
			var cursorX:Float = FlxG.mouse.x - TILE_WIDTH * 2.0;
			var cursorY:Float = FlxG.mouse.y - TILE_HEIGHT * 2.0;
			var i = 0;
			for (w in 0...5) {
				for (h in 0...5) {
					cursors.members[i].setPosition(cursorX + w * TILE_WIDTH, cursorY + h * TILE_HEIGHT);
					cursors.members[i].last.set(cursors.members[i].x, cursors.members[i].y);
					i++;
				}
			}

			if (!FlxG.mouse.justPressed && !FlxG.mouse.pressed)
				FlxG.overlap(cursors, tiles, onTileHover);
			else if (FlxG.mouse.justPressed)
				FlxG.overlap(cursors, tiles, onTileClick);

			if (FlxG.mouse.justPressed) {
				cursorType++;
				CursorType.setType(cursors, FlxG.random.int(1, NUM_CURSOR_TYPES));

				numMoves--;
				numMovesText.text = "Moves\n" + numMoves;

				if (numMoves == 0) {
					FlxG.timeScale = 3.0;
				}
			}

			if (FlxG.keys.justPressed.SPACE) {
				CursorType.setType(cursors, FlxG.random.int(1, NUM_CURSOR_TYPES));
			}
		
		}

		if (FlxG.keys.justPressed.W) {
			action = WATER;
		}
		else if (FlxG.keys.justPressed.T) {
			action = TILL;
		}
		else if (FlxG.keys.justPressed.S) {
			action = SEED;
		}

		if (FlxG.keys.justPressed.ONE || FlxG.keys.justPressed.NUMPADONE)
			seedType = 1;
		if (FlxG.keys.justPressed.TWO || FlxG.keys.justPressed.NUMPADTWO)
			seedType = 2;
		if (FlxG.keys.justPressed.THREE || FlxG.keys.justPressed.NUMPADTHREE)
			seedType = 3;
		if (FlxG.keys.justPressed.FOUR || FlxG.keys.justPressed.NUMPADFOUR)
			seedType = 4;

		if (FlxG.keys.justPressed.L || FlxG.mouse.justPressedMiddle) {
			CursorType.rotateLeft(cursors);
		}
		if (FlxG.keys.justPressed.R || FlxG.mouse.justPressedRight) {
			CursorType.rotateRight(cursors);
		}

		if (FlxG.keys.pressed.RIGHT) {
			FlxG.timeScale = 5.0;
			if (FlxG.keys.pressed.DOWN) {
				FlxG.timeScale = 20.0;
			}
		}
		else {
			if (numMoves > 0)
				FlxG.timeScale = 1.0;
			else
				FlxG.timeScale = 3.0;
		}



		dayTime += elapsed;
		if (dayTime >= dayTimeTotal) {
			dayTime -= dayTimeTotal;
			FlxG.timeScale = 1.0;
			openSubState(new EndWindow("DAY " + day + " END"));
			new FlxTimer(timers).start(0.01, function(timer) { updateDay(); } );
		}
		dayTimeBar.clipRect = new FlxRect(0, 0, FlxG.width * (dayTime / dayTimeTotal), 18);
	}

	function onTilePointerClick(cursor:FlxObject, tile:Tile) {
		if (tile.growth == tile.maxGrowth) {
			tile.harvest();
			justHarvested = true;
		}
	}

	function onTileClick(cursorPos:FlxObject, tile:Tile) {
		/*if (tile.growth == tile.maxGrowth) {
			tile.harvest();
			return;
		}*/

		if (action == WATER) {
			tile.water();
		}
		else if (action == TILL) {
			tile.till();
		}
		else if (action == SEED) {
			tile.seed();
		}
	}

	function onTileHover(cursorPos:FlxObject, tile:Tile) {
		tile.select();
	}

	function updateDay() {
		day++;

		for (i in 0...tiles.members.length) {
			tiles.members[i].updateDay();
		}

		dayText.text = "Day " + day + " / " + totalDays;

		for (i in 0...harvested.length) {
			harvested[i] = 0;
		}

		switch (level) {
			case 1:
				numMoves += 15;
				numMovesText.text = "Moves\n" + numMoves;
		}
	}

	function flixelInit() {
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.unload();

		FlxG.maxElapsed = 0.05;
		FlxG.fixedTimestep = false;

		FlxG.stage.showDefaultContextMenu = false;

		#if html5
		FlxG.log.redirectTraces = true;
		#end

		FlxG.sound.cacheAll();

		FlxG.camera.bgColor = 0xff1b1c23;
	}
}

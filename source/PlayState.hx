package;

import flixel.ui.FlxButton;
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
	var gameAreaWidth:Int = 5;  // max 9
	var gameAreaHeight:Int = 4;  // max 7
 
	public static inline var TILE_WIDTH:Int = 78;
	public static inline var TILE_HEIGHT:Int = 60;

	var cursors = new FlxTypedGroup<FlxObject>();
	var cursorType:Int = 1;
	public static var NUM_CURSOR_TYPES:Int = 3;  // 3, 14, 30, 32

	var cursorObject = new FlxObject(FlxG.mouse.x, FlxG.mouse.y, 0.1, 0.1);

	static public var restartLevel:Bool = false;

	var TILL:Int = 1;
	var WATER:Int = 2;
	var SEED:Int = 3;
	public var seedType:Int = 1;

	var seedButtons = new FlxTypedGroup<FlxButton>();
	public var seedQuantities = new FlxTypedGroup<FlxText>();
	
	var hoeButton:FlxButton;
	var waterButton:FlxButton;

	var action:Int = 1;

	static private var justHarvested:Bool = false;
	public var harvested = [0, 0, 0, 0];
	public var seeds = [6, 0, 0, 0];

	var bg:FlxSprite;

	public var day:Int = 1;
	var dayTime:Float = 0.0;
	var dayTimeTotal:Float = 25.0;
	public var totalDays:Int = 12;

	var dayTimeBar:FlxSprite;

	var dayText:FlxText;

	var levelText:FlxText;

	var numMoves:Int = 15;
	var numMovesMax:Int = 15;
	var numMovesText:FlxText;

	static public var level:Int = 1;
	static public var levelColor:Int = 0xffffffff;
	//static public var levelColor:Int = 0xffcc6688;
	
	static public var cash:Int = 0;//++++ cash text, max cash, max day?, harvest
	public var cashText:FlxText;
	public var cashObjective:Int = 2000;

	public var cameraHUD:FlxCamera;

	public var particles = new FlxTypedGroup<FlxSprite>();
	static public inline var MAX_PARTICLES:Int = 200;
	public var particleIndex:Int = 0;

	override public function create():Void
	{
		super.create();

		flixelInit();

		add(tweens);
		add(timers);

		FlxG.camera.fade(0xff1b1c23, 0.8, true);

		justHarvested = false;

		cash = 0;

		//if (level <= 2) level = 4;

		switch (level) {
			case 1:
				numMoves = numMovesMax = 3;
				seeds = [3, 0, 0, 0];
				levelColor = 0xff98a2ac;
				NUM_CURSOR_TYPES = 3;
				gameAreaWidth = 5;  // max 9
				gameAreaHeight = 4;  // max 7
				cashObjective = 150;
				totalDays = 12;
				dayTimeTotal = 21;
			case 2:
				numMoves = numMovesMax = 4;
				seeds = [2, 3, 0, 0];
				levelColor = 0xff87a3bd;
				NUM_CURSOR_TYPES = 14;
				gameAreaWidth = 6;  // max 9
				gameAreaHeight = 4;  // max 7
				cashObjective = 600;
				totalDays = 15;
				dayTimeTotal = 23;
			case 3:
				numMoves = numMovesMax = 6;
				seeds = [2, 4, 0, 0];
				levelColor = 0xffbd9389;
				NUM_CURSOR_TYPES = 14;
				gameAreaWidth = 7;  // max 9
				gameAreaHeight = 5;  // max 7
				cashObjective = 1400;
				totalDays = 16;
				dayTimeTotal = 25;
			case 4:
				numMoves = numMovesMax = 8;
				seeds = [2, 4, 0, 0];
				levelColor = 0xff88be93;
				NUM_CURSOR_TYPES = 30;
				gameAreaWidth = 8;  // max 9
				gameAreaHeight = 6;  // max 7
				cashObjective = 5000;
				totalDays = 18;
				dayTimeTotal = 27;
			case 5:
				numMoves = numMovesMax = 8;
				seeds = [2, 5, 0, 0];
				levelColor = 0xffb188be;
				NUM_CURSOR_TYPES = 32;
				gameAreaWidth = 9;  // max 9
				gameAreaHeight = 7;  // max 7
				cashObjective = 15000;
				totalDays = 20;
				dayTimeTotal = 30;
		}

		//FlxG.camera.bgColor = 0xff1b1c23;
		//FlxG.camera.bgColor = 0xff98a2ac;
		FlxG.camera.bgColor = levelColor;

		bg = new FlxSprite(0, 0, "assets/images/bg_" + level + ".png");
		//bg.color = levelColor;
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

		dayText = new FlxText(12, 6, 400, "", 24);
		dayText.font = "assets/data/PressStart2P.ttf";
		dayText.camera = cameraHUD;
		dayText.text = "Day " + day + " / " + totalDays;
		add(dayText);

		levelText = new FlxText(12, 6, FlxG.width, "", 24);
		levelText.font = "assets/data/PressStart2P.ttf";
		levelText.alignment = FlxTextAlign.CENTER;
		levelText.camera = cameraHUD;
		levelText.text = "Level " + level;
		add(levelText);

		cashText = new FlxText(0, 3, FlxG.width - 12, "$0 / $" + cashObjective, 24);
		cashText.font = "assets/data/PressStart2P.ttf";
		cashText.alignment = FlxTextAlign.RIGHT;
		cashText.camera = cameraHUD;
		add(cashText);

		numMovesText = new FlxText(FlxG.width - 159, 165, 170, "Moves\n" + numMoves, 24);
		numMovesText.font = "assets/data/PressStart2P.ttf";
		numMovesText.alignment = FlxTextAlign.CENTER;
		numMovesText.camera = cameraHUD;
		add(numMovesText);

		hoeButton = new FlxButton(891, 237, null, onHoe);
		hoeButton.loadGraphic("assets/images/hoe_button.png", true, 87, 72);
		add(hoeButton);

		waterButton = new FlxButton(891, 324, null, onWater);
		waterButton.loadGraphic("assets/images/water_button.png", true, 87, 72);
		add(waterButton);


		seedButtons.add(new FlxButton(42, 75, null, onSeed1));
        seedButtons.members[0].loadGraphic("assets/images/seed1_button.png", true, 69, 78);
        seedButtons.add(new FlxButton(42, 195, null, onSeed2));
        seedButtons.members[1].loadGraphic("assets/images/seed2_button.png", true, 69, 78);
        seedButtons.add(new FlxButton(42, 315, null, onSeed3));
        seedButtons.members[2].loadGraphic("assets/images/seed3_button.png", true, 69, 78);
        seedButtons.add(new FlxButton(42, 435, null, onSeed4));
        seedButtons.members[3].loadGraphic("assets/images/seed4_button.png", true, 69, 78);
        seedButtons.forEach(function(button) { button.camera = cameraHUD; });
        add(seedButtons);

		seedQuantities.add(new FlxText(0, seedButtons.members[0].y + 78, 160, "" + seeds[0], 24));
        seedQuantities.add(new FlxText(0, seedButtons.members[1].y + 78, 160, "" + seeds[1], 24));
        seedQuantities.add(new FlxText(0, seedButtons.members[2].y + 78, 160, "" + seeds[2], 24));
        seedQuantities.add(new FlxText(0, seedButtons.members[3].y + 78, 160, "" + seeds[3], 24));
        seedQuantities.forEach(function(qText) { qText.camera = cameraHUD; qText.alignment = FlxTextAlign.CENTER; });
        add(seedQuantities);



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
		var numberOfRotations:Int = FlxG.random.int(0, 3);
		for (i in 0...numberOfRotations)
			CursorType.rotateRight(cursors);

		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.R)
			restart();

		cursorObject.setPosition(FlxG.mouse.x, FlxG.mouse.y);
		cursorObject.last.set(cursorObject.x, cursorObject.y);
		justHarvested = false;
		// harvest //
		if (FlxG.mouse.pressed)
			FlxG.overlap(cursorObject, tiles, onTilePointerClick);
		// action //
		if (!justHarvested && numMoves > 0 && FlxG.overlap(cursorObject, tiles) && !(action == SEED && seeds[seedType - 1] <= 0)) {
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
				var numberOfRotations:Int = FlxG.random.int(0, 3);
				for (i in 0...numberOfRotations)
					CursorType.rotateRight(cursors);

				numMoves--;
				numMovesText.text = "Moves\n" + numMoves;

				if (numMoves == 0) {
					FlxG.timeScale = 8.5;
				}
			}

			else if (FlxG.keys.justPressed.SPACE && numMoves > 0) {
				CursorType.setType(cursors, FlxG.random.int(1, NUM_CURSOR_TYPES));
				numMoves--;
				numMovesText.text = "Moves\n" + numMoves;
			}
		
		}

		if (FlxG.keys.justPressed.W) {
			action = WATER;
		}
		else if (FlxG.keys.justPressed.T) {
			action = TILL;
		}

		if (FlxG.keys.justPressed.ONE || FlxG.keys.justPressed.NUMPADONE)
			onSeed1();
		if (FlxG.keys.justPressed.TWO || FlxG.keys.justPressed.NUMPADTWO)
			onSeed2();
		if (FlxG.keys.justPressed.THREE || FlxG.keys.justPressed.NUMPADTHREE)
			onSeed3();
		if (FlxG.keys.justPressed.FOUR || FlxG.keys.justPressed.NUMPADFOUR)
			onSeed4();

		if (FlxG.mouse.justPressedMiddle) {
			CursorType.rotateLeft(cursors);
		}
		if (FlxG.mouse.justPressedRight) {
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
				FlxG.timeScale = 8.5;
		}

		for (i in 0...seedButtons.members.length) {
			if (seeds[i] <= 0) {
				seedButtons.members[i].alpha = 0.8;
			}
			else {
				seedButtons.members[i].alpha = 1.0;
			}
		}


		if (numMoves <= 0) {
			numMovesText.color = 0xffcc222b;
		}
		else if (numMovesText.color != 0xffffffff)
			numMovesText.color = 0xffffffff;


		dayTime += elapsed;
		if (dayTime >= dayTimeTotal) {
			dayTime -= dayTimeTotal;
			FlxG.timeScale = 1.0;
			openSubState(new EndWindow("DAY " + day + " END"));
			new FlxTimer(timers).start(0.01, function(timer) { updateDay(); } );
		}
		dayTimeBar.clipRect = new FlxRect(0, 0, FlxG.width * (dayTime / dayTimeTotal), 18);

		if (restartLevel) {
			restartLevel = false;
			FlxG.switchState(new PlayState());
		}
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
			if (seeds[seedType - 1] > 0)
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

		numMoves = numMovesMax;
		numMovesText.text = "Moves\n" + numMoves;
	}

	function onSeed1() {
        if (seeds[0] <= 0) return;

        seedType = 1;
		action = SEED;
    }

    function onSeed2() {
        if (seeds[1] <= 0) return;

        seedType = 2;
		action = SEED;
    }

    function onSeed3() {
        if (seeds[2] <= 0) return;

        seedType = 3;
		action = SEED;
    }

    function onSeed4() {
        if (seeds[3] <= 0) return;

        seedType = 4;
		action = SEED;
    }

	function onHoe() {
		action = TILL;
	}

	function onWater() {
		action = WATER;
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
	}

	function restart() {
		FlxG.switchState(new PlayState());
	}

}

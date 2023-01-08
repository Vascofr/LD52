package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxSubState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class EndWindow extends FlxSubState {

    var bg:FlxSprite;
    var fadedBg:FlxSprite;
    var titleText:FlxText;

    var tipText:FlxText;

    var listLeftText:FlxText;
    var listRightText:FlxText;

    var totalLeftText:FlxText;
    var totalRightText:FlxText;

    var continueButton:FlxButton;
    var nextButton:FlxButton;
    var restartButton:FlxButton;

    var slideInAmount:Int = 16;

    var tweens:FlxTweenManager = new FlxTweenManager();

    var waitToClose:Float = 0.0;

    static public var won:Bool = false;

    public function new(Title:String = null) {
        super();

        add(tweens);

        fadedBg = new FlxSprite(0, 0);
        fadedBg.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
        fadedBg.camera = cast(FlxG.state, PlayState).cameraHUD;
        fadedBg.alpha = 0.0;
        add(fadedBg);

        bg = new FlxSprite((FlxG.width - 741) * 0.5, 27, "assets/images/window.png");
        bg.camera = cast(FlxG.state, PlayState).cameraHUD;
        bg.alpha = 0.0;
        add(bg);


        titleText = new FlxText(bg.x, bg.y + 39, bg.width, Title, 24);
        titleText.font = "assets/data/PressStart2P.ttf";
		titleText.camera = cast(FlxG.state, PlayState).cameraHUD;
        titleText.alignment = FlxTextAlign.CENTER;
        titleText.alpha = 0.0;
        
        add(titleText);

        var randomTip:String = "";
        var maxTip:Int = 3;
        if (PlayState.level > 1)
            maxTip = 4;
        if (PlayState.level > 2)
            maxTip = 8;
        switch (FlxG.random.int(0, maxTip)) {
            case 0:
                randomTip = "Tip: Press SPACE to skip a move";
            case 1:
                randomTip = "Tip: Press SPACE to skip these windows";
            case 2:
                randomTip = "Tip: Select (W)ater, (T)ill with hotkeys";
            case 3:
                randomTip = "Tip: Rotate w/ right/middle mouse buttons";
            case 4:
                randomTip = "Tip: Hold & drag click to quick-harvest";
            case 5:
                randomTip = "Tip: Number keys 1-4 are seed hotkeys";
            case 6:
                randomTip = "\"Yellow Oranges? Oh...\""; 
            case 7:
                randomTip = "Tip: Double doses of water last longer"; 
            case 8:
                randomTip = "Tip: Seeds don't grow on smooth land"; 
        }

        tipText = new FlxText(0, FlxG.height - 33, FlxG.width, randomTip, 24);
        tipText.font = "assets/data/PressStart2P.ttf";
        //tipText.color = 0xffcccccc;
		tipText.camera = cast(FlxG.state, PlayState).cameraHUD;
        tipText.alignment = FlxTextAlign.CENTER;
        tipText.alpha = 0.0;
        add(tipText);

        //listLeftText = new FlxText(bg.x + 45, bg.y + 124, bg.width, "Methanemelon x328\n\nYellow x23\n\nSpike delight x34\n\nTaxiage x26\n\nSubtotal", 24);
        listLeftText = new FlxText(bg.x + 45, bg.y + 124, bg.width, "", 24);
        listLeftText.font = "assets/data/PressStart2P.ttf";
		listLeftText.camera = cast(FlxG.state, PlayState).cameraHUD;
        listLeftText.alpha = 0.0;
        add(listLeftText);

        //listRightText = new FlxText(bg.x + 36, bg.y + 124, bg.width - 87, "$2349\n\n$3942\n\n$1\n\n$324\n\n$92930", 24);
        listRightText = new FlxText(bg.x + 36, bg.y + 124, bg.width - 87, "", 24);
        listRightText.font = "assets/data/PressStart2P.ttf";
		listRightText.camera = cast(FlxG.state, PlayState).cameraHUD;
        listRightText.alignment = FlxTextAlign.RIGHT;
        listRightText.alpha = 0.0;
        add(listRightText);

        totalLeftText = new FlxText(bg.x + 45, bg.y + 364, bg.width, "TOTAL", 24);
        totalLeftText.font = "assets/data/PressStart2P.ttf";
        totalLeftText.color = 0xff4bf0f7;
		totalLeftText.camera = cast(FlxG.state, PlayState).cameraHUD;
        totalLeftText.alpha = 0.0;
        add(totalLeftText);

        totalRightText = new FlxText(bg.x + 36, bg.y + 364, bg.width - 87, "", 24);
        totalRightText.font = "assets/data/PressStart2P.ttf";
        totalRightText.color = 0xff4bf0f7;
		totalRightText.camera = cast(FlxG.state, PlayState).cameraHUD;
        totalRightText.alignment = FlxTextAlign.RIGHT;
        totalRightText.alpha = 0.0;
        add(totalRightText);


        var playState = cast(FlxG.state, PlayState);
        if (playState.harvested[0] >= 0) {
            listLeftText.text += "Methanemelon x" + playState.harvested[0] + "\n\n";
        }
        if (playState.harvested[1] >= 0) {
            listLeftText.text += "Sweetroot x" + playState.harvested[1] + "\n\n";
        } 
        if (playState.harvested[2] >= 0) {
            listLeftText.text += "Yellow x" + playState.harvested[2] + "\n\n";
        }
        if (playState.harvested[3] >= 0) {
            listLeftText.text += "Spike delight x" + playState.harvested[3] + "\n\n";
        }
        listLeftText.text += "Subtotal";

        if (playState.harvested[0] >= 0) {
            listRightText.text += "$" + (playState.harvested[0] * Seed.harvestValue[1]) + "\n\n";
        }
        if (playState.harvested[1] >= 0) {
            listRightText.text += "$" + (playState.harvested[1] * Seed.harvestValue[2]) + "\n\n";
        } 
        if (playState.harvested[2] >= 0) {
            listRightText.text += "$" + (playState.harvested[2] * Seed.harvestValue[3]) + "\n\n";
        }
        if (playState.harvested[3] >= 0) {
            listRightText.text += "$" + (playState.harvested[3] * Seed.harvestValue[4]) + "\n\n";
        }
        var subtotal:Int = ((playState.harvested[0] * Seed.harvestValue[1]) + 
                            (playState.harvested[1] * Seed.harvestValue[2]) + 
                            (playState.harvested[2] * Seed.harvestValue[3]) + 
                            (playState.harvested[3] * Seed.harvestValue[4])); 
        PlayState.cash += subtotal;
        playState.cashText.text = "$" + PlayState.cash + " / $" + playState.cashObjective;
        listRightText.text += "$" + subtotal;
                            
        totalRightText.text = "$" + PlayState.cash + " / $" + playState.cashObjective;
                    //+ " / $" + playState.cashObjective;


        continueButton = new FlxButton(bg.x + 242 + 132, bg.y + 408, "Continue", function() { FlxG.sound.play("assets/sounds/select.mp3", 0.2); closeWindow(); });
        continueButton.loadGraphic("assets/images/button.png", true, 255, 69);
        continueButton.label.font = "assets/data/PressStart2P.ttf";
        continueButton.label.color = 0xffffff;
        continueButton.label.size = 24;
        continueButton.labelOffsets = [new FlxPoint(-3.0, 21.0), new FlxPoint(-3.0, 21.0), new FlxPoint(-3.0, 21.0)];
        continueButton.onOver.callback = function() { continueButton.label.color = 0xff4bf0f7; };
        continueButton.onOut.callback = function() { continueButton.label.color = 0xffffffff; };
        continueButton.camera = cast(FlxG.state, PlayState).cameraHUD;
        continueButton.alpha = 0.0;
        add(continueButton);

        if (playState.day >= playState.totalDays)
            continueButton.exists = false;

        if (PlayState.cash < playState.cashObjective)
            restartButton = new FlxButton(bg.x + 242 - 132, bg.y + 408, "Restart", function() { FlxG.sound.play("assets/sounds/select.mp3", 0.2); PlayState.restartLevel = true; closeWindow(); });
        else if (PlayState.level < 6) {
            if (PlayState.level < 5)
                restartButton = new FlxButton(bg.x + 242 - 132, bg.y + 408, "Next", function() { FlxG.sound.play("assets/sounds/select.mp3", 0.2); PlayState.level++; PlayState.restartLevel = true; closeWindow(); });
            else
                restartButton = new FlxButton(bg.x + 242 - 132, bg.y + 408, "Win", function() { FlxG.sound.play("assets/sounds/select.mp3", 0.2); won = true; closeWindow(); });
            restartButton.x += 132;
            continueButton.exists = false;
        }
        if (playState.day >= playState.totalDays) {
            restartButton.x += 132;
        }

        restartButton.loadGraphic("assets/images/button.png", true, 255, 69);
        restartButton.label.font = "assets/data/PressStart2P.ttf";
        restartButton.label.color = 0xffffff;
        restartButton.label.size = 24;
        restartButton.labelOffsets = [new FlxPoint(-3.0, 21.0), new FlxPoint(-3.0, 21.0), new FlxPoint(-3.0, 21.0)];
        restartButton.onOver.callback = function() { restartButton.label.color = 0xff4bf0f7; };
        restartButton.onOut.callback = function() { restartButton.label.color = 0xffffffff; };
        restartButton.camera = cast(FlxG.state, PlayState).cameraHUD;
        restartButton.alpha = 0.0;
        add(restartButton);


        bg.y -= slideInAmount;
        titleText.y -= slideInAmount;
        tipText.y -= slideInAmount;
        listLeftText.y -= slideInAmount;
        listRightText.y -= slideInAmount;
        totalLeftText.y -= slideInAmount;
        totalRightText.y -= slideInAmount;
        continueButton.y -= slideInAmount;
        restartButton.y -= slideInAmount;

        tweens.tween(fadedBg, { alpha: 0.5 }, 0.3, { ease: FlxEase.quadOut });

        tweens.tween(bg, { alpha: 1.0 }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(titleText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(tipText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(listLeftText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(listRightText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(totalLeftText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(totalRightText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(continueButton, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(restartButton, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });

        tweens.tween(bg, { y: bg.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(titleText, { y: titleText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(tipText, { y: tipText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(listLeftText, { y: listLeftText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(listRightText, { y: listRightText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(totalLeftText, { y: totalLeftText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(totalRightText, { y: totalRightText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(continueButton, { y: continueButton.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(restartButton, { y: restartButton.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });

        if (PlayState.cash >= cast(FlxG.state, PlayState).cashObjective) {
            titleText.text = "YOU MADE IT!";
            titleText.color = 0xff4bf0f7;
            tipText.exists = false;
        }
        else if (cast(FlxG.state, PlayState).day >= cast(FlxG.state, PlayState).totalDays) {
            titleText.text = "TIME'S UP!";
            titleText.color = 0xffcc222b;
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (waitToClose > 0.0) {
            waitToClose -= elapsed;
            if (waitToClose <= 0.0) {
                cast(FlxG.state, PlayState).cameraHUD.fade(0xff1b1c23, 1.2, true, null, true);
                close();
            }
        }
        else if (FlxG.keys.justPressed.SPACE) {
            closeWindow();            
        }
    }

    function closeWindow() {
        
        tweens.tween(titleText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(tipText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(listLeftText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(listRightText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(totalLeftText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(totalRightText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(continueButton, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(restartButton, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(bg, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut, startDelay: 0.3 });
        //if (PlayState.cash <= 0)
          //  tweens.tween(fadedBg, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut, startDelay: 0.3 });

        tweens.tween(bg, { y: bg.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(titleText, { y: titleText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(tipText, { y: tipText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(listLeftText, { y: listLeftText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(listRightText, { y: listRightText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(totalLeftText, { y: totalLeftText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(totalRightText, { y: totalRightText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });

        if (won) {
            tweens.tween(continueButton, { y: continueButton.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25, onComplete: function(tween) { cast(FlxG.state, PlayState).openSubState(new InfoWindow("CONGRATULATIONS", 
                "You made enough money to retire in a galaxy far away!\n\nIt's a good thing the old dollar is so valued nowadays.\n\n\nA game by Vasco Freitas for Ludum Dare 52.")); close(); } });
        }
        else if (PlayState.cash <= 0 || PlayState.cash >= cast(FlxG.state, PlayState).cashObjective || PlayState.restartLevel) {
            tweens.tween(continueButton, { y: continueButton.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25, onComplete: function(tween) { waitToClose = 0.4; cast(FlxG.state, PlayState).cameraHUD.fade(0xff1b1c23, 0.4); } });
        }
        else {
            tweens.tween(continueButton, { y: continueButton.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25, onComplete: function(tween) { cast(FlxG.state, PlayState).openSubState(new ShopWindow("SHOP")); close(); } });
        }
        tweens.tween(restartButton, { y: restartButton.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
    }
}
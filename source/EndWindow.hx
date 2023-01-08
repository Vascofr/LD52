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

    var listLeftText:FlxText;
    var listRightText:FlxText;

    var totalLeftText:FlxText;
    var totalRightText:FlxText;

    var continueButton:FlxButton;

    var slideInAmount:Int = 16;

    var tweens:FlxTweenManager = new FlxTweenManager();

    var waitToClose:Float = 0.0;

    public function new(Title:String = null) {
        super();

        add(tweens);

        fadedBg = new FlxSprite(0, 0);
        fadedBg.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
        fadedBg.camera = PlayState.cameraHUD;
        fadedBg.alpha = 0.0;
        add(fadedBg);

        bg = new FlxSprite((FlxG.width - 741) * 0.5, 27, "assets/images/window.png");
        bg.camera = PlayState.cameraHUD;
        bg.alpha = 0.0;
        add(bg);


        titleText = new FlxText(bg.x, bg.y + 39, bg.width, Title, 24);
        titleText.font = "assets/data/PressStart2P.ttf";
		titleText.camera = PlayState.cameraHUD;
        titleText.alignment = FlxTextAlign.CENTER;
        titleText.alpha = 0.0;
        add(titleText);

        //listLeftText = new FlxText(bg.x + 45, bg.y + 124, bg.width, "Methanemelon x328\n\nYellow x23\n\nSpike delight x34\n\nTaxiage x26\n\nSubtotal", 24);
        listLeftText = new FlxText(bg.x + 45, bg.y + 124, bg.width, "", 24);
        listLeftText.font = "assets/data/PressStart2P.ttf";
		listLeftText.camera = PlayState.cameraHUD;
        listLeftText.alpha = 0.0;
        add(listLeftText);

        //listRightText = new FlxText(bg.x + 36, bg.y + 124, bg.width - 87, "$2349\n\n$3942\n\n$1\n\n$324\n\n$92930", 24);
        listRightText = new FlxText(bg.x + 36, bg.y + 124, bg.width - 87, "", 24);
        listRightText.font = "assets/data/PressStart2P.ttf";
		listRightText.camera = PlayState.cameraHUD;
        listRightText.alignment = FlxTextAlign.RIGHT;
        listRightText.alpha = 0.0;
        add(listRightText);

        totalLeftText = new FlxText(bg.x + 45, bg.y + 364, bg.width, "TOTAL", 24);
        totalLeftText.font = "assets/data/PressStart2P.ttf";
        totalLeftText.color = 0xff4bf0f7;
		totalLeftText.camera = PlayState.cameraHUD;
        totalLeftText.alpha = 0.0;
        add(totalLeftText);

        totalRightText = new FlxText(bg.x + 36, bg.y + 364, bg.width - 87, "", 24);
        totalRightText.font = "assets/data/PressStart2P.ttf";
        totalRightText.color = 0xff4bf0f7;
		totalRightText.camera = PlayState.cameraHUD;
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


        continueButton = new FlxButton(bg.x + 242, bg.y + 408, "Continue", function() { closeWindow(); });
        continueButton.loadGraphic("assets/images/button.png", true, 255, 69);
        continueButton.label.font = "assets/data/PressStart2P.ttf";
        continueButton.label.color = 0xffffff;
        continueButton.label.size = 24;
        continueButton.labelOffsets = [new FlxPoint(-3.0, 21.0), new FlxPoint(-3.0, 21.0), new FlxPoint(-3.0, 21.0)];
        continueButton.onOver.callback = function() { continueButton.label.color = 0xff4bf0f7; };
        continueButton.onOut.callback = function() { continueButton.label.color = 0xffffffff; };
        continueButton.camera = PlayState.cameraHUD;
        continueButton.alpha = 0.0;
        add(continueButton);


        bg.y -= slideInAmount;
        titleText.y -= slideInAmount;
        listLeftText.y -= slideInAmount;
        listRightText.y -= slideInAmount;
        totalLeftText.y -= slideInAmount;
        totalRightText.y -= slideInAmount;
        continueButton.y -= slideInAmount;

        tweens.tween(fadedBg, { alpha: 0.5 }, 0.3, { ease: FlxEase.quadOut });

        tweens.tween(bg, { alpha: 1.0 }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(titleText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(listLeftText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(listRightText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(totalLeftText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(totalRightText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(continueButton, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });

        tweens.tween(bg, { y: bg.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(titleText, { y: titleText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(listLeftText, { y: listLeftText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(listRightText, { y: listRightText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(totalLeftText, { y: totalLeftText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(totalRightText, { y: totalRightText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(continueButton, { y: continueButton.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (waitToClose > 0.0) {
            waitToClose -= elapsed;
            if (waitToClose <= 0.0) {
                PlayState.cameraHUD.fade(0xff1b1c23, 1.2, true, null, true);
                close();
            }
        }
        else if (FlxG.keys.justPressed.SPACE) {
            closeWindow();            
        }
    }

    function closeWindow() {
        tweens.tween(titleText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(listLeftText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(listRightText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(totalLeftText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(totalRightText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(continueButton, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(bg, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut, startDelay: 0.3 });
        //if (PlayState.cash <= 0)
          //  tweens.tween(fadedBg, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut, startDelay: 0.3 });

        tweens.tween(bg, { y: bg.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(titleText, { y: titleText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(listLeftText, { y: listLeftText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(listRightText, { y: listRightText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(totalLeftText, { y: totalLeftText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(totalRightText, { y: totalRightText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        if (PlayState.cash <= 0)
            tweens.tween(continueButton, { y: continueButton.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25, onComplete: function(tween) { waitToClose = 0.4; PlayState.cameraHUD.fade(0xff1b1c23, 0.4); } });
        else
            tweens.tween(continueButton, { y: continueButton.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25, onComplete: function(tween) { cast(FlxG.state, PlayState).openSubState(new ShopWindow("SHOP")); close(); } });
    }
}
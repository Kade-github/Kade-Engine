package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.misc.NumTween;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	public static var initialized:Bool;
	public static var leftOnce:Bool;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	var loaded:Bool;

	var scrollMultiplier:Float = 1;

	var noMoreSpamming:Bool = true;

	override public function create():Void
	{
		super.create();
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			textGroup = new FlxGroup();
			credGroup = new FlxGroup();
			bg = new FlxTypedGroup<FlxSprite>();
			panelTop = new FlxTypedGroup<FlxSprite>();
			ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
			panelBottom = new FlxTypedGroup<FlxSprite>();
			bob = new FlxSprite(FlxG.width * 0.5, -150);
			bosip = new FlxSprite(-230, -150);
			gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
			logoBl = new FlxSprite(-150, -40);
			titleText = new FlxSprite(125, FlxG.height * 0.8);
			
			startIntro();
		});
		
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var bob:FlxSprite;
	var bosip:FlxSprite;
	
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var bg:FlxTypedGroup<FlxSprite>;
	var panelTop:FlxTypedGroup<FlxSprite>;
	var panelBottom:FlxTypedGroup<FlxSprite>;
	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('menuIntro'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}
		if (FreeplayState.bpm > 0)
			Conductor.changeBPM(FreeplayState.bpm);
		else
			Conductor.changeBPM(120);
		persistentUpdate = true;

		
		add(bg);
		
		
		add(panelTop);

		
		bob.scale.set(0.55, 0.55);
		bob.frames = Paths.getSparrowAtlas('titlemenu/Start_Screen_bob');
		bob.animation.addByPrefix('idle', 'amortitle', 24, false);
		bob.antialiasing = true;
		add(bob);

		
		bosip.scale.set(0.55, 0.55);
		bosip.frames = Paths.getSparrowAtlas('titlemenu/Start_Screen_bosip');
		bosip.animation.addByPrefix('idle', 'bosiptitle', 24, false);
		bosip.antialiasing = true;
		add(bosip);

		
		add(panelBottom);

		for (i in 1...3) {
			var index:Int = i;

			switch (i) {
				case 3:
					index = 1;
				case 4:
					index = 2;
			}

			var spr = new FlxSprite(-FlxG.width).loadGraphic(Paths.image('titlemenu/backgroundTile' + index));
			spr.x = FlxG.width * (i - 1);
			spr.antialiasing = true;
			bg.add(spr);

			var spr4 = new FlxSprite(-FlxG.width, -FlxG.height).loadGraphic(Paths.image('titlemenu/backgroundTile' + index));
			spr4.x = FlxG.width * (i - 1);
			spr4.antialiasing = true;
			bg.add(spr4);

			var spr5 = new FlxSprite(-FlxG.width, FlxG.height).loadGraphic(Paths.image('titlemenu/backgroundTile' + index));
			spr5.x = FlxG.width * (i - 1);
			spr5.antialiasing = true;
			bg.add(spr5);

			var spr2 = new FlxSprite(-FlxG.width).loadGraphic(Paths.image('titlemenu/panelTopTile' + index));
			spr2.x = FlxG.width * (i - 1);
			spr2.antialiasing = true;
			panelTop.add(spr2);

			var spr3 = new FlxSprite(-FlxG.width).loadGraphic(Paths.image('titlemenu/panelBottomTile' + index));
			spr3.x = FlxG.width * (i - 1);
			spr3.antialiasing = true;
			panelBottom.add(spr3);
		}
		

		
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		logoBl.scale.set(0.80, 0.80);
		logoBl.screenCenter(X);
		// logoBl.color = FlxColor.BLACK;

		
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		//add(gfDance);
		add(logoBl);

		

		
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		
		add(credGroup);
	

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized) {
			new FlxTimer().start(0.02, function(tmr:FlxTimer)
			{
				noMoreSpamming = false;
				skipIntro();
			});
		} else {
			noMoreSpamming = false;
			initialized = true;
		}
		// credGroup.add(credTextShit);
		curWacky = FlxG.random.getObject(getIntroTextShit());
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		new FlxTimer().start(1.1, function(tmr:FlxTimer)
		{
			if (FlxG.sound.music != null)
				Conductor.songPosition = FlxG.sound.music.time;
			// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

			if (FlxG.keys.justPressed.F)
			{
				FlxG.fullscreen = !FlxG.fullscreen;
			}

			var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

			#if mobile
			for (touch in FlxG.touches.list)
			{
				if (touch.justPressed)
				{
					pressedEnter = true;
				}
			}
			#end

			if (FlxG.keys.justPressed.ESCAPE && !transitioning) {
				if (FreeplayState.bpm > 0)
					FreeplayState.bpm = 0;
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.camera.flash(FlxColor.WHITE, 0.6);
				var blackscreen:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				add(blackscreen);

				new FlxTimer().start(0.6, function(tmr:FlxTimer)
				{
					FlxG.switchState(new DesktopState());
				});	
			}
			if (pressedEnter && !transitioning && skippedIntro && !noMoreSpamming)
			{
				#if !switch
				NGio.unlockMedal(60960);

				// If it's Friday according to da clock
				if (Date.now().getDay() == 5)
					NGio.unlockMedal(61034);
				#end

				if (FlxG.save.data.flashing)
					titleText.animation.play('press');

				//FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
				/*FlxTween.tween(FlxG.camera, {y: FlxG.camera.y + 50}, 0.6, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) {
					FlxTween.tween(FlxG.camera, {y: 1000}, 0.6, {ease: FlxEase.quadIn});
				}});*/
				
				// FlxG.sound.music.stop();
				outTransition();
				MainMenuState.firstStart = true;

				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					FlxG.switchState(new MainMenuState());

				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}

			if (pressedEnter && !skippedIntro && initialized && !noMoreSpamming)
			{
				skipIntro();
			}
			if (skippedIntro) {
				for (i in bg) {
					i.x -= 0.7 * scrollMultiplier;
					if (i.x <= -FlxG.width)
						i.x = (FlxG.width - 3);
					
				}
				for (i in panelTop) {
					i.x -= 1;
					if (i.x <= -FlxG.width)
						i.x = (FlxG.width);
					
				}
				for (i in panelBottom) {
					i.x -= 1;
					if (i.x <= -FlxG.width)
						i.x = (FlxG.width);
					
				}
			}
		});
		super.update(elapsed);
	}
	
	function outTransition()
	{
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		FlxTween.tween(bob, {y: bob.y + 80}, 0.7, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) {
			FlxTween.tween(bob, {y: bob.y + 1200}, 0.6, {ease: FlxEase.quadIn});
		}});

		FlxTween.tween(bosip, {y: bosip.y + 80}, 0.7, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) {
			FlxTween.tween(bosip, {y: bosip.y + 1200}, 0.6, {ease: FlxEase.quadIn});
		}});
		for (spr in panelTop) {
			//FlxTween.tween(spr, {y: spr.y +}, 0.6, {ease: FlxEase.quadIn});
			FlxTween.tween(spr, {y: spr.y - 20}, 0.6, {});
			FlxTween.tween(spr, {y: spr.y - 50}, 0.4, {ease: FlxEase.quadIn, startDelay: 0.5, onComplete: function(twn:FlxTween) {
				FlxTween.tween(spr, {y: spr.y - 600}, 0.4, {ease: FlxEase.quadIn});
			}});
		}
		for (spr in panelBottom) {
			FlxTween.tween(spr, {y: spr.y + 20}, 0.6, {});
			FlxTween.tween(spr, {y: spr.y + 50}, 0.4, {ease: FlxEase.quadIn, startDelay: 0.5, onComplete: function(twn:FlxTween) {
				FlxTween.tween(spr, {y: spr.y + 600}, 0.4, {ease: FlxEase.quadIn});
			}});
		}
		for (spr in bg) {
			FlxTween.tween(spr, {alpha: 0}, 0.4, {ease: FlxEase.quadIn, startDelay: 0.8,});
			/*FlxTween.tween(spr, {x: -FlxG.width}, 1, {ease: FlxEase.quadIn, startDelay: 0.2, onComplete: function(twn:FlxTween) {
				FlxTween.tween(spr, {x: -FlxG.width * 4}, 1, {ease: FlxEase.quadIn});
			}});*/
			FlxTween.num(1, 30, 1.3, {ease: FlxEase.quadIn}, applyShit.bind());
		}
		FlxTween.tween(FlxG.camera, {zoom: 0.8}, 1.3, {ease: FlxEase.quadIn,});
		FlxTween.tween(logoBl, {y: logoBl.y - 50}, 0.6, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) {
			FlxTween.tween(logoBl, {y: logoBl.y - 600}, 0.6, {ease: FlxEase.quadIn});
			
		}});
		//FlxTween.tween(bg, {y: bg.y + 2000}, 1, {ease: FlxEase.quadIn, startDelay: 1});
		FlxTween.tween(titleText, {y: titleText.y + 2000}, 1, {ease: FlxEase.quadIn, startDelay: 1});
		transitioning = true;
	}
	function applyShit(v:Float)
	{
		scrollMultiplier = v;
		trace(scrollMultiplier);
	}
	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}
	override function stepHit() {
		super.stepHit();
		new FlxTimer().start(1.1, function(tmr:FlxTimer)
		{
			if (curStep % 4 == 3 && skippedIntro) {
				bob.animation.play('idle', true);
				bosip.animation.play('idle', true);
				logoBl.animation.play('bump', true);
			}
		});
	}
	override function beatHit()
	{
		super.beatHit();
		new FlxTimer().start(1.1, function(tmr:FlxTimer)
		{
			if (skippedIntro) {
				
				danceLeft = !danceLeft;

				if (danceLeft)
					gfDance.animation.play('danceRight');
				else
					gfDance.animation.play('danceLeft');
			}
			FlxG.log.add(curBeat);
			if (!leftOnce) {
				switch (curBeat)
				{
					case 1:
						//createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
					// credTextShit.visible = true;
					case 3:
						//addMoreText('present');
						createCoolText(['NimuUwU', 'presents']);
					// credTextShit.text += '\npresent...';
					// credTextShit.addText();
					case 4:
						deleteCoolText();
					// credTextShit.visible = false;
					// credTextShit.text = 'In association \nwith';
					// credTextShit.screenCenter();
					case 5:
						if (Main.watermarks)
							createCoolText(['Kade Engine', 'modified by']);
						else
							createCoolText(['In Partnership', 'with']);
					case 7:
						if (Main.watermarks)
							addMoreText('Ash');
						else
						{
							addMoreText('Newgrounds');
							ngSpr.visible = true;
						}
					// credTextShit.text += '\nNewgrounds';
					case 8:
						deleteCoolText();
						ngSpr.visible = false;
					// credTextShit.visible = false;

					// credTextShit.text = 'you look sussy';
					// credTextShit.screenCenter();
					case 9:
						createCoolText([curWacky[0]]);
					// credTextShit.visible = true;
					case 11:
						addMoreText(curWacky[1]);
					// credTextShit.text += '\nlmao';
					case 12:
						deleteCoolText();
					// credTextShit.visible = false;
					// credTextShit.text = "Vs";
					// credTextShit.screenCenter();
					case 13:
						addMoreText('Vs');
					// credTextShit.visible = true;
					case 14:
						addMoreText('Jefferson13n');
					// credTextShit.text += '\nJefferson13n';
					case 15:
						addMoreText('lol'); // credTextShit.text += '\nlol';
					case 16:
						skipIntro();
				}
			}
		});
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 2);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}

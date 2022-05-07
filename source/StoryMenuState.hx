package;

import flixel.FlxBasic;
import flixel.math.FlxRect;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.geom.Point;


import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
import flixel.addons.transition.FlxTransitionableState;
import io.newgrounds.NG;
import lime.app.Application;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;

#if windows
import Discord.DiscordClient;
import sys.FileSystem;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	

	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<MenuItem>;
	var inCredits:Bool = false;
	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end
	var creditsLayer1:FlxTypedGroup<CreditIcon>;
	var creditsLayer2:FlxTypedGroup<CreditIcon>;
	var creditsLayer3:FlxTypedGroup<CreditIcon>;
	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;
	var lerpCamera:Bool = false;
	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.1" + nightly;
	public static var gameVer:String = "0.2.7.1";
	public static var showRon:Bool = false;
	public static var firsttimeBob:Bool = false;
	public static var firsttimeGloopy:Bool = false;
	public static var firsttimeITB:Bool = false;
	public static var firsttimeSplitEX:Bool = false;

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;
	public static var prevCharacter:Int = 99;
	var character:Character;
	var targetY:Float;
	var logoBl:FlxSprite;
	var targetX:Int;
	var creditsLogo:FlxSprite;
	var logoSHIT:Int = 0;
	var vocals:FlxSound;
	var vocals2:FlxSound;

	var yellow:FlxSprite;
	var blue:FlxSprite;
	var lock:FlxSprite;
	var actuallyInCredits:Bool = false;
	var arrow:FlxSprite;
	var lerpArrow:Bool = false;
	var grpBackgrounds:FlxTypedGroup<FlxSprite>;
	var grpLogo:FlxTypedGroup<FlxSprite>;
	var bgCycleTimer:Int = 500;
	var bgCycle:Int = 0;
	var tweenMenuItems:Bool = false;
	var easterEggChance:Int;
	var curCharacter:String;

	var colorPalette:String = 'normal';
	var character2:Character;
	var targetX2:Int;
	var useCharacter2:Bool = false;
	var useCharacter2alt:Bool = false;
	override function create()
	{
		
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		FlxG.camera.zoom = 1.5;
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('menuIntro'));
		}
		FlxG.mouse.visible = false;
		persistentUpdate = persistentDraw = true;
		selectedSomethin = true;
		
		

		var excludeStuff:Array<Int> = [];
		if (!FlxG.save.data.beatWeek) {
			excludeStuff.push(9);
		}
		if (!FlxG.save.data.beatBob) {
			excludeStuff.push(8);
		}
		if (!FlxG.save.data.beatITB) {
			for (i in 2...8) {
				excludeStuff.push(i);
			}
			excludeStuff.push(10);
		}
		if (!FlxG.save.data.playedGO)
			excludeStuff.push(11);
	
		grpBackgrounds = new FlxTypedGroup<FlxSprite>();
		add(grpBackgrounds);

		grpLogo = new FlxTypedGroup<FlxSprite>();
		add(grpLogo);
		rerollCharacter(excludeStuff);
		
		easterEggChance = FlxG.random.int(0, 50);
		var deadrontwigger:Bool = false;
		var pctrigger:Bool = false;
		if (easterEggChance == 25) {
			character = new Character(2000, 300, 'pc');
			targetX = 760;
			curCharacter = 'amor';
			colorPalette = 'normal';
			pctrigger = true;
		}
		if (easterEggChance == 26) {
			character = new Character(2000, 170, 'cj');
			targetX = 740;
			curCharacter = 'cj';
			colorPalette = 'normal';
		}
		if (easterEggChance == 28) {
			character = new Character(2000, 180, 'ash');
			targetX = 700;
			curCharacter = 'ash';
			colorPalette = 'itb';
			character2 = new Character(2000, 450, 'cerbera');
			targetX2 = 900;
			useCharacter2 = true;
		}
		if (FlxG.save.data.beatBob && easterEggChance == 27) {
			character = new Character(2000, -50, 'deadron');
			targetX = -600;
			curCharacter = 'deadron';
			showRon = false;
			colorPalette = 'gloopy';
			deadrontwigger = true;
		}
		
		
		if (showRon) {
			character = new Character(2000, -50, 'deadron');
			targetX = -600;
			curCharacter = 'deadron';
			showRon = false;
			colorPalette = 'gloopy';
		}
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			if (firsttimeSplitEX) {
				if (!FlxG.save.data.beatSplitEX) {
					achievementArray.push('unlocked 8-bit split in the sound test!');
					FlxG.save.data.beatSplitEX = true;
				}
				if (!FlxG.save.data.beatSplitEX2) {
					achievementArray.push('unlocked oblique fracture in the desktop!');
					FlxG.save.data.beatSplitEX2 = true;
				}
				firsttimeSplitEX = false;
			}
			if (firsttimeBob) {
				achievementArray.push('unlocked EX difficulty in freeplay!');
				achievementArray.push('new stuff has appeared in story mode!');
				achievementArray.push('unlocked new music in the sound test!');
				firsttimeBob = false;
			}
			if (firsttimeGloopy) {
				achievementArray.push('unlocked new art in the gallery!');
				achievementArray.push('unlocked new music in the sound test!');
				firsttimeGloopy = false;
			}
			if (firsttimeITB) {
				
				achievementArray.push('new stuff has appeared in story mode?');
				achievementArray.push('unlocked new art in the gallery!');
				achievementArray.push('unlocked new music in the sound test!');
				firsttimeITB = false;
			}
		});
		
		//character.debugMode = true;
		character.scale.set(0.8, 0.8);
		character.scrollFactor.set(0, 0);
		character.menuMode = true;
		add(character);

		if (useCharacter2) {
			character2.scale.set(0.8, 0.8);
			character2.scrollFactor.set(0, 0);
			character2.menuMode = true;
			add(character2);

		}

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		// magenta.scrollFactor.set();

		
		switch (colorPalette) {
			case 'gloopy':
				for (i in 1...5) {
					trace(i);
					var daBG = new FlxSprite(FlxG.width).loadGraphic(Paths.image('mainmenu/gloopy/background' + i));
					daBG.scrollFactor.set();
					daBG.updateHitbox();
					daBG.antialiasing = true;
					daBG.alpha = 0;
					grpBackgrounds.add(daBG);
				}
			case 'itb':
				for (i in 1...6) {
					trace(i);
					var daBG = new FlxSprite(FlxG.width).loadGraphic(Paths.image('mainmenu/itb/background ' + i));
					daBG.scrollFactor.set();
					daBG.updateHitbox();
					daBG.antialiasing = true;
					daBG.alpha = 0;
					grpBackgrounds.add(daBG);
				}
			default:
				for (i in 1...8) {
					trace(i);
					var daBG = new FlxSprite(FlxG.width).loadGraphic(Paths.image('mainmenu/background' + i));
					daBG.scrollFactor.set();
					daBG.updateHitbox();
					daBG.antialiasing = true;
					daBG.alpha = 0;
					grpBackgrounds.add(daBG);
				}
		}
		
		var rando:FlxRandom = new FlxRandom();
		bgCycle = rando.int(0, grpBackgrounds.length - 1);
		grpBackgrounds.members[bgCycle].alpha = 1;

		switch (colorPalette) {
			case 'gloopy':
				blue = new FlxSprite(-800).loadGraphic(Paths.image('mainmenu/gloopy/leftPanel'));
			case 'itb':
				blue = new FlxSprite(-800).loadGraphic(Paths.image('mainmenu/itb/leftPanel'));
			default:
				blue = new FlxSprite(-800).loadGraphic(Paths.image('mainmenu/leftPanel'));
		}
		
		blue.scrollFactor.set();
		blue.updateHitbox();
		blue.antialiasing = true;
		add(blue);

		switch (colorPalette) {
			case 'gloopy':
				arrow = new FlxSprite(-2380, 540).loadGraphic(Paths.image('mainmenu/gloopy/menuArrow'));
			case 'itb':
				arrow = new FlxSprite(-2380, 540).loadGraphic(Paths.image('mainmenu/itb/menuArrow'));
			default:
				arrow = new FlxSprite(-2380, 540).loadGraphic(Paths.image('mainmenu/menuArrow'));
		}
		arrow.angle = -7;
		arrow.scrollFactor.set();
		arrow.updateHitbox();
		arrow.antialiasing = true;
		add(arrow);

		
		logoBl = new FlxSprite(1500, -120);
		switch (colorPalette) {
			case 'gloopy':
				logoBl.frames = Paths.getSparrowAtlas('TakeoverLogo');
			case 'itb':
				logoBl.frames = Paths.getSparrowAtlas('ITBlogo');
			default:
				logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		}
		logoBl.scrollFactor.set();
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		logoBl.scale.set(0.64, 0.64);
		grpLogo.add(logoBl);

		creditsLogo = new FlxSprite(-1500, 30);
		creditsLogo.frames = Paths.getSparrowAtlas('FNF_main_menu_assets');
		creditsLogo.scrollFactor.set(1, 0);
		creditsLogo.antialiasing = true;
		creditsLogo.animation.addByPrefix('bump', 'donate basic', 24, true);
		creditsLogo.animation.play('bump');
		creditsLogo.updateHitbox();
		creditsLogo.scale.set(0.6, 0.6);
		add(creditsLogo);
		menuItems = new FlxTypedGroup<MenuItem>();
		add(menuItems);

		creditsLayer1 = new FlxTypedGroup<CreditIcon>();
		add(creditsLayer1);
		creditsLayer2 = new FlxTypedGroup<CreditIcon>();
		add(creditsLayer2);
		creditsLayer3 = new FlxTypedGroup<CreditIcon>();
		add(creditsLayer3);
		inCredits = true;
		for (i in grpBackgrounds) {
			FlxTween.tween(i, {x: FlxG.width - 500}, 0.3, {
				//ease: FlxEase.quadIn,
				startDelay:0.2,
				onComplete: function(twn:FlxTween) {
					FlxTween.tween(i, {x: 0}, 0.3, {});
				}
			});
		}
		FlxTween.tween(FlxG.camera, {zoom: 0.97}, 0.8, {
			//ease: FlxEase.quadIn,
			//startDelay: 0.6,
			onComplete: function(twn:FlxTween) {
				lerpCamera = true;
			}
		});
		FlxTween.tween(blue, {x: -FlxG.width + 500}, 0.3, {
			//ease: FlxEase.quadIn,
			startDelay: 0.2,
			onComplete: function(twn:FlxTween) {
				FlxTween.tween(blue, {x: 0}, 0.3, {
					onComplete: function(twn:FlxTween) {
						FlxG.camera.shake(0.005, 0.05);
					}
				});
				
			}
		});
		FlxTween.tween(arrow, {x: -280, y: 230}, 0.6, {
			ease: FlxEase.quadOut,
			startDelay: 0.6,
			onComplete: function(twn:FlxTween) {
				lerpArrow = true;
			}
		});
		if (!useCharacter2alt) {
			FlxTween.tween(character, {x: targetX}, 1, {
				ease: FlxEase.quadOut,
				startDelay:0.25,
				onComplete: function(twn:FlxTween) {
					if (deadrontwigger)
						FlxG.sound.play(Paths.sound('third_scream', 'shared'), 0.5);
					if (pctrigger)
						FlxG.sound.play(Paths.sound('MIRAGE_95_x2', 'shared'), 0.5);
	
					switch (curCharacter) {
						case 'cj':
							character.playAnim('haha', true);
							FlxG.sound.play(Paths.sound('cjhaha', 'shared'), 0.6);
							character.holdTimer = 0;	
					}
	
					selectedSomethin = false;
					inCredits = false;
				}
			});
		} else {
			FlxTween.tween(character2, {x: targetX2}, 1, {
				ease: FlxEase.quadOut,
				startDelay:0.25,
				onComplete: function(twn:FlxTween) {
					if (deadrontwigger)
						FlxG.sound.play(Paths.sound('third_scream', 'shared'), 0.5);
					if (pctrigger)
						FlxG.sound.play(Paths.sound('MIRAGE_95_x2', 'shared'), 0.5);
	
					switch (curCharacter) {
						case 'cj':
							character.playAnim('haha', true);
							FlxG.sound.play(Paths.sound('cjhaha', 'shared'), 0.6);
							character.holdTimer = 0;	
					}
	
					selectedSomethin = false;
					inCredits = false;
				}
			});
		}
		

		if (useCharacter2 || useCharacter2alt) {
			FlxTween.tween(character2, {x: targetX2}, 1, {
				ease: FlxEase.quadOut,
				startDelay:0.25,
			});
		}
		FlxTween.tween(logoBl, {x: 470}, 0.6, {
			ease: FlxEase.quadIn,
			startDelay:0.25
		});
		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');
		vocals2 = new FlxSound();
		if (FreeplayState.bpm > 0) {
			Conductor.changeBPM(FreeplayState.bpm);
			if (FreeplayState.isEX) {
				if (curCharacter != 'deadron' && curCharacter != 'cj' && curCharacter != 'cerberus') {
					vocals = FlxG.sound.play(Paths.voicesEXMenu(FreeplayState.curSong, curCharacter));
				} else {
					vocals = new FlxSound();
				}
				if (useCharacter2) {
					vocals2 = FlxG.sound.play(Paths.voicesEXMenu(FreeplayState.curSong, 'cerbera')); 
				}
			} else {
				if (curCharacter != 'deadron' && curCharacter != 'cj' && curCharacter != 'cerberus') {
					trace(curCharacter);
					vocals = FlxG.sound.play(Paths.voicesMenu(FreeplayState.curSong, curCharacter));
				} else {
					vocals = new FlxSound();
				}
				if (useCharacter2) {
					vocals2 = FlxG.sound.play(Paths.voicesMenu(FreeplayState.curSong, 'cerbera')); 
				}
				
			}
			vocals.volume = 0;
			//vocals.play();
			vocals.time = FlxG.sound.music.time;
			if (useCharacter2){
				vocals2.volume = 0;
				vocals2.time = FlxG.sound.music.time;
			}
		} else
			Conductor.changeBPM(120);
		for (i in 0...optionShit.length)
		{
			var menuItem:MenuItem = new MenuItem(-1300, 60 + (i * 160));
			menuItem.frames = Paths.getSparrowAtlas('FNF_main_menu_assets');
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.centerOrigin();
			menuItem.scrollFactor.set();
			menuItem.ID = i;
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.9));
			menuItem.updateHitbox();
			menuItem.angle = -7;
			menuItems.add(menuItem);
			menuItem.antialiasing = true;
			finishedFunnyMove = true; 
		}
		
		changeItem();
		for (i in menuItems) {
			var daTarget:Int = 0;
			switch (menuItems.members.indexOf(i)) {
				case 0:
					daTarget = -50;
				case 1:
					daTarget = -20;
				case 2:
					daTarget = 10;
				case 3:
					daTarget = -30;
			} 
			for (i in menuItems.members) {
				FlxTween.tween(i, {x: daTarget}, 0.6, {
					ease: FlxEase.quadIn,
					startDelay:0.25,
					onComplete: function(twn:FlxTween) {
						tweenMenuItems = true;
					},
				});
			}
		}
		firstStart = false;

		//FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		

		super.create();
		lock = new FlxSprite().loadGraphic(Paths.image('mainmenu/Lock'));
		lock.scrollFactor.set(1, 1);
	}

	var selectedSomethin:Bool = false;

	function rerollCharacter(excludeArray:Array<Int>) {
		var random:Int = 0;
		
		
		random = FlxG.random.int(0,12, excludeArray);
		if (random == prevCharacter) {
			random++;
			if (random > 12)
				random = 0;
		}
		prevCharacter = random;
		if (FreeplayState.bpm > 0 && FreeplayState.isEX) {
			switch (random) {
				case 12:
					character = new Character(2000, 350, 'sans-ex');
					targetX = 750;
					curCharacter = 'sans';
					colorPalette = 'normal';
				case 11:
					character = new Character(2000, 350, 'deadbf');
					targetX = 760;
					curCharacter = 'deadbf';
					colorPalette = 'normal';
				case 10:
					character = new Character(2000, 50, 'cerberus-ex');
					targetX = 650;
					curCharacter = 'cerberus';
					colorPalette = 'itb';
				case 9:
					character = new Character(2000, 150, 'amor-ex');
					targetX = 700;
					curCharacter = 'amor';
					colorPalette = 'normal';
				case 8:
					character = new Character(2000, 300, 'bob-cool-ex');
					targetX = 700;
					curCharacter = 'gloopy';
					colorPalette = 'gloopy';
				case 7:
					character = new Character(2000, 180, 'bluskys-ex');
					targetX = 750;
					curCharacter = 'bluskys';
					colorPalette = 'itb';
				case 6:
					character = new Character(2000, 180, 'bluskys-ex');
					targetX = 750;
					curCharacter = 'bluskys';
					colorPalette = 'itb';
				case 5:
					character = new Character(2000, 180, 'ash-ex');
					targetX = 800;
					curCharacter = 'ash';
					colorPalette = 'itb';
				case 4:
					character = new Character(2000, 300, 'cerbera-ex');
					targetX = 790;
					curCharacter = 'cerbera';
					colorPalette = 'itb';
				case 3:
					character = new Character(2000, 180, 'minishoey-ex');
					targetX = 740;
					curCharacter = 'minishoey';
					colorPalette = 'itb';
				case 2:
					character = new Character(2000, 180, 'bob-ex');
					targetX = 800;
					curCharacter = 'bob';
					colorPalette = 'normal';
				case 1:
					character = new Character(2000, 150, 'bosip-ex');
					targetX = 820;
					curCharacter = 'bosip';
					colorPalette = 'normal';
				case 0:
					character = new Character(2000, 400, 'bf-ex-new', true);
					targetX = 760;
					curCharacter = 'bf';
					colorPalette = 'normal';
		}
		} else {
			switch (random) {
				case 12:
					character = new Character(2000, 350, 'sans');
					targetX = 750;
					curCharacter = 'sans';
					colorPalette = 'normal';
				case 11:
					rerollCharacter(excludeArray);
				case 10:
					character = new Character(2000, 300, 'cerberus');
					targetX = 650;
					curCharacter = 'cerberus';
					colorPalette = 'itb';
				case 9:
					character = new Character(2000, 150, 'amor');
					targetX = 700;
					curCharacter = 'amor';
					colorPalette = 'normal';
				case 8:
					character = new Character(2000, 300, 'gloopy');
					targetX = 700;
					curCharacter = 'gloopy';
					colorPalette = 'gloopy';
				case 7:
					character = new Character(2000, 150, 'jghost');
					targetX = 700;
					curCharacter = 'jghost';
					colorPalette = 'itb';
				case 6:
					character = new Character(2000, 180, 'bluskys');
					targetX = 750;
					curCharacter = 'bluskys';
					colorPalette = 'itb';
				case 5:
					character = new Character(2000, 180, 'ash');
					targetX = 800;
					curCharacter = 'ash';
					colorPalette = 'itb';
				case 4:
					character = new Character(2000, 450, 'cerbera');
					targetX = 800;
					curCharacter = 'cerbera';
					colorPalette = 'itb';
				case 3:
					character = new Character(2000, 180, 'minishoey');
					targetX = 800;
					curCharacter = 'minishoey';
					colorPalette = 'itb';
				case 2:
					character = new Character(2000, 180, 'bob');
					targetX = 800;
					curCharacter = 'bob';
					colorPalette = 'normal';
				case 1:
					character = new Character(2000, 150, 'bosip');
					targetX = 820;
					curCharacter = 'bosip';
					colorPalette = 'normal';
				case 0:
					character = new Character(2000, 400, 'bf', true);
					targetX = 760;
					curCharacter = 'bf';
					colorPalette = 'normal';
			}
		}
	}
	override function update(elapsed:Float)
	{
		if (character.curCharacter == 'jghost-ex') {
			switch (character2.animation.curAnim.name) {	
				case 'idle':
					switch (character2.animation.curAnim.curFrame) {
						case 0 | 1:
							character.setPosition(-280, 0);
						case 2 | 3:
							character.setPosition(-281, 0);
						case 4 | 5:
							character.setPosition(-289, -5);
						case 7 | 6:
							character.setPosition(-290, -8);
						case 9 | 8:
							character.setPosition(-291, -8);
						default:
							character.setPosition(-291, -8);
					}
				case 'singUP' | 'singDOWN' | 'singLEFT' | 'singRIGHT':
					switch (character2.animation.curAnim.curFrame) {
						case 0 | 1:
							character.setPosition(-297, -8);
						case 2 | 3:
							character.setPosition(-295, -6);
						case 4 | 5:
							character.setPosition(-297, -7);
						case 7 | 6:
							character.setPosition(-298, -8);
						case 9 | 8:
							character.setPosition(-297, -7);
						default:
							character.setPosition(-297, -7);
					}
			}
		}
		if (FreeplayState.bpm > 0) {
			
			if (character.animation.curAnim.name.startsWith('sing')) {
				vocals.volume = 1;
				if (useCharacter2) {
					vocals2.volume = 1;
				}
			} else {
				vocals.time = FlxG.sound.music.time;
				vocals.volume = 0;
				if (useCharacter2) {
					vocals2.time = FlxG.sound.music.time;
					vocals2.volume = 0;
				}
			}
		}
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		
		for (item in menuItems.members){
			/*if (menuItems.members.indexOf(menuItems.members[i]) == 3) {
				menuItems.members[i].y = FlxMath.lerp(menuItems.members[i].y, (-1 * 500) + 60, 0.16);
			} else */
			//var targetY = menuItems.members.indexOf(menuItems.members[i], curSelected);
			var offsetX:Int = 0;
			var offsetY:Int = 0;
			if (Math.abs(item.targetY) > 1)
				offsetX = -50;
			if (Math.abs(item.targetY) < 0)
				offsetY = 30;

			if (item.shittedOneself) {
				if (tweenMenuItems)
					item.x = (item.targetY * 30 + offsetX) - 600;
				item.y = (item.targetY * 180) + offsetY - 100;
			} else {
				if (tweenMenuItems)
					item.x = FlxMath.lerp(item.x, (item.targetY * 30 + offsetX) + 40, 0.16);
				item.y = FlxMath.lerp(item.y, (item.targetY * 180) + offsetY + 260, 0.16);
			}
		}
		if (bgCycleTimer <= 0) {
			FlxTween.tween(grpBackgrounds.members[bgCycle], {alpha: 0}, 0.6, {
				//ease: FlxEase.quadIn,
			});
			bgCycle++;
			if (bgCycle > grpBackgrounds.length - 1)
				bgCycle = 0;
			FlxTween.tween(grpBackgrounds.members[bgCycle], {alpha: 1}, 0.6, {
				//ease: FlxEase.quadIn,
			});
			bgCycleTimer = 500;
		} else
			bgCycleTimer--;
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		if (lerpArrow) {
			arrow.x = FlxMath.lerp(arrow.x, -280, 0.03);
			arrow.y = FlxMath.lerp(arrow.y, 230, 0.03);
			arrow.color = FlxColor.interpolate(arrow.color, FlxColor.WHITE, 0.07);
		}
		if (lerpCamera)
			FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, 0.09);
		lock.x = menuItems.members[1].getGraphicMidpoint().x - 140;
		lock.y = menuItems.members[1].y - menuItems.members[1].height / 2;
		lock.scale.set(menuItems.members[1].scale.x, menuItems.members[1].scale.y);
		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				if (!inCredits) {
					//FlxG.switchState(new TitleState());
					doTheFuckinTransition(new TitleState());
				} 
			}

			if (controls.ACCEPT)
			{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					menuItems.forEach(function(spr:FlxSprite)
					{
						var daChoice:String = optionShit[curSelected];

						switch (daChoice)
						{
							case 'story mode':
								doTheFuckinTransition(new StoryMenuState());
							case 'options':
								var theState:OptionsSubState = new OptionsSubState(new FlxPoint(590, 327)); 
								OptionsSubState.inDesktop = false;
								theState.closeFunction = enableMovement;
								openSubState(theState);
							case 'freeplay':
								doTheFuckinTransition(new FreeplayState());
							case 'donate':
								doTheFuckinTransition(new CreditState());
							}
					});
			}
		}

		super.update(elapsed);

		if (curCharacter == 'cj') {
			if (FlxG.keys.justPressed.I || FlxG.keys.justPressed.J || FlxG.keys.justPressed.K || FlxG.keys.justPressed.L) {
				character.playAnim('haha', true);
				FlxG.sound.play(Paths.sound('cjhaha', 'shared'), 0.6);
				character.holdTimer = 0;
			}
		} else {
			if (FlxG.keys.justPressed.I) {
				character.playAnim('singUP', true);
				character.holdTimer = 0;
				if (useCharacter2) {
					character2.playAnim('singUP', true);
					character2.holdTimer = 0;
				}
				if (curCharacter == 'cerberus')
					FlxG.sound.play(Paths.sound('CerberusBark', 'shared'), 0.6);
			}
			if (FlxG.keys.justPressed.K) {
				character.playAnim('singDOWN', true);
				character.holdTimer = 0;
				if (useCharacter2) {
					character2.playAnim('singDOWN', true);
					character2.holdTimer = 0;
				}
				if (curCharacter == 'cerberus')
					FlxG.sound.play(Paths.sound('CerberusBark', 'shared'), 0.6);
			}
			if (FlxG.keys.justPressed.J) {
				character.playAnim('singLEFT', true);
				character.holdTimer = 0;
				if (useCharacter2) {
					character2.playAnim('singLEFT', true);
					character2.holdTimer = 0;
				}
				if (curCharacter == 'cerberus')
					FlxG.sound.play(Paths.sound('CerberusBark', 'shared'), 0.6);
			}
			if (FlxG.keys.justPressed.L) {
				character.playAnim('singRIGHT', true);
				character.holdTimer = 0;
				if (useCharacter2) {
					character2.playAnim('singRIGHT', true);
					character2.holdTimer = 0;
				}
				if (curCharacter == 'cerberus')
					FlxG.sound.play(Paths.sound('CerberusBark', 'shared'), 0.6);
			}
		}
		/*if (FlxG.keys.justPressed.U) {
			character.playAnim('idle');
		}*/
		/*if (curCharacter == 'cj' && FlxG.keys.justPressed.O) {
			character.playAnim('haha', true);
			FlxG.sound.play(Paths.sound('cjhaha', 'shared'), 0.6);
			character.holdTimer = 0;
		}*/
		
		/*if (camFollow.y != targetY) {
			camFollow.y = FlxMath.lerp(camFollow.y, targetY, 0.7);
		}*/
	}

	override function beatHit()
	{
		super.beatHit();
		if (curBeat % 4 == 0 && lerpCamera)
			FlxG.camera.zoom = 1.015;
		
		if (!character.animation.curAnim.name.startsWith('sing') && character.animation.curAnim.name != 'haha')
			character.dance();

		if (!character.animation.curAnim.name.startsWith('sing') && character.animation.curAnim.name != 'haha')
			character.dance();
		if (useCharacter2) {
			if (!character2.animation.curAnim.name.startsWith('sing') && character2.animation.curAnim.name != 'haha')
				character2.dance();
		}
		if (useCharacter2alt) {
			if (!character2.animation.curAnim.name.startsWith('sing') && character2.animation.curAnim.name != 'haha')
				character2.dance();
		}
		logoSHIT++;
		if (logoSHIT > 1) {
			logoSHIT = 0;
			logoBl.animation.play('bump', true);
		}
	}
	function doTheFuckinTransition(daState:Dynamic) {
		selectedSomethin = true;
		if (FreeplayState.bpm > 0)
			vocals.stop();
		for (i in grpBackgrounds) {
			FlxTween.tween(i, {x: 50}, 0.6, {
				ease: FlxEase.quadOut,
			});
		}
		for (i in grpBackgrounds) {
			FlxTween.tween(i, {x: FlxG.width}, 0.6, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween) {
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					FlxG.switchState(daState);
				},
				startDelay:0.6
			});
		}
		FlxTween.tween(blue, {x: -50}, 0.6, {
			ease: FlxEase.quadOut,
		});
		FlxTween.tween(blue, {x: -800}, 0.6, {
			ease: FlxEase.quadOut,
			startDelay:0.6
		});
		inCredits = true;
		for (i in menuItems.members) {
			FlxTween.tween(i, {x: i.x - 50}, 0.6, {
				ease: FlxEase.quadOut,
			});
			FlxTween.tween(i, {x: i.x - 1000}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay:0.6
			});
			
		}
		if (!useCharacter2alt) {
			FlxTween.tween(character, {x: character.x + 50}, 0.6, {ease: FlxEase.quadOut});
			FlxTween.tween(character, {x: character.x + 2000}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay:0.6
			});
		} else {
			FlxTween.tween(character2, {x: character2.x + 50}, 0.6, {ease: FlxEase.quadOut});
			FlxTween.tween(character2, {x: character2.x + 2000}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay:0.6
			});
		}
		if (useCharacter2) {
			FlxTween.tween(character2, {x: character2.x + 50}, 0.6, {ease: FlxEase.quadOut});
			FlxTween.tween(character2, {x: character2.x + 2000}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay:0.6
			});
		}
		FlxTween.tween(FlxG.camera, {zoom: 3}, 2, {
			//ease: FlxEase.quadIn,
			startDelay: 0.6,
		});
		FlxTween.tween(logoBl, {x: logoBl.x + 50}, 0.6, {
			ease: FlxEase.quadOut,
		});
		FlxTween.tween(logoBl, {x: logoBl.x + 2000}, 0.6, {
			ease: FlxEase.quadOut,
			startDelay:0.6
		});
		FlxTween.tween(arrow, {x: -1280, y: 330}, 0.6, {
			ease: FlxEase.quadOut,
			startDelay: 0.6,
		});
	}


	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		if (lerpArrow) {
			arrow.x = -270;
			arrow.y = 228;
			arrow.color = FlxColor.fromHSB(arrow.color.hue, arrow.color.saturation, 0.8, arrow.color.alpha);
		}
		var bullShit:Int = 0;
		for (item in menuItems.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;
			item.shittedOneself = false;
			//im sorry this is so shit lol
			if (item.targetY == 3) {
				item.targetY = -1; 
				//item.shittedOneself = true;
			}
			if (item.targetY == -2 && curSelected > 1) {
				item.targetY = 2;
				//item.shittedOneself = true;
			}
			if (item.targetY == -3 && curSelected != 3) {
				item.targetY = 2;
				//item.shittedOneself = true;
			} else if (item.targetY == -3) {
				item.targetY = 1;
				//item.shittedOneself = true;
			}
			var offsetX = -90;
			var offsetY = 30;
			if (huh == -1 && item.targetY == -1) {
				item.x = (-2 * 30 + offsetX) - 600;
				item.y = (-2 * 180) + offsetY - 100;
			}
			if (huh == 1 && item.targetY == 2) {
				item.x = (3 * 30 + offsetX) - 600;
				item.y = (3 * 180) + offsetY - 100;
			}
		}
		trace(curSelected);
		menuItems.forEach(function(spr:MenuItem)
		{
			spr.animation.play('idle');
			
			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				
				spr.scale.set(0.6, 0.6);
				spr.updateHitbox();
				targetY = spr.getGraphicMidpoint().y;
				
				//camFollow.y = FlxMath.lerp(camFollow.y, spr.getGraphicMidpoint().y, 0.7);
			} else {
				if (Math.abs(spr.targetY) > 1)
					spr.scale.set(0.45, 0.45);
				else
					spr.scale.set(0.58, 0.58);
				spr.updateHitbox();
			}
			spr.updateHitbox();
		});
	}
	function enableMovement() {
		selectedSomethin = false;
		FlxG.mouse.visible = false;
	}
}

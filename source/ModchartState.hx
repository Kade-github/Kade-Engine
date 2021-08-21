// this file is for modchart things, this is to declutter playstate.hx

// Lua
import LuaClass.LuaCamera;
import LuaClass.LuaReceptor;
import openfl.display3D.textures.VideoTexture;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
#if cpp
import flixel.tweens.FlxEase;
import openfl.filters.ShaderFilter;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import lime.app.Application;
import flixel.FlxSprite;
import llua.Convert;
import llua.Lua;
import llua.State;
import llua.LuaL;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;

class ModchartState 
{
	//public static var shaders:Array<LuaShader> = null;

	public static var lua:State = null;

	function callLua(func_name : String, args : Array<Dynamic>, ?type : String) : Dynamic
	{
		var result : Any = null;

		Lua.getglobal(lua, func_name);

		for( arg in args ) {
		Convert.toLua(lua, arg);
		}

		result = Lua.pcall(lua, args.length, 1, 0);
		var p = Lua.tostring(lua, result);
		var e = getLuaErrorMessage(lua);

		Lua.tostring(lua, -1);

		if (e != null)
		{
			if (e != 'attempt to call a nil value')
				trace('lua err: ' + e);
		}
		if( result == null) {
			return null;
		} else {
			return convert(result, type);
		}

	}

	static function toLua(l:State, val:Any):Bool {
		switch (Type.typeof(val)) {
			case Type.ValueType.TNull:
				Lua.pushnil(l);
			case Type.ValueType.TBool:
				Lua.pushboolean(l, val);
			case Type.ValueType.TInt:
				Lua.pushinteger(l, cast(val, Int));
			case Type.ValueType.TFloat:
				Lua.pushnumber(l, val);
			case Type.ValueType.TClass(String):
				Lua.pushstring(l, cast(val, String));
			case Type.ValueType.TClass(Array):
				Convert.arrayToLua(l, val);
			case Type.ValueType.TObject:
				objectToLua(l, val);
			default:
				trace('haxe value not supported - ' + val + ' which is a type of ' + Type.typeof(val));
				return false;
		}

		return true;

	}

	static function objectToLua(l:State, res:Any) {

		var FUCK = 0;
		for(n in Reflect.fields(res))
		{
			trace(Type.typeof(n).getName());
			FUCK++;
		}

		Lua.createtable(l, FUCK, 0); // TODONE: I did it

		for (n in Reflect.fields(res)){
			if (!Reflect.isObject(n))
				continue;
			Lua.pushstring(l, n);
			toLua(l, Reflect.field(res, n));
			Lua.settable(l, -3);
		}

	}

	function getType(l, type):Any
	{
		return switch Lua.type(l, type) {
			case t if (t == Lua.LUA_TNIL): null;
			case t if (t == Lua.LUA_TNUMBER): Lua.tonumber(l, type);
			case t if (t == Lua.LUA_TSTRING): (Lua.tostring(l, type):String);
			case t if (t == Lua.LUA_TBOOLEAN): Lua.toboolean(l, type);
			case t: throw 'you don goofed up. lua type error ($t)';
		}
	}

	function getReturnValues(l) {
		var lua_v:Int;
		var v:Any = null;
		while((lua_v = Lua.gettop(l)) != 0) {
			var type:String = getType(l, lua_v);
			v = convert(lua_v, type);
			Lua.pop(l, 1);
		}
		return v;
	}


	private function convert(v : Any, type : String) : Dynamic { // I didn't write this lol
		if( Std.is(v, String) && type != null ) {
		var v : String = v;
		if( type.substr(0, 4) == 'array' ) {
			if( type.substr(4) == 'float' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Float> = new Array();

			for( vars in array ) {
				array2.push(Std.parseFloat(vars));
			}

			return array2;
			} else if( type.substr(4) == 'int' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Int> = new Array();

			for( vars in array ) {
				array2.push(Std.parseInt(vars));
			}

			return array2;
			} else {
			var array : Array<String> = v.split(',');
			return array;
			}
		} else if( type == 'float' ) {
			return Std.parseFloat(v);
		} else if( type == 'int' ) {
			return Std.parseInt(v);
		} else if( type == 'bool' ) {
			if( v == 'true' ) {
			return true;
			} else {
			return false;
			}
		} else {
			return v;
		}
		} else {
		return v;
		}
	}

	function getLuaErrorMessage(l) {
		var v:String = Lua.tostring(l, -1);
		Lua.pop(l, 1);
		return v;
	}

	public function setVar(var_name : String, object : Dynamic){
		// trace('setting variable ' + var_name + ' to ' + object);

		Lua.pushnumber(lua, object);
		Lua.setglobal(lua, var_name);
	}

	public function getVar(var_name : String, type : String) : Dynamic {
		var result : Any = null;

		// trace('getting variable ' + var_name + ' with a type of ' + type);

		Lua.getglobal(lua, var_name);
		result = Convert.fromLua(lua, -1);
		Lua.pop(lua, 1);

		if( result == null ) {
		return null;
		} else {
		var result = convert(result, type);
		//trace(var_name + ' result: ' + result);
		return result;
		}
	}

	function getActorByName(id:String):Dynamic
	{
		// pre defined names
		switch(id)
		{
			case 'player':
                @:privateAccess
				return PlayState.player;
			case 'girlfriend':
                @:privateAccess
				return PlayState.gf;
			case 'opponent':
				@:privateAccess
				return PlayState.opponent;
		}
		// lua objects or what ever
		if (luaSprites.get(id) == null)
		{
			if (Std.parseInt(id) == null)
				return Reflect.getProperty(PlayState.instance, id);
			return PlayState.PlayState.strumLineNotes.members[Std.parseInt(id)];
		}
		return luaSprites.get(id);
	}

	function getPropertyByName(id:String)
	{
		return Reflect.field(PlayState.instance, id);
	}

	public static var luaSprites:Map<String, FlxSprite> = [];

	function changeOpponentCharacter(id:String)
	{				var oldOpponentX = PlayState.opponent.x;
					var oldOpponentY = PlayState.opponent.y;
					PlayState.instance.removeObject(PlayState.opponent);
					PlayState.opponent = new Character(oldOpponentX, oldOpponentY, id);
					PlayState.instance.addObject(PlayState.opponent);
					PlayState.instance.iconOpponent.changeIcon(id);
	}

	function changePlayerCharacter(id:String)
	{				var oldPlayerX = PlayState.player.x;
					var oldPlayerY = PlayState.player.y;
					PlayState.instance.removeObject(PlayState.player);
					PlayState.player = new Player(oldPlayerX, oldPlayerY, id);
					PlayState.instance.addObject(PlayState.player);
					PlayState.instance.iconPlayer.changeIcon(id);
	}

	function makeAnimatedLuaSprite(spritePath:String, names:Array<String>, prefixes:Array<String>, startAnim:String, id:String)
	{
		#if sys
		// pre lowercasing the song name (makeAnimatedLuaSprite)
		var songLowercase = StringTools.replace(PlayState.SONG.song, ' ', '-').toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}

		var data:BitmapData = BitmapData.fromFile(Sys.getCwd() + 'assets/data/' + songLowercase + '/' + spritePath + '.png');

		var sprite:FlxSprite = new FlxSprite(0, 0);

		sprite.frames = FlxAtlasFrames.fromSparrow(FlxGraphic.fromBitmapData(data), Sys.getCwd() + 'assets/data/' + songLowercase + '/' + spritePath + '.xml');

		trace(sprite.frames.frames.length);

		for (p in 0...names.length)
		{
			var i = names[p];
			var ii = prefixes[p];
			sprite.animation.addByPrefix(i, ii, 24, false);
		}

		luaSprites.set(id, sprite);

        PlayState.instance.addObject(sprite);

		sprite.animation.play(startAnim);
		return id;
		#end
	}

	function makeLuaSprite(spritePath:String, toBeCalled:String, drawBehind:Bool)
	{
		#if sys
		// pre lowercasing the song name (makeLuaSprite)
		var songLowercase = StringTools.replace(PlayState.SONG.song, ' ', '-').toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}


		var path = Sys.getCwd() + 'assets/data/' + songLowercase + '/';

		if (PlayState.isSM)
			path = PlayState.pathToSm + '/';

		var data:BitmapData = BitmapData.fromFile(path + spritePath + '.png');

		var sprite:FlxSprite = new FlxSprite(0, 0);
		var imgWidth:Float = FlxG.width / data.width;
		var imgHeight:Float = FlxG.height / data.height;
		var scale:Float = imgWidth <= imgHeight ? imgWidth : imgHeight;

		// Cap the scale at x1
		if (scale > 1)
			scale = 1;

		sprite.makeGraphic(Std.int(data.width * scale), Std.int(data.width * scale), FlxColor.TRANSPARENT);

		var data2:BitmapData = sprite.pixels.clone();
		var matrix:Matrix = new Matrix();
		matrix.identity();
		matrix.scale(scale, scale);
		data2.fillRect(data2.rect, FlxColor.TRANSPARENT);
		data2.draw(data, matrix, null, null, null, true);
		sprite.pixels = data2;
		
		luaSprites.set(toBeCalled, sprite);
		// and I quote:
		// shitty layering but it works!
        @:privateAccess
        {
            if (drawBehind)
            {
                PlayState.instance.removeObject(PlayState.gf);
                PlayState.instance.removeObject(PlayState.player);
                PlayState.instance.removeObject(PlayState.opponent);
            }
            PlayState.instance.addObject(sprite);
            if (drawBehind)
            {
                PlayState.instance.addObject(PlayState.gf);
                PlayState.instance.addObject(PlayState.player);
				PlayState.instance.addObject(PlayState.opponent);
            }
        }
		#end
		return toBeCalled;
	}

    public function die()
    {
        Lua.close(lua);
		lua = null;
    }

	public var luaWiggles:Map<String, WiggleEffect> = new Map<String, WiggleEffect>();

    // LUA SHIT

    function new(? isStoryMode = true)
    {
        		trace('opening a lua state (because we are cool :))');
				lua = LuaL.newstate();
				LuaL.openlibs(lua);
				trace('Lua version: ' + Lua.version());
				trace('LuaJIT version: ' + Lua.versionJIT());
				Lua.init_callbacks(lua);
				
				//shaders = new Array<LuaShader>();

				// pre lowercasing the song name (new)
				var songLowercase = StringTools.replace(PlayState.SONG.song, ' ', '-').toLowerCase();
				switch (songLowercase) {
					case 'dad-battle': songLowercase = 'dadbattle';
					case 'philly-nice': songLowercase = 'philly';
				}

				var path = Paths.lua(songLowercase + '/modchart');
				if (PlayState.isSM)
					path = PlayState.pathToSm + '/modchart.lua';

				var result = LuaL.dofile(lua, path); // execute le file
	
				if (result != 0)
				{
					Application.current.window.alert('LUA COMPILE ERROR:\n' + Lua.tostring(lua, result), 'Kade Engine Modcharts');
					FlxG.switchState(new FreeplayState());
					return;
				}

				// get some fukin globals up in here bois
	
				setVar('difficulty', PlayState.storyDifficulty);
				setVar('bpm', Conductor.bpm);
				setVar('scrollspeed', FlxG.save.data.scrollSpeed != 1 ? FlxG.save.data.scrollSpeed : PlayState.SONG.speed);
				setVar('fpsCap', FlxG.save.data.fpsCap);
				setVar('downscroll', FlxG.save.data.downscroll);
				setVar('flashing', FlxG.save.data.flashing);
				setVar('distractions', FlxG.save.data.distractions);
	
				setVar('curStep', 0);
				setVar('curBeat', 0);
				setVar('crochet', Conductor.stepCrochet);
				setVar('safeZoneOffset', Conductor.safeZoneOffset);
	
				setVar('hudZoom', PlayState.instance.camHUD.zoom);
				setVar('cameraZoom', FlxG.camera.zoom);
	
				setVar('cameraAngle', FlxG.camera.angle);
				setVar('camHudAngle', PlayState.instance.camHUD.angle);
	
				setVar('followXOffset', 0);
				setVar('followYOffset', 0);
	
				setVar('showOnlyStrums', false);
				setVar('strumLine1Visible', true);
				setVar('strumLine2Visible', true);
	
				setVar('screenWidth', FlxG.width);
				setVar('screenHeight', FlxG.height);
				setVar('windowWidth', FlxG.width);
				setVar('windowHeight', FlxG.height);
				setVar('hudWidth', PlayState.instance.camHUD.width);
				setVar('hudHeight', PlayState.instance.camHUD.height);
	
				setVar('mustHit', false);

				setVar('strumLineY', PlayState.instance.strumLine.y);
				
				// callbacks
	
				// sprites
	
				Lua_helper.add_callback(lua, 'makeSprite', makeLuaSprite);
				
				Lua_helper.add_callback(lua, 'changeOpponentCharacter', changeOpponentCharacter);

				Lua_helper.add_callback(lua, 'changePlayerCharacter', changePlayerCharacter);
	
				Lua_helper.add_callback(lua, 'getProperty', getPropertyByName);

				Lua_helper.add_callback(lua, 'setNoteWiggle', function(wiggleId) {
					PlayState.instance.camNotes.setFilters([new ShaderFilter(luaWiggles.get(wiggleId).shader)]);
				});

				Lua_helper.add_callback(lua, 'setSustainWiggle', function(wiggleId) {
					PlayState.instance.camSustains.setFilters([new ShaderFilter(luaWiggles.get(wiggleId).shader)]);
				});

				Lua_helper.add_callback(lua, 'createWiggle', function(freq:Float, amplitude:Float, speed:Float) {
					var wiggle = new WiggleEffect();
					wiggle.waveAmplitude = amplitude;
					wiggle.waveSpeed = speed;
					wiggle.waveFrequency = freq;

					var id = Lambda.count(luaWiggles) + 1 + '';

					luaWiggles.set(id, wiggle);
					return id;
				});

				Lua_helper.add_callback(lua, 'setWiggleTime', function(wiggleId:String, time:Float) {
					var wiggle = luaWiggles.get(wiggleId);

					wiggle.shader.uTime.value = [time];
				});
				
				Lua_helper.add_callback(lua, 'setWiggleAmplitude', function(wiggleId:String, amp:Float) {
					var wiggle = luaWiggles.get(wiggleId);

					wiggle.waveAmplitude = amp;
				});

				// Lua_helper.add_callback(lua, 'makeAnimatedSprite', makeAnimatedLuaSprite);
				// this one is still in development

				Lua_helper.add_callback(lua, 'destroySprite', function(id:String) {
					var sprite = luaSprites.get(id);
					if (sprite == null)
						return false;
					PlayState.instance.removeObject(sprite);
					return true;
				});
	
				// hud/camera

				Lua_helper.add_callback(lua, 'initBackgroundVideo', function(videoName:String) {
					trace('playing assets/videos/' + videoName + '.webm');
					PlayState.instance.backgroundVideo('assets/videos/' + videoName + '.webm');
				});

				Lua_helper.add_callback(lua, 'pauseVideo', function() {
					if (!GlobalVideo.get().paused)
						GlobalVideo.get().pause();
				});

				Lua_helper.add_callback(lua, 'resumeVideo', function() {
					if (GlobalVideo.get().paused)
						GlobalVideo.get().pause();
				});
				
				Lua_helper.add_callback(lua, 'restartVideo', function() {
					GlobalVideo.get().restart();
				});

				Lua_helper.add_callback(lua, 'getVideoSpriteX', function() {
					return PlayState.instance.videoSprite.x;
				});

				Lua_helper.add_callback(lua, 'getVideoSpriteY', function() {
					return PlayState.instance.videoSprite.y;
				});

				Lua_helper.add_callback(lua, 'setVideoSpritePos', function(x:Int, y:Int) {
					PlayState.instance.videoSprite.setPosition(x, y);
				});
				
				Lua_helper.add_callback(lua, 'setVideoSpriteScale', function(scale:Float) {
					PlayState.instance.videoSprite.setGraphicSize(Std.int(PlayState.instance.videoSprite.width * scale));
				});
	
				Lua_helper.add_callback(lua, 'setHudAngle', function (x:Float) {
					PlayState.instance.camHUD.angle = x;
				});
				
				Lua_helper.add_callback(lua, 'setHealth', function (heal:Float) {
					PlayState.instance.health = heal;
				});

				Lua_helper.add_callback(lua, 'setHudPosition', function (x:Int, y:Int) {
					PlayState.instance.camHUD.x = x;
					PlayState.instance.camHUD.y = y;
				});
	
				Lua_helper.add_callback(lua, 'getHudX', function () {
					return PlayState.instance.camHUD.x;
				});
	
				Lua_helper.add_callback(lua, 'getHudY', function () {
					return PlayState.instance.camHUD.y;
				});
				
				Lua_helper.add_callback(lua, 'setCamPosition', function (x:Int, y:Int) {
					FlxG.camera.x = x;
					FlxG.camera.y = y;
				});
	
				Lua_helper.add_callback(lua, 'getCameraX', function () {
					return FlxG.camera.x;
				});
	
				Lua_helper.add_callback(lua, 'getCameraY', function () {
					return FlxG.camera.y;
				});
	
				Lua_helper.add_callback(lua, 'setCamZoom', function(zoomAmount:Float) {
					FlxG.camera.zoom = zoomAmount;
				});
	
				Lua_helper.add_callback(lua, 'setHudZoom', function(zoomAmount:Float) {
					PlayState.instance.camHUD.zoom = zoomAmount;
				});
	
				// strumline

				Lua_helper.add_callback(lua, 'setStrumlineY', function(y:Float)
				{
					PlayState.instance.strumLine.y = y;
				});
	
				// actors
				
				Lua_helper.add_callback(lua, 'getNumberOfNotes', function() {
					return PlayState.instance.visibleNotes.length;
				});

				Lua_helper.add_callback(lua, 'setWindowPos', function(x:Int, y:Int) {
					Application.current.window.x = x;
					Application.current.window.y = y;
				});

				Lua_helper.add_callback(lua, 'getWindowX', function() {
					return Application.current.window.x;
				});

				Lua_helper.add_callback(lua, 'getWindowY', function() {
					return Application.current.window.y;
				});

				Lua_helper.add_callback(lua, 'resizeWindow', function(Width:Int, Height:Int) {
					Application.current.window.resize(Width, Height);
				});
				
				Lua_helper.add_callback(lua, 'getScreenWidth', function() {
					return Application.current.window.display.currentMode.width;
				});

				Lua_helper.add_callback(lua, 'getScreenHeight', function() {
					return Application.current.window.display.currentMode.height;
				});

				Lua_helper.add_callback(lua, 'getWindowWidth', function() {
					return Application.current.window.width;
				});

				Lua_helper.add_callback(lua, 'getWindowHeight', function() {
					return Application.current.window.height;
				});

				//forgot and accidentally commit to master branch
				// shader
				
				/*Lua_helper.add_callback(lua, 'createShader', function(frag:String, vert:String) {
					var shader:LuaShader = new LuaShader(frag, vert);

					trace(shader.glFragmentSource);

					shaders.push(shader);
					// if theres 1 shader we want to say theres 0 since 0 index and length returns a 1 index.
					return shaders.length == 1 ? 0 : shaders.length;
				});

				
				Lua_helper.add_callback(lua, 'setFilterHud', function(shaderIndex:Int) {
					PlayState.instance.camHUD.setFilters([new ShaderFilter(shaders[shaderIndex])]);
				});

				Lua_helper.add_callback(lua, 'setFilterCam', function(shaderIndex:Int) {
					FlxG.camera.setFilters([new ShaderFilter(shaders[shaderIndex])]);
				});*/

				// default strums

				for (i in 0...PlayState.strumLineNotes.length) {
					var member = PlayState.strumLineNotes.members[i];
					new LuaReceptor(member, 'receptor_' + i).Register(lua);
				}

				new LuaCamera(PlayState.instance.camHUD, 'camHUD').Register(lua);
				new LuaCamera(PlayState.instance.camNotes, 'camNotes').Register(lua);
				new LuaCamera(PlayState.instance.camSustains, 'camSustains').Register(lua);
    }

    public function executeState(name, args:Array<Dynamic>)
    {
        return Lua.tostring(lua, callLua(name, args));
    }

    public static function createModchartState(? isStoryMode = true):ModchartState
    {
        return new ModchartState(isStoryMode);
    }
}
#end

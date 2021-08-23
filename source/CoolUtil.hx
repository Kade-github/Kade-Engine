package;

import flixel.FlxG;
import lime.utils.Assets;
import flixel.util.FlxColor;
using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['Easy', "Normal", "Hard"];

	public static function difficultyFromInt(difficulty:Int):String
	{
		return difficultyArray[difficulty];
	}

	public static var character_colors:Map<String, Int> = [
		// hyphens are split in characterColor(), so "parents-christmas" would become "parents"
		"bf" => 0xFF0097C4,
		"gf" => 0xFFFF0000,
		"dad" => 0xFF5A07F5,
		"spooky" => 0xFFF57E07,
		"monster" => 0xFFF5DD07,
		"pico" => 0xFF52B514,
		"mom" => 0xFF5A07F5,
		"parents" => 0xFF5A07F5,
		"senpai" => 0xFFF76D6D,
		"spirit" => 0xFFAD0505,
		"player1" =>  0xFF66FF33, // Player1 and Player2 are used if healthbar colors are disabled
		"player2" => 0xFFFF0000
	];

	public static function characterColor(player:Int):FlxColor
	{
		var char:String = (player == 1 ? PlayState.SONG.player1 : PlayState.SONG.player2).toLowerCase().split('-')[0];

		if(FlxG.save.data.colour && character_colors.exists(char))
		{
			return FlxColor.fromInt(character_colors.get(char));
		}
		else
		{
			return FlxColor.fromInt(character_colors.get("player" + player));
		}
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	
	public static function coolStringFile(path:String):Array<String>
		{
			var daList:Array<String> = path.trim().split('\n');
	
			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}
	
			return daList;
		}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
}

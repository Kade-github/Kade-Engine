package flixel.system.replay;
import flixel.system.replay.CodeValuePair;
import flixel.system.replay.FlxReplay;
import flixel.system.replay.FrameRecord;
import flixel.system.replay.MouseRecord;

class CodeValuePair
{
	public var code:Int;
	public var value:FlxInputState;

	public function new(code:Int, value:FlxInputState)
	{
		this.code = code;
		this.value = value;
	}
}

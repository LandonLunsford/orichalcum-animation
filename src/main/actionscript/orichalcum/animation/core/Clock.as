package orichalcum.animation.core
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;
	
	/*
	 * Frame-based time keeping unit that keeps time in milliseconds
	 */
	public class Clock
	{
		public static const dispatcher:IEventDispatcher = new Shape;
		private static var _startTime:int;
		private static var _previousTime:int;
		private static var _currentTime:int;
		private static var _deltaTime:int;
		private static var _currentFrame:int;
		
		{
			_startTime = _currentTime = getTimer();
			dispatcher.addEventListener(Event.ENTER_FRAME, updateTime);
		}
		
		private static function updateTime(event:Event):void
		{
			_currentFrame++;
			_previousTime = _currentTime;
			_currentTime = getTimer() - _startTime;
			_deltaTime = _currentTime - previousTime;
		}
		
		public static function get startTime():int
		{
			return _startTime;
		}
		
		public static function get previousTime():int
		{
			return _previousTime;
		}
		
		public static function get currentTime():int
		{
			return _currentTime;
		}
		
		public static function get deltaTime():int
		{
			return _deltaTime;
		}
		
		public static function get startFrame():int
		{
			return 0;
		}
		
		public static function get previousFrame():int
		{
			return _currentFrame - 1;
		}
		
		public static function get currentFrame():int
		{
			return _currentFrame;
		}
		
		public static function get deltaFrame():int
		{
			return 1;
		}
		
	}

}
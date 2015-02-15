package orichalcum.animation 
{
	import flash.errors.IllegalOperationError;
	
	public class Interval implements IInterval
	{
		internal var _previousPosition:Number = 0;
		internal var _position:Number = 0;
		internal var _duration:Number = 0;
		internal var _iterations:int = 1;
		internal var _wave:Boolean;
		//internal var _delay:Number = 0;
		//internal var _postDelay:Number = 0;
		
		public function Interval() 
		{
			
		}
		
		public function position(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return _position;
			}
			const length:Number = length();
			value = Mathematics.clamp(value, 0, length);
			if (_position == value) return;
			_previousPosition = _position;
			_position = value;
			integrate();
			return this;
		}
		
		public function progress(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return length() == 0 ? 0 : _position / length();
			}
			return this.position(length() * Mathematics.clamp(value, 0, 1));
		}
		
		public function duration(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return _duration;
			}
			_duration = Math.max(0, value);
			return this;
		}
		
		public function iterations(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return _iterations;
			}
			_iterations = Math.max(1, value);
			return this;
		}
		
		public function wave(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return _wave;
			}
			_wave = value;
			return this;
		}
		
		public function length(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return _iterations * _duration;
			}
			throw new IllegalOperationError('not yet supported - requires scaling all positions including the current position');
		}
		
		//public function delay(value:* = undefined):*
		//{
			//if (arguments.length == 0)
			//{
				//return _delay;
			//}
			//_delay = value;
			//return this;
		//}
		//
		//public function postDelay(value:* = undefined):*
		//{
			//if (arguments.length == 0)
			//{
				//return _postDelay;
			//}
			//_postDelay = value;
			//return this;
		//}
		
		protected function integrate():void 
		{
			/*
				Template method
			 */
		}
		
	}

}
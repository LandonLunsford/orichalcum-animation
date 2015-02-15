package orichalcum.animation 
{
	
	public class TransformableInterval extends PlayableInterval
	{
		
		private var _timeStep:Number = 1;
		private var _frames:Boolean;
		private var _direction:Number = 1;
		
		public function timeStep(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return _timeStep;
			}
			_timeStep = value;
			return this;
		}
		
		public function frames(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return _frames;
			}
			_frames = value;
			return this;
		}
		
		public function direction(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return _direction;
			}
			_direction = value;
			return this;
		}
		
		public function reverse():*
		{
			_direction = _direction > 0 ? -1 : 1;
			return this;
		}
		
		override protected function step(deltaTime:Number):void 
		{
			position(
				_position + (
					(
						_frames
							? _timeStep
							: deltaTime * _timeStep
					)
					* _direction
				)
			);
		}
		
	}

}
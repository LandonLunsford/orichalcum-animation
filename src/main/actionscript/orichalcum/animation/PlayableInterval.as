package orichalcum.animation 
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import orichalcum.animation.core.Clock;
	
	public class PlayableInterval extends ListenableInterval
	{
		
		internal var _isPlaying:Boolean;
		internal var _positionsByLabel:Object;
		
		public function PlayableInterval()
		{
			play();
		}
		
		internal function get positionsByLabel():Object
		{
			return _positionsByLabel ||= {};
		}
		
		public function isPlaying(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return _isPlaying;
			}
			if (_isPlaying == value) return;
			_isPlaying = value;
			// the reason against doing this is play/pause will re-order the interval...
			_isPlaying ? Clock.dispatcher.addEventListener(Event.ENTER_FRAME, enterFrame)
				: Clock.dispatcher.removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function play():*
		{
			isPlaying(true);
			return this;
		}
		
		public function pause():*
		{
			isPlaying(false);
			return this;
		}
		
		public function toggle():*
		{
			return isPlaying() ? pause() : play();
		}
		
		public function replay():*
		{
			return goto(0).play();
		}
		
		public function stop():*
		{
			return goto(0).pause();
		}
		
		public function end():*
		{
			return goto(length()).pause();
		}
		
		public function goto(positionOrLabel:*):*
		{
			if (positionOrLabel is Number)
			{
				position(positionOrLabel);
			}
			else if (positionOrLabel is String)
			{
				if (!(positionOrLabel in positionsByLabel))
				{
					throw new ArgumentError('Interval has no label with name "' + positionOrLabel + '"');
				}
				position(positionsByLabel[positionOrLabel]);
			}
			else
			{
				throw new ArgumentError('Argument "positionOrLabel" must be of type number or string.');
			}
			return this;
		}
		
		override internal function integrate():void 
		{
			Integration.integrate(this, Functions.VOID);
		}
		
		private function enterFrame(event:Event):void
		{
			step(Clock.deltaTime);
		}
		
		protected function step(deltaTime:Number):void 
		{
			/*
				Template method
			 */
		}
		
	}

}
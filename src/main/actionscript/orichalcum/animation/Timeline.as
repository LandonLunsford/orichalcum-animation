package orichalcum.animation 
{
	
	public class Timeline extends TransformableInterval
	{
		
		internal var _insertionPosition:Number = 0;
		internal var _children:Array = [];
		internal var _integrator:Function;
		
		public function Timeline(...instancesAndIntervalsAndDirectives) 
		{
			_determineOptimalIntegrationStrategy();
			add.apply(this, instancesAndIntervalsAndDirectives);
		}
		
		public function add(...args):void
		{
			if (args.length == 0) return;
			
			var position:Number = args[0] is Number ? args[0] : insertionPosition;
			
			for each(var x:* in args)
			{
				if (x is IInstance)
				{
					_children.push(new TimelineEntry(position, x));
				}
				else if (x is IInterval)
				{
					_children.push(new TimelineEntry(position, x));
					insertionPosition = Math.max(insertionPosition, position + x.length());
				}
				else if (x is IDirective)
				{
					(x as IDirective).apply(this);
				}
				else if ('length' in x)
				{
					add.apply(this, x);
				}
			} 
		}
		
		internal function get insertionPosition():Number
		{
			return _insertionPosition;
		}
		
		internal function set insertionPosition(value:Number):void
		{
			value = Math.max(0, (isNaN(value) ? 0 : value));
			if (_insertionPosition == value) return;
			_insertionPosition = value;
			if (_insertionPosition > _duration)
			{
				_duration = _insertionPosition;
			}
		}
		
		override public function iterations(value:* = undefined):*
		{
			const result:* = super.iterations.apply(this, arguments);
			if (arguments.length != 0)
			{
				_determineOptimalIntegrationStrategy();
			}
			return result;
		}
		
		override public function wave(value:* = undefined):*
		{
			const result:* = super.wave.apply(this, arguments);
			if (arguments.length != 0)
			{
				_determineOptimalIntegrationStrategy();
			}
			return result;
		}
		
		private function _determineOptimalIntegrationStrategy():void
		{
			_integrator = _iterations > 1
				? _wave ? Integration.timeline_multiIteration_wave
					: Integration.timeline_multiIteration_waveless
				: _wave ? Integration.timeline_signleIteration_wave
					: Integration.timeline_signleIteration_waveless;
		}
		
		override protected function integrate():void
		{
			_integrator(this);
		}
		
	}

}
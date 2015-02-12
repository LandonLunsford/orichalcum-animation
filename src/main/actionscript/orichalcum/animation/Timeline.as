package orichalcum.animation 
{
	import flash.errors.IllegalOperationError;
	
	public class Timeline implements IInterval
	{
		
		internal var _insertionPosition:Number = 0;
		internal var _previousPosition:Number = 0;
		internal var _position:Number = 0;
		internal var _duration:Number = 0;
		internal var _iterations:int = 1;
		internal var _wave:Boolean;
		internal var _children:Array = [];
		internal var _integrator:Function;
		
		public function Timeline(...instancesAndIntervalsAndDirectives) 
		{
			_updateIntegrator();
			add.apply(this, instancesAndIntervalsAndDirectives);
		}
		
		public function add(...instancesAndIntervalsAndDirectives):void
		{
			for each(var x:* in instancesAndIntervalsAndDirectives)
			{
				if (x is IInstance)
				{
					//trace('add IInstance', x);
					_children.push(new TimelineEntry(insertionPosition, x));
				}
				else if (x is IInterval)
				{
					//trace('add IInterval', x);
					_children.push(new TimelineEntry(insertionPosition, x));
				}
				else if (x is IDirective)
				{
					//trace('add IDirective', x);
					(x as IDirective).apply(this);
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
		
		public function position(value:* = null):*
		{
			if (value == null)
			{
				return _position;
			}
			
			/*
				Compute length once
			 */
			const length:Number = length();
			
			/*
				Put value into a valid state
			 */
			value = Mathematics.clamp(Number(value), 0, length);
			
			/*
				Do nothing if the position has not changed
			 */
			if (_position == value) return;
			
			/*
				Oddity of callback integration algorithms
				Effectively widens the integration span to enclude polar coordinates.
			 */
			//_previousPosition = _position == 0
				//? -Mathematics.EPSILON
				//: _position == length
					//? length + Mathematics.EPSILON
					//: _position;
			
			/*
				Update current position & previous position state
			 */
			_previousPosition = _position;
			_position = value;
			
			// guarantee
			//_previousPosition = Math.floor(_previousPosition);
			//_position = Math.floor(_position);
			
			/*
				Perform integration over the timeline
				This includes invoking instances and positioning intervals
			 */
			_integrator(this);
			
			return this;
		}
		
		public function progress(value:* = null):*
		{
			if (value == null)
			{
				return length() == 0 ? 0 : _position / length();
			}
			//trace('set p', Mathematics.clamp(Number(value), 0, 1), length());
			return this.position(length() * Mathematics.clamp(Number(value), 0, 1));
		}
		
		public function duration(value:* = null):*
		{
			if (value == null)
			{
				return _duration;
			}
			_duration = Math.max(0, Number(value));
			return this;
		}
		
		public function iterations(value:* = null):*
		{
			if (value == null)
			{
				return _iterations;
			}
			_iterations = Math.max(1, int(value));
			_updateIntegrator();
			return this;
		}
		
		public function wave(value:* = null):*
		{
			if (value == null)
			{
				return _wave;
			}
			_wave = Boolean(value);
			_updateIntegrator();
			return this;
		}
		
		public function length(value:* = null):*
		{
			if (value == null)
			{
				return _iterations * _duration;
			}
			
			throw new IllegalOperationError('not yet supported - requires scaling all positions including the current position');
		}
		
		private function _updateIntegrator():void
		{
			//_integrator = _iterations > 1
				//? _wave
					//? Integrators.multiIterationWaveIntegrator
					//: Integrators.multiIterationWavelessIntegrator
				//: _wave
					//? Integrators.oneIterationWaveIntegrator
					//: Integrators.oneIterationWavelessIntegrator;
					_integrator = Integrators.multiIterationWaveIntegrator;
		}
		
		public function dump():String
		{
			return '[Timeline]{position: ' + _position
				+ ', previousPosition: ' + _previousPosition
				+ '}';
		}
		
	}

}
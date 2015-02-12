package orichalcum.animation 
{
	
	internal class Integrators 
	{
		
		
		public static function oneIterationWavelessIntegrator(interval:Object):void
		{
			var currentPosition:Number = interval._position;
			var previousPosition:Number = interval._previousPosition;
			var iterationDuration:Number = interval._duration;
			var children:Array = interval._children;
			
			var deltaPosition:Number = currentPosition - previousPosition;
			var forward:Boolean = deltaPosition > 0;
			
			_integrate(children, iterationDuration, previousPosition, currentPosition, forward);
		}
		
		public static function oneIterationWaveIntegrator(interval:Object):void
		{
			multiIterationWaveIntegrator(interval);
		}
		
		public static function multiIterationWavelessIntegrator(interval:Object):void
		{
			var currentPosition:Number = interval._position;
			var previousPosition:Number = interval._previousPosition;
			var children:Array = interval._children;
			var iterationDuration:Number = interval._duration;
			
			var deltaPosition:Number = currentPosition - previousPosition;
			var forward:Boolean = deltaPosition > 0;
			var currentSpan:int = currentPosition / iterationDuration;
			var previousSpan:int = previousPosition / iterationDuration;
			var deltaSpan:int = currentSpan - previousSpan;
			var spanStep:int = deltaPosition > 0 ? 1 : -1;
			
			for (var j:int = previousSpan, jf:int = currentSpan + spanStep; j != jf; j += spanStep)
			{
				var projectedCurrentPosition:Number = currentPosition - iterationDuration * j;
				var projectedPreviousPosition:Number = previousPosition - iterationDuration * j;
				
				_integrate(children, iterationDuration, projectedPreviousPosition, projectedCurrentPosition, forward);
			}
		
		}
		
		/*
			Fails on jumps - loop setup issue da to omou
			i1_wT fails & i2 fails
			
			COMPLETE algorithm
			This function (SHOULD) satisfy all cases (but is also the most complex)
		 */
		public static function multiIterationWaveIntegrator(interval:Object):void
		{
			var currentPosition:Number = interval._position;
			var previousPosition:Number = interval._previousPosition;
			var children:Array = interval._children;
			var wave:Boolean = interval._wave;
			var iterationDuration:Number = interval._duration;
			
			var deltaPosition:Number = currentPosition - previousPosition;
			var scaledIterationDuration:Number = wave ? iterationDuration * 0.5 : iterationDuration;
			var maybeForward:Boolean = deltaPosition > 0;
			var currentSpan:int = currentPosition / scaledIterationDuration;
			var previousSpan:int = previousPosition / scaledIterationDuration;
			var deltaSpan:int = currentSpan - previousSpan;
			var spanStep:int = deltaPosition > 0 ? 1 : -1;
			
			for (var j:int = previousSpan, jf:int = currentSpan + spanStep; j != jf; j += spanStep)
			{
				var reversed:Boolean = wave && ((j & 1) == 1);
				var forward:Boolean = maybeForward ? !reversed : reversed;
				var projectedCurrentPosition:Number = currentPosition - scaledIterationDuration * j;
				var projectedPreviousPosition:Number = previousPosition - scaledIterationDuration * j;
				if (reversed)
				{
					projectedCurrentPosition = scaledIterationDuration - projectedCurrentPosition;
					projectedPreviousPosition = scaledIterationDuration - projectedPreviousPosition;
				}
				if (wave)
				{
					projectedCurrentPosition *= 2;
					projectedPreviousPosition *= 2;
				}
				
				_integrate(children, iterationDuration, projectedPreviousPosition, projectedCurrentPosition, forward);
			}
		}
		
		/**
		 * 
		 * @param	instancesOrIntervals
		 * @param	iterationDuration
		 * @param	previousPosition
		 * @param	currentPosition
		 * @param	forward
		 */
		private static function _integrate_unoptimized(
			instancesOrIntervals:Array,
			iterationDuration:Number,
			previousPosition:Number,
			currentPosition:Number,
			forward:Boolean):void {
				
			var i:int, a:int, b:int, d:int,
				l:Number, r:Number, x:TimelineEntry, p:Number;
			
			if (forward)
			{
				a = 0;
				b = instancesOrIntervals.length;
				d = 1;
				r = currentPosition;
				l = previousPosition;
			}
			else
			{
				a = instancesOrIntervals.length - 1;
				b = -1;
				d = -1;
				r = previousPosition;
				l = currentPosition;
			}
			
			/*
				Execute the instance if it is within the elapse time range
				or if it is the initial interpolation and it is at the start
			 */
			for (i = a; i != b; i += d)
			{
				x = instancesOrIntervals[i];
				p = x.position;
				
				// the equals check is not efficient because it is not likely...
				// however it is the only way to have this loop work both ways b/c the leading position
				// must always be the inclusive side of the range
				if (x.instance
				&& (
					// requires previousPosition corrections on position set
					//(xPosition > l && xPosition < r)
					//|| xPosition == currentPosition
					
					// allows previousPosition to = 0 & final position
					// this is more intuitive - not sure if it is performant though
					(p > l && p < r)
					||
					(forward
						?
						(
							(p == 0 && p == previousPosition)
							||
							(p != 0 && p == currentPosition)
						)
						:
						(
							(p == iterationDuration && p == previousPosition)
							|| 
							(p != iterationDuration && p == currentPosition)
						)
					)
				))
				{
					x.instance.invoke( forward );
				}
				else if (x.interval)
				{
					var relativePosition:Number = Mathematics.clamp(currentPosition - p, 0, x.interval.length());
					x.interval.position( relativePosition ); // does some redundant processing probably
				}
			}
		}
		
		private static function _integrate(
			instancesOrIntervals:Array,
			iterationDuration:Number,
			previousPosition:Number,
			currentPosition:Number,
			forward:Boolean):void {
				
			var i:int, b:int, x:TimelineEntry, p:Number, relativePosition:Number;
			
			if (forward)
			{
				b = instancesOrIntervals.length;
				for (i = 0; i != b; i += 1)
				{
					x = instancesOrIntervals[i];
					p = x.position;

					if (x.instance
					&& (
						(p > previousPosition && p < currentPosition) || ((p == 0 && p == previousPosition) || (p != 0 && p == currentPosition))
					))
					{
						//x.instance.forward();
						x.instance.invoke( forward );
					}
					else if (x.interval)
					{
						relativePosition = Mathematics.clamp(currentPosition - p, 0, x.interval.length());
						x.interval.position( relativePosition );
					}
				}
			}
			else
			{
				for (i = instancesOrIntervals.length - 1; i != -1; i -= 1)
				{
					x = instancesOrIntervals[i];
					p = x.position;

					if (x.instance
					&& (
						(p > currentPosition && p < previousPosition) || ((p == iterationDuration && p == previousPosition) || (p != iterationDuration && p == currentPosition))
					))
					{
						//x.instance.backward();
						x.instance.invoke( forward );
					}
					else if (x.interval)
					{
						relativePosition = Mathematics.clamp(currentPosition - p, 0, x.interval.length());
						x.interval.position( relativePosition );
					}
				}
			}
			
			/*
				Execute the instance if it is within the elapse time range
				or if it is the initial interpolation and it is at the start
			 */
			
		}
		
	}

}
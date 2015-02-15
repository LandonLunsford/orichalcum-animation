package orichalcum.animation 
{
	import flash.utils.Dictionary;
	
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
					forward
						? x.instance.forward()
						: x.instance.backward();
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
						x.instance.forward();
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
						x.instance.backward();
					}
					else if (x.interval)
					{
						relativePosition = Mathematics.clamp(currentPosition - p, 0, x.interval.length());
						x.interval.position( relativePosition );
					}
				}
			}
		}
		
		/*
			Stable v1
			Deficiencies:
			1. no delay/repeatDelay/postDelay
			2. repeat/reverse callbacks will not be able to read the position of the tween at the time of the callback.
		 */
		public static function tweenIntegrator(tween:Tween):void
		{
			tween.initialize();
			
			var currentPosition:Number = tween._position;
			var previousPosition:Number = tween._previousPosition;
			var wave:Boolean = tween._wave;
			var iterationDuration:Number = tween._duration;
			var length:Number = tween.length();
			
			var deltaPosition:Number = currentPosition - previousPosition;
			var scaledIterationDuration:Number = wave ? iterationDuration * 0.5 : iterationDuration;
			var forward:Boolean = deltaPosition > 0;
			var currentSpan:int = currentPosition / scaledIterationDuration;
			var previousSpan:int = previousPosition / scaledIterationDuration;
			var projectedCurrentPosition:Number = currentPosition - scaledIterationDuration * currentSpan;
			var projectedPreviousPosition:Number = previousPosition - scaledIterationDuration * currentSpan;
			var deltaSpan:int = currentSpan - previousSpan;
			var spanStep:int = deltaPosition > 0 ? 1 : -1;
			var reversed:Boolean = wave && ((currentSpan & 1) == 1);
			var ratio:Number;
			var completed:Boolean;
			
			if (forward)
			{
				completed = currentPosition == length;
				if (completed)
				{
					ratio = wave ? 0 : 1;
				}
				else if (currentPosition == 0)
				{
					ratio = 0;
				}
				else if (scaledIterationDuration == 0) // duration here = duration+delay
				{
					ratio = 1;
				}
				else
				{
					ratio = tween._ease( projectedCurrentPosition / scaledIterationDuration );
					if (reversed)
					{
						ratio = 1 - ratio;
					}
				}
				
				if (previousPosition == 0)
				{
					tween._started.forward();
				}
				tween._changing.forward();
				integrateProperties(tween, ratio, completed);
				completed || integrateRepeatsAndReversals(
					tween, currentSpan, deltaSpan, wave, tween._repeated.forward, tween._reversed.forward);
				tween._changed.forward();
				if (currentPosition == length)
				{
					tween._completed.forward();
					//tween.pause();
				}
			}
			else
			{
				completed = currentPosition == 0;
				if (completed)
				{
					ratio = 0; // diff w/ forward
				}
				else if (currentPosition == 0)
				{
					ratio = 0;
				}
				else if (scaledIterationDuration == 0) // duration here = duration+delay
				{
					ratio = 1;
				}
				else
				{
					ratio = tween._ease( projectedCurrentPosition / scaledIterationDuration );
					if (reversed)
					{
						ratio = 1 - ratio;
					}
				}
				
				if (previousPosition == length)
				{
					tween._completed.backward();
				}
				tween._changing.backward();
				integrateProperties(tween, ratio, completed);
				completed || integrateRepeatsAndReversals(
					tween, currentSpan, -deltaSpan, wave, tween._repeated.backward, tween._reversed.backward);
				tween._changed.backward();
				if (completed)
				{
					tween._started.backward();
					//tween.pause();
				}
			}
		}
		
		static private function integrateProperties(tween:Tween, ratio:Number, completed:Boolean):void 
		{
			var a:*, b:*,
				value:*,
				valueCandidate:*,
				plugin:IPlugin,
				property:String,
				plugins:Array,
				isNumber:Boolean,
				target:Object = tween._target,
				to:Object = tween._to,
				from:Object = tween._from,
				pluginsByProperty:Dictionary = tween._pluginsByProperty;
			
			for (property in to)
			{
				a = from[property];
				b = to[property];
				isNumber = typeof(a) === 'number';
				
				if (a == b || ratio == 0 || ratio == 1 || !isNumber)
				{
					value = ratio == 1 ? b : a;
				}
				else if (isNumber)
				{
					value = a + (b - a) * ratio;
				}
				for each(plugin in pluginsByProperty[property])
				{
					valueCandidate = plugin.tween(tween, property, value, a, b, ratio, completed);
					
					if (valueCandidate !== undefined)
					{
						value = valueCandidate;
					}
				}
				if (value !== undefined)
				{
					target[property] = value;
				}
			}
		}
		
		private static function integrateRepeatsAndReversals(
			tween:Tween, currentSpan:int, deltaSpan:int, wave:Boolean, repeated:Function, reversed:Function):void
		{
			var x:int = deltaSpan, a:Number = tween._position;
			if (wave)
			{
				while (x > 0)
				{
					((currentSpan + x) & 1) == 1
						? repeated()
						: reversed();
					x--;
				}
			}
			else
			{
				while (x > 0)
				{
					repeated();
					x--;
				}
			}
		}
		
	}

}
package orichalcum.animation 
{
	import flash.utils.Dictionary;
	import orichalcum.animation.plugin.IPlugin;
	
	/**
	 * Interval Integration
	 * 
	 */
	public class Integration2 
	{
		
		public static function integrate(interval:PlayableInterval, integrator:Function):void
		{
			const currentPosition:Number = interval._position,
				previousPosition:Number = interval._previousPosition,
				forward:Boolean = currentPosition - previousPosition > 0,
				length:Number = interval.length();
				
			var completed:Boolean;
			
			if (forward)
			{
				completed = currentPosition == length;
				previousPosition == 0 && interval._started && interval._started.forward();
				interval._changing && interval._changing.forward();
				integrator(
					interval,
					forward,
					completed,
					length, 
					interval._repeated ? interval._repeated.forward : null,
					interval._reversed ? interval._reversed.forward : null
				);
				interval._changed && interval._changed.forward();
				if (completed)
				{
					interval.pause();
					interval._completed && interval._completed.forward();
				}
			}
			else
			{
				completed = currentPosition == 0;
				previousPosition == length && interval._completed && interval._completed.backward();
				interval._changing && interval._changing.backward();
				integrator(
					interval,
					forward,
					completed,
					length, 
					interval._repeated ? interval._repeated.backward : null,
					interval._reversed ? interval._reversed.backward : null
				);
				interval._changed && interval._changed.backward();
				if (completed)
				{
					interval.pause();
					interval._started && interval._started.backward();
				}
			}
		}
		
		public static function timelineIntegration(interval:Timeline, forward:Boolean, completed:Boolean, length:Number, repeated:Function, reversed:Function):void
		{
			// keep variables close
			const currentPosition:Number = interval._position;
			const previousPosition:Number = interval._previousPosition;
			const iterationDuration:Number = interval._duration;
			const wave:Boolean = interval._wave;
			const scaledIterationDuration:Number = wave ? iterationDuration * 0.5 : iterationDuration;
			
			// loop setup
			const currentSpan:int = currentPosition / scaledIterationDuration;
			const previousSpan:int = previousPosition / scaledIterationDuration;
			const deltaSpan:int = currentSpan - previousSpan;
			const spanStep:int = currentPosition - previousPosition > 0 ? 1 : -1;
			const totalSpans:int = int(wave ? (length * 2) / iterationDuration : length / iterationDuration);
			
			for (var j:int = previousSpan, jf:int = currentSpan + spanStep; j != jf; j += spanStep)
			{
				var reverseSpan:Boolean = wave && ((j & 1) == 1);
				var forward2:Boolean = forward ? !reverseSpan : reverseSpan;
				var projectedCurrentPosition:Number = currentPosition - scaledIterationDuration * j;
				var projectedPreviousPosition:Number = previousPosition - scaledIterationDuration * j;
				if (reverseSpan)
				{
					projectedCurrentPosition = scaledIterationDuration - projectedCurrentPosition;
					projectedPreviousPosition = scaledIterationDuration - projectedPreviousPosition;
				}
				if (wave)
				{
					projectedCurrentPosition *= 2;
					projectedPreviousPosition *= 2;
				}
				
				var i:int, b:int, x:TimelineEntry, p:Number, instancesOrIntervals:Array = interval._children;
				if (forward2)
				{
					b = instancesOrIntervals.length;
					for (i = 0; i != b; i += 1)
					{
						x = instancesOrIntervals[i];
						p = x.position;

						if (x.instance
						&& (
							(p > projectedPreviousPosition && p < projectedCurrentPosition)
							||
							(
								(p == 0 && p == projectedPreviousPosition)
								||
								(p != 0 && p == projectedCurrentPosition)
							)
						))
						{
							x.instance.forward();
						}
						else if (x.interval)
						{
							x.interval.position(projectedCurrentPosition - p);
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
							(p > projectedCurrentPosition && p < projectedPreviousPosition)
							||
							(
								(p == iterationDuration && p == projectedPreviousPosition)
								||
								(p != iterationDuration && p == projectedCurrentPosition)
							)
						))
						{
							x.instance.backward();
						}
						else if (x.interval)
						{
							x.interval.position(projectedCurrentPosition - p);
						}
					}
				}
				
				// wackness - bad loop setup?
				const ignoreRepeatsAndReverses:Boolean = forward
					? j == currentSpan || j + spanStep == totalSpans
					: j == currentSpan || j == totalSpans;
				if (ignoreRepeatsAndReverses) continue;
				
				
				if (wave && forward2)
				{
					reversed && reversed();
				}
				else
				{
					repeated && repeated();
				}
			}
		}
		
		public static function tweenIntegration(tween:Tween, forward:Boolean, completed:Boolean, length:Number, repeated:Function, reversed:Function):void
		{
			// keep variables close
			const currentPosition:Number = tween._position;
			const previousPosition:Number = tween._previousPosition;
			const iterationDuration:Number = tween._duration;
			const wave:Boolean = tween._wave;
			const scaledIterationDuration:Number = wave ? iterationDuration * 0.5 : iterationDuration;
			
			const currentSpan:int = currentPosition / scaledIterationDuration;
			const previousSpan:int = previousPosition / scaledIterationDuration;
			const projectedCurrentPosition:Number = currentPosition - scaledIterationDuration * currentSpan;
			const reverseSpan:Boolean = wave && ((currentSpan & 1) == 1);
			
			// fw bw is different
			var ratio:Number;
			if (completed)
			{
				ratio = forward
					? wave ? 0 : 1
					: 0;
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
				ratio = tween._ease(projectedCurrentPosition / scaledIterationDuration);
				if (reverseSpan)
				{
					ratio = 1 - ratio;
				}
			}
			
			tween.initialize();
			
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
			
			if (!completed)
			{
				var x:int = currentSpan - previousSpan;
				if (tween._wave)
				{
					while (x > 0)
					{
						if (((currentSpan + x) & 1) == 1)
						{
							repeated && repeated();
						}
						else
						{
							reversed && reversed();
						}
						x--;
					}
				}
				else
				{
					while (x > 0)
					{
						repeated && repeated();
						x--;
					}
				}
			}
		}
		
	}

}
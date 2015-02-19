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
			var currentPosition:Number = interval._position,
				previousPosition:Number = interval._previousPosition,
				forward:Boolean = currentPosition - previousPosition > 0,
				length:Number = interval.length(),
				completed:Boolean;
			
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
		
		public static function timelineIntegration(timeline:Timeline, forward:Boolean, completed:Boolean, length:Number, repeated:Function, reversed:Function):void
		{
			// keep variables close
			const currentPosition:Number = timeline._position;
			const previousPosition:Number = timeline._previousPosition;
			const iterationDuration:Number = timeline._duration;
			const instancesOrIntervals:Array = timeline._children;
			const wave:Boolean = timeline._wave;
			const scaledIterationDuration:Number = wave ? iterationDuration * 0.5 : iterationDuration;
			
			// loop setup
			const currentSpan:int = currentPosition / scaledIterationDuration >> 0;
			const previousSpan:int = previousPosition / scaledIterationDuration >> 0;
			const spanStep:int = forward ? 1 : -1;
			const totalSpans:int = int(wave ? (length * 2) / iterationDuration : length / iterationDuration);
			
			var i:int,
				iE:int,
				child:TimelineEntry,
				childInterval:Interval,
				p:Number,
				projectedCurrentPosition:Number,
				projectedPreviousPosition:Number,
				reverseSpan:Boolean,
				forward2:Boolean;
			
			for (var j:int = previousSpan, jf:int = currentSpan + spanStep; j != jf; j += spanStep)
			{
				projectedCurrentPosition = currentPosition - scaledIterationDuration * j;
				projectedPreviousPosition = previousPosition - scaledIterationDuration * j;
				if (wave)
				{
					reverseSpan = ((j & 1) == 1);
					if (reverseSpan)
					{
						projectedCurrentPosition = scaledIterationDuration - projectedCurrentPosition;
						projectedPreviousPosition = scaledIterationDuration - projectedPreviousPosition;
					}
					projectedCurrentPosition *= 2;
					projectedPreviousPosition *= 2;
					forward2 = forward ? !reverseSpan : reverseSpan;
				}
				else
				{
					forward2 = forward;
				}
				
				if (forward2)
				{
					iE = instancesOrIntervals.length;
					for (i = 0; i != iE; i += 1)
					{
						child = instancesOrIntervals[i];
						p = child.position;

						if (child.instance
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
							child.instance.forward();
						}
						else if (child.interval)
						{
							// need previous position access
							childInterval = child.interval;
							childInterval._previousPosition = Mathematics.clamp(projectedPreviousPosition - p, 0, child.interval.length());
							childInterval._position = Mathematics.clamp(projectedCurrentPosition - p, 0, child.interval.length());
							childInterval._position != childInterval._previousPosition && childInterval.integrate();
						}
					}
				}
				else
				{
					for (i = instancesOrIntervals.length - 1; i != -1; i -= 1)
					{
						child = instancesOrIntervals[i];
						p = child.position;

						if (child.instance
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
							child.instance.backward();
						}
						else if (child.interval)
						{
							childInterval = child.interval;
							childInterval._previousPosition = Mathematics.clamp(projectedPreviousPosition - p, 0, child.interval.length());
							childInterval._position = Mathematics.clamp(projectedCurrentPosition - p, 0, child.interval.length());
							childInterval._position != childInterval._previousPosition && childInterval.integrate();
						}
					}
				}
				
				// bad loop setup?
				if (forward
				? j == currentSpan || j + spanStep == totalSpans
				: j == currentSpan || j == totalSpans)
					continue;
				
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
				pluginsByProperty:Dictionary = Tween.plugins.pluginsByProperty;
			
			for (property in to)
			{
				a = from[property];
				b = to[property];
				
				// must go first
				if (typeof(a) !== 'number')
				{
					value = ratio == 1 ? b : a;
				}
				else if (a == b || ratio == 0)
				{
					value = a;
				}
				else if (ratio == 1)
				{
					value = b;
				}
				else 
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
			
			if (completed) return;
			
			// TODO i suspect this loop to always go forward & not backward in iteration order...
			var x:int = Math.abs(currentSpan - previousSpan);
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
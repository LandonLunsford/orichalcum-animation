package orichalcum.animation 
{
	import flash.utils.Dictionary;
	import orichalcum.animation.plugin.IPlugin;
	
	internal class Integration 
	{
		/*
		internal static function v1_timeline_signleIteration_waveless(interval:Timeline):void
		{
			var currentPosition:Number = interval._position;
			var previousPosition:Number = interval._previousPosition;
			var iterationDuration:Number = interval._duration;
			var children:Array = interval._children;
			
			var deltaPosition:Number = currentPosition - previousPosition;
			var forward:Boolean = deltaPosition > 0;
			
			_integrate(children, iterationDuration, previousPosition, currentPosition, forward);
		}
		
		internal static function v1_timeline_signleIteration_wave(interval:Timeline):void
		{
			timeline_multiIteration_wave(interval);
		}
		
		internal static function v1_timeline_multiIteration_waveless(interval:Timeline):void
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
		
		internal static function v1_timeline_multiIteration_wave(timeline:Timeline):void
		{
			var currentPosition:Number = timeline._position;
			var previousPosition:Number = timeline._previousPosition;
			var children:Array = timeline._children;
			var wave:Boolean = timeline._wave;
			var iterationDuration:Number = timeline._duration;
			var length:Number = timeline.length();
			
			var deltaPosition:Number = currentPosition - previousPosition;
			var scaledIterationDuration:Number = wave ? iterationDuration * 0.5 : iterationDuration;
			var forward:Boolean = deltaPosition > 0;
			var currentSpan:int = currentPosition / scaledIterationDuration;
			var previousSpan:int = previousPosition / scaledIterationDuration;
			var deltaSpan:int = currentSpan - previousSpan;
			var spanStep:int = deltaPosition > 0 ? 1 : -1;
			
			//new
			if (forward)
			{
				previousPosition == 0 && timeline._started && timeline._started.forward();
				timeline._changing && timeline._changing.forward();
			}
			else
			{
				previousPosition == length && timeline._completed && timeline._completed.backward();
				timeline._changing && timeline._changing.forward();
			}
			
			for (var j:int = previousSpan, jf:int = currentSpan + spanStep; j != jf; j += spanStep)
			{
				// too much dont need this -- sub tweens already know this stuff.
				var reversed:Boolean = wave && ((j & 1) == 1);
				var forward2:Boolean = forward ? !reversed : reversed;
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
				
				_integrate(children, iterationDuration, projectedPreviousPosition, projectedCurrentPosition, forward2);
			}
			
			//new
			if (forward)
			{
				timeline._changing && timeline._changed.forward();
				currentPosition == length && timeline._completed && timeline._completed.forward();
				
			}
			else
			{
				timeline._changing && timeline._changed.backward();
				currentPosition == 0 && timeline._started && timeline._started.backward();
			}
		}
		*/
		
		
		internal static function tween_signleIteration_waveless(tween:Tween):void
		{
			tween_multiIteration_wave(tween);
		}
		
		internal static function tween_signleIteration_wave(tween:Tween):void
		{
			tween_multiIteration_wave(tween);
		}
		
		internal static function tween_multiIteration_waveless(tween:Tween):void
		{
			tween_multiIteration_wave(tween);
		}
		
		internal static function tween_multiIteration_wave(tween:Tween):void
		{
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
				
				previousPosition == 0 && tween._started && tween._started.forward();
				tween._changing && tween._changing.forward();
				
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
				
				tweenProperties(tween, ratio, completed);
				completed || tweenRepeatsAndReversals(
					tween,
					currentSpan,
					deltaSpan,
					tween._repeated ? tween._repeated.forward : null,
					tween._reversed ? tween._reversed.forward : null);
					
					
				tween._changed && tween._changed.forward();
				if (currentPosition == length)
				{
					tween._completed && tween._completed.forward();
					tween.pause();
				}
			}
			else
			{
				
				previousPosition == length && tween._completed && tween._completed.backward();
				tween._changing && tween._changing.backward();
				
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
				tweenProperties(tween, ratio, completed);
				completed || tweenRepeatsAndReversals(
					tween,
					currentSpan,
					-deltaSpan,
					tween._repeated ? tween._repeated.backward : null,
					tween._reversed ? tween._reversed.backward : null);
					
				tween._changed && tween._changed.backward();
				if (completed)
				{
					tween._started && tween._started.backward();
					tween.pause();
				}
			}
		}
		
		static private function tweenProperties(tween:Tween, ratio:Number, completed:Boolean):void 
		{
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
		}
		
		private static function tweenRepeatsAndReversals(
			tween:Tween,
			currentSpan:int,
			deltaSpan:int,
			repeated:Function,
			reversed:Function):void
		{
			var x:int = deltaSpan, a:Number = tween._position;
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
		
		internal static function timeline_signleIteration_waveless(timeline:Timeline):void
		{
			timeline_multiIteration_wave(timeline);
		}
		
		internal static function timeline_signleIteration_wave(timeline:Timeline):void
		{
			timeline_multiIteration_wave(timeline);
		}
		
		internal static function timeline_multiIteration_waveless(timeline:Timeline):void
		{
			timeline_multiIteration_wave(timeline);
		}
		
		internal static function timeline_multiIteration_wave(timeline:Timeline):void
		{
			var currentPosition:Number = timeline._position;
			var previousPosition:Number = timeline._previousPosition;
			var wave:Boolean = timeline._wave;
			var iterationDuration:Number = timeline._duration;
			var length:Number = timeline.length();
			var children:Array = timeline._children;
			
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
			var completed:Boolean;
			
			var i:int, b:int, x:TimelineEntry, p:Number, relativePosition:Number, c3:Number, p3:Number;
			
			var totalSpans:int = int(wave ? (length * 2) / iterationDuration : length / iterationDuration);
			
			if (forward)
			{
				completed = currentPosition == length;
				
				previousPosition == 0 && timeline._started && timeline._started.forward();
				timeline._changing && timeline._changing.forward();
				
				for (var j:int = previousSpan, jf:int = currentSpan + spanStep; j != jf; j += spanStep)
				{
					// too much dont need this -- sub tweens already know this stuff.
					var reversed2:Boolean = wave && ((j & 1) == 1);
					var forward2:Boolean = forward ? !reversed2 : reversed2;
					var projectedCurrentPosition2:Number = currentPosition - scaledIterationDuration * j;
					var projectedPreviousPosition2:Number = previousPosition - scaledIterationDuration * j;
					if (reversed2)
					{
						projectedCurrentPosition2 = scaledIterationDuration - projectedCurrentPosition2;
						projectedPreviousPosition2 = scaledIterationDuration - projectedPreviousPosition2;
					}
					if (wave)
					{
						projectedCurrentPosition2 *= 2;
						projectedPreviousPosition2 *= 2;
					}
					timeline_integrateChildren(children, iterationDuration, projectedPreviousPosition2, projectedCurrentPosition2, forward2);
					
					if (j == currentSpan || j + spanStep == totalSpans)
						continue;
					
					if (wave)
					{
						if (reversed2)
						{
							timeline._repeated && timeline._repeated.forward();
						}
						else
						{
							timeline._reversed && timeline._reversed.forward();
						}
					}
					else
					{
						timeline._repeated && timeline._repeated.forward();
					}
				}
					
				timeline._changed && timeline._changed.forward();
				if (completed)
				{
					timeline._completed && timeline._completed.forward();
					timeline.pause();
				}
			}
			else
			{
				completed = currentPosition == 0;
				previousPosition == length && timeline._completed && timeline._completed.backward();
				timeline._changing && timeline._changing.backward();
				
				for (var j:int = previousSpan, jf:int = currentSpan + spanStep; j != jf; j += spanStep)
				{
					var reversed2:Boolean = wave && ((j & 1) == 1);
					var forward2:Boolean = forward ? !reversed2 : reversed2;
					var projectedCurrentPosition2:Number = currentPosition - scaledIterationDuration * j;
					var projectedPreviousPosition2:Number = previousPosition - scaledIterationDuration * j;
					if (reversed2)
					{
						projectedCurrentPosition2 = scaledIterationDuration - projectedCurrentPosition2;
						projectedPreviousPosition2 = scaledIterationDuration - projectedPreviousPosition2;
					}
					if (wave)
					{
						projectedCurrentPosition2 *= 2;
						projectedPreviousPosition2 *= 2;
					}
					timeline_integrateChildren(children, iterationDuration, projectedPreviousPosition2, projectedCurrentPosition2, forward2);
					
					if (j == currentSpan || j == totalSpans)
						continue;
					
					if (wave)
					{
						if (!reversed2) // why does this have to be negated...
						{
							timeline._repeated && timeline._repeated.backward();
						}
						else
						{
							timeline._reversed && timeline._reversed.backward();
						}
					}
					else
					{
						timeline._repeated && timeline._repeated.backward();
					}
				}
				timeline._changed && timeline._changed.backward();
				if (completed)
				{
					timeline._started && timeline._started.backward();
					timeline.pause();
				}
			}
		}
		
		private static function timeline_integrateChildren(
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
	}

}

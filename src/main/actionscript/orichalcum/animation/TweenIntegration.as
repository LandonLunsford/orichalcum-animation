package orichalcum.animation 
{
	import flash.utils.Dictionary;
	import orichalcum.animation.plugin.IPlugin;
	
	internal class TweenIntegration
	{
		public function rNwN(tween:Tween, forward:Boolean, completed:Boolean, length:Number, repeated:Function, reversed:Function):void
		{
			const currentPosition:Number = tween._position;
			const scaledIterationDuration:Number = tween._duration
			
			var ratio:Number;
			if (completed) { ratio = forward ? 1 : 0; }
			else if (currentPosition == 0) { ratio = 0; }
			else if (scaledIterationDuration == 0) { ratio = 1; }
			else { ratio = tween._ease(currentPosition / scaledIterationDuration); }
			
			integrateProperties(tween, ratio, completed);
		}
		
		public function rYwN(tween:Tween, forward:Boolean, completed:Boolean, length:Number, repeated:Function, reversed:Function):void
		{
			const currentPosition:Number = tween._position;
			const previousPosition:Number = tween._previousPosition;
			const scaledIterationDuration:Number = tween._duration;
			const currentSpan:int = (currentPosition / scaledIterationDuration) >> 0;
			const previousSpan:int = (previousPosition / scaledIterationDuration) >> 0;
			const projectedCurrentPosition:Number = currentPosition - scaledIterationDuration * currentSpan;
			
			var ratio:Number;
			if (completed) { ratio = forward ? 1 : 0; }
			else if (currentPosition == 0) { ratio = 0; }
			else if (scaledIterationDuration == 0) { ratio = 1; }
			else { ratio = tween._ease(projectedCurrentPosition / scaledIterationDuration); }
			
			integrateProperties(tween, ratio, completed);
			completed || integrateRepeatsAndReversals(tween, previousSpan, currentSpan, repeated, reversed);
					
		}
		
		public function rNwY(tween:Tween, forward:Boolean, completed:Boolean, length:Number, repeated:Function, reversed:Function):void
		{
			rYwY(tween, forward, completed, length, repeated, reversed);
		}
		
		public function rYwY(tween:Tween, forward:Boolean, completed:Boolean, length:Number, repeated:Function, reversed:Function):void
		{
			// keep variables close
			const currentPosition:Number = tween._position;
			const previousPosition:Number = tween._previousPosition;
			const iterationDuration:Number = tween._duration;
			const scaledIterationDuration:Number = iterationDuration * 0.5;
			const currentSpan:int = (currentPosition / scaledIterationDuration) >> 0;
			const previousSpan:int = (previousPosition / scaledIterationDuration) >> 0;
			const projectedCurrentPosition:Number = currentPosition - scaledIterationDuration * currentSpan;
			const reverseSpan:Boolean = (currentSpan & 1) == 1;
			
			var ratio:Number;
			if (completed || currentPosition == 0) { ratio = 0; }
			else if (scaledIterationDuration == 0) { ratio = 1; }
			else
			{
				ratio = tween._ease(projectedCurrentPosition / scaledIterationDuration);
				if (reverseSpan)
				{
					ratio = 1 - ratio;
				}
			}
			
			integrateProperties(tween, ratio, completed);
			completed || integrateRepeatsAndReversals(tween, previousSpan, currentSpan, repeated, reversed);
		}
		
		public function allInOne(tween:Tween, forward:Boolean, completed:Boolean, length:Number, repeated:Function, reversed:Function):void
		{
			const currentPosition:Number = tween._position;
			const previousPosition:Number = tween._previousPosition;
			const iterationDuration:Number = tween._duration;
			const wave:Boolean = tween._wave;
			const scaledIterationDuration:Number = wave ? iterationDuration * 0.5 : iterationDuration;
			const currentSpan:int = (currentPosition / scaledIterationDuration) >> 0;
			const previousSpan:int = (previousPosition / scaledIterationDuration) >> 0;
			const projectedCurrentPosition:Number = currentPosition - scaledIterationDuration * currentSpan;
			const reverseSpan:Boolean = wave && ((currentSpan & 1) == 1);
			
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
			
			integrateProperties(tween, ratio, completed);
			completed || integrateRepeatsAndReversals(tween, previousSpan, currentSpan, repeated, reversed);
		}
		
		
		private function integrateProperties(tween:Tween, ratio:Number, completed:Boolean):void 
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
				if (property in target && value !== undefined)
				{
					target[property] = value;
				}
			}
		}
		
		private static function integrateRepeatsAndReversals(
			tween:Tween,
			previousSpan:int,
			currentSpan:int,
			repeated:Function,
			reversed:Function):void
		{
			var x:int = currentSpan - previousSpan,
				y:int = x > 0 ? -1 : 1;
				
			if (tween._wave)
			{
				for (; x != 0; x += y)
				{
					if (((currentSpan + x) & 1) == 1)
					{
						repeated && repeated();
					}
					else
					{
						reversed && reversed();
					}
				}
			}
			else
			{
				for (; x != 0; x += y)
				{
					repeated && repeated();
				}
			}
		}
		
	}

}
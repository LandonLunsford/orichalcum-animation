package orichalcum.animation 
{
	
	internal class TimelineIntegration
	{
		public function rNwN(timeline:Timeline, forward:Boolean, completed:Boolean, length:Number, repeated:Function, reversed:Function):void
		{
			integrateChildren(
				timeline._children,
				timeline._previousPosition,
				timeline._position,
				timeline._duration,
				forward);
		}
		
		public function rYwN(timeline:Timeline, forward:Boolean, completed:Boolean, length:Number, repeated:Function, reversed:Function):void
		{
			const currentPosition:Number = timeline._position;
			const previousPosition:Number = timeline._previousPosition;
			const iterationDuration:Number = timeline._duration;
			const currentSpan:int = (currentPosition / iterationDuration) >> 0;
			const previousSpan:int = (previousPosition / iterationDuration) >> 0;
			const spanStep:int = forward ? 1 : -1;
			const totalSpans:int = (length / iterationDuration) >> 0;
			
			for (var j:int = previousSpan, jf:int = currentSpan + spanStep; j != jf; j += spanStep)
			{
				integrateChildren(
					timeline._children,
					previousPosition - iterationDuration * j,
					currentPosition - iterationDuration * j,
					iterationDuration,
					forward);
				
				if (j == currentSpan)
				{
					if (forward ? j + spanStep == totalSpans : j == totalSpans)
						continue;
				}
				
				repeated && repeated();
			}
		}
		
		public function rNwY(timeline:Timeline, forward:Boolean, completed:Boolean, length:Number, repeated:Function, reversed:Function):void
		{
			rYwY(timeline, forward, completed, length, repeated, reversed);
		}
		
		public function rYwY(timeline:Timeline, forward:Boolean, completed:Boolean, length:Number, repeated:Function, reversed:Function):void
		{
			const currentPosition:Number = timeline._position;
			const previousPosition:Number = timeline._previousPosition;
			const iterationDuration:Number = timeline._duration;
			const instancesOrIntervals:Array = timeline._children;
			const scaledIterationDuration:Number = iterationDuration * 0.5;
			const currentSpan:int = (currentPosition / scaledIterationDuration) >> 0;
			const previousSpan:int = (previousPosition / scaledIterationDuration) >> 0;
			const spanStep:int = forward ? 1 : -1;
			const totalSpans:int = ((length * 2) / iterationDuration) >> 0;
			
			var projectedCurrentPosition:Number,
				projectedPreviousPosition:Number,
				reverseSpan:Boolean,
				forward2:Boolean;
			
			for (var j:int = previousSpan, jf:int = currentSpan + spanStep; j != jf; j += spanStep)
			{
				projectedCurrentPosition = currentPosition - scaledIterationDuration * j;
				projectedPreviousPosition = previousPosition - scaledIterationDuration * j;
				reverseSpan = ((j & 1) == 1);
				if (reverseSpan)
				{
					projectedCurrentPosition = scaledIterationDuration - projectedCurrentPosition;
					projectedPreviousPosition = scaledIterationDuration - projectedPreviousPosition;
				}
				projectedCurrentPosition *= 2;
				projectedPreviousPosition *= 2;
				forward2 = forward ? !reverseSpan : reverseSpan;
				
				integrateChildren(
					timeline._children,
					projectedPreviousPosition,
					projectedCurrentPosition,
					iterationDuration,
					forward2);
				
				// bad loop setup?
				if (j == currentSpan)
				{
					if (forward ? j + spanStep == totalSpans : j == totalSpans)
						continue;
				}
				
				if (forward2)
				{
					reversed && reversed();
				}
				else
				{
					repeated && repeated();
				}
			}
		}
		
		public function allInOne(timeline:Timeline, forward:Boolean, completed:Boolean, length:Number, repeated:Function, reversed:Function):void
		{
			const currentPosition:Number = timeline._position;
			const previousPosition:Number = timeline._previousPosition;
			const iterationDuration:Number = timeline._duration;
			const instancesOrIntervals:Array = timeline._children;
			const wave:Boolean = timeline._wave;
			const scaledIterationDuration:Number = wave ? iterationDuration * 0.5 : iterationDuration;
			const currentSpan:int = (currentPosition / scaledIterationDuration) >> 0;
			const previousSpan:int = (previousPosition / scaledIterationDuration) >> 0;
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
				
				integrateChildren(
					timeline._children,
					projectedPreviousPosition,
					projectedCurrentPosition,
					iterationDuration,
					forward2);
				
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
		
		private function integrateChildren(children:Array, previous:Number, current:Number, duration:Number, forward:Boolean):void
		{
			var i:int, totalChildren:int,
				child:TimelineEntry,
				childPosition:Number,
				childInterval:Interval,
				childLength:Number;
				
			if (forward)
			{
				totalChildren = children.length;
				for (i = 0; i != totalChildren; i += 1)
				{
					child = children[i];
					childPosition = child.position;

					if (child.instance
					&& (
						(childPosition > previous && childPosition < current)
						||
						(
							(childPosition == 0 && childPosition == previous)
							||
							(childPosition != 0 && childPosition == current)
						)
					))
					{
						child.instance.forward();
					}
					else if (child.interval)
					{
						childInterval = child.interval;
						childLength = childInterval.length();
						childInterval._previousPosition = Mathematics.clamp(previous - childPosition, 0, childLength);
						childInterval._position = Mathematics.clamp(current - childPosition, 0, childLength);
						childInterval._position != childInterval._previousPosition && childInterval.integrate();
					}
				}
			}
			else
			{
				for (i = children.length - 1; i != -1; i -= 1)
				{
					child = children[i];
					childPosition = child.position;

					if (child.instance
					&& (
						(childPosition > current && childPosition < previous)
						||
						(
							(childPosition == duration && childPosition == previous)
							||
							(childPosition != duration && childPosition == current)
						)
					))
					{
						child.instance.backward();
					}
					else if (child.interval)
					{
						childInterval = child.interval;
						childLength = childInterval.length();
						childInterval._previousPosition = Mathematics.clamp(previous - childPosition, 0, childLength);
						childInterval._position = Mathematics.clamp(current - childPosition, 0, childLength);
						childInterval._position != childInterval._previousPosition && childInterval.integrate();
					}
				}
			}
		}
		
	}

}
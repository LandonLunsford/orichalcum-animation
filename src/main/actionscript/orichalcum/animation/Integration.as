package orichalcum.animation 
{
	
	public class Integration 
	{
		public static const timeline:TimelineIntegration = new TimelineIntegration;
		
		public static const tween:TweenIntegration = new TweenIntegration;
		
		public static function getOptimalIntegrationStrategy(interval:IInterval):Function
		{
			/*
			 * Decision tree for optimal algorithm
			 */
			const isTimeline:Boolean = interval is Timeline;
			const iters:Boolean = interval.iterations() > 1;
			const waves:Boolean = interval.wave();
			
			return isTimeline
				? iters ? waves ? timeline.rYwY
						: timeline.rYwN
					: waves ? timeline.rNwY
						: timeline.rNwN
				: iters ? waves ? tween.rYwY
						: tween.rYwN
					: waves ? tween.rNwY
						: tween.rNwN;
		}
		
		public static function integrate(interval:PlayableInterval, integrationStrategy:Function):void
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
				integrationStrategy(
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
				integrationStrategy(
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
	}
}


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
		// special
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
		// special
		tween._changed && tween._changed.backward();
		if (completed)
		{
			tween._started && tween._started.backward();
			tween.pause();
		}
	}
}

internal static function timeline_multiIteration_wave(timeline:Timeline):void
{
	var currentPosition:Number = timeline._position;
	var previousPosition:Number = timeline._previousPosition;
	var wave:Boolean = timeline._wave;
	var iterationDuration:Number = timeline._duration;
	var length:Number = timeline.length();
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
	
	if (forward)
	{
		completed = currentPosition == length;
		previousPosition == 0 && timeline._started && timeline._started.forward();
		timeline._changing && timeline._changing.forward();
		//special
		timeline._changed && timeline._changed.forward();
		if (completed)
		{
			timeline.pause();
			timeline._completed && timeline._completed.forward();
		}
	}
	else
	{
		completed = currentPosition == 0;
		previousPosition == length && timeline._completed && timeline._completed.backward();
		timeline._changing && timeline._changing.backward();
		//special
		timeline._changed && timeline._changed.backward();
		if (completed)
		{
			timeline.pause();
			timeline._started && timeline._started.backward();
		}
	}
}
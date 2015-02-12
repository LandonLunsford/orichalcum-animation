package orichalcum.animation.factory 
{
	import orichalcum.animation.Timeline;
	
	public function timeline(...instancesIntervalsAndDirectives):Timeline
	{
		const timeline:Timeline = new Timeline();
		timeline.add.apply(null, instancesIntervalsAndDirectives);
		return timeline;
	}

}
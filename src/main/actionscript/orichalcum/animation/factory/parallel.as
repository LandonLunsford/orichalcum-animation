package orichalcum.animation.factory 
{
	import orichalcum.animation.Parallel;
	
	public function parallel(...instancesAndIntervals):Parallel
	{
		const parallel:Parallel = new Parallel();
		parallel.add.apply(null, instancesAndIntervals);
		return parallel;
	}

}
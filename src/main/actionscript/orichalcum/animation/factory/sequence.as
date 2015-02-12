package orichalcum.animation.factory 
{
	import orichalcum.animation.Sequence;
	
	public function sequence(...instancesAndIntervals):Sequence
	{
		const sequence:Sequence = new Sequence();
		sequence.add.apply(null, instancesAndIntervals);
		return sequence;
	}

}
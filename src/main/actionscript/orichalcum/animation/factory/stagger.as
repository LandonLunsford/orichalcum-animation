package orichalcum.animation.factory 
{
	import orichalcum.animation.Stagger;
	
	public function stagger(time:Number, ...instancesAndIntervals):Stagger
	{
		const stagger:Stagger = new Stagger(time);
		stagger.add.apply(null, instancesAndIntervals);
		return stagger;
	}

}
package orichalcum.animation 
{
	
	public class Sequence implements IDirective
	{
		
		internal var instancesAndIntervals:Array = [];
		
		public function Sequence(...instancesAndIntervals) 
		{
			add.apply(this, instancesAndIntervals);
		}
		
		public function add(...instancesAndIntervals):void
		{
			for each(var instanceOrInterval:* in instancesAndIntervals)
			{
				this.instancesAndIntervals.push(instanceOrInterval);
			}
		}
		
		public function apply(timeline:Timeline):void 
		{
			for each(var x:* in instancesAndIntervals)
			{
				x is PlayableInterval && (x as PlayableInterval).pause();
				timeline.add(x);
			}
		}
		
	}

}
package orichalcum.animation 
{
	
	public class Parallel implements IDirective
	{
		
		internal var instancesAndIntervals:Array = [];
		
		public function Parallel(...instancesAndIntervals) 
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
			//var maximumLength:Number = Number.MIN_VALUE;
			const position:Number = timeline.insertionPosition;
			for each(var x:* in instancesAndIntervals)
			{
				x is PlayableInterval && (x as PlayableInterval).pause();
				timeline.add(position, x);
			}
		}
		
	}

}
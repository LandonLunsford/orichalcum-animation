package orichalcum.animation 
{
	
	public class Sequence implements IDirective
	{
		
		internal var instancesAndIntervals:Array = [];
		
		public function Sequence(...instancesAndIntervals) 
		{
			add.apply(this, instancesAndIntervals);
		}
		
		public function add(instanceOrInterval:*):void
		{
			instancesAndIntervals.push(instanceOrInterval);
		}
		
		public function apply(timeline:Timeline):void 
		{
			for each(var x:* in instancesAndIntervals)
			{
				timeline.add(x);
				
				if (x is IInterval)
				{
					timeline.insertionPosition += x.length();
				}
				
			}
		}
		
	}

}
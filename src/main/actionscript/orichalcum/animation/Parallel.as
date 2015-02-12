package orichalcum.animation 
{
	
	public class Parallel implements IDirective
	{
		
		internal var instancesAndIntervals:Array = [];
		
		public function Parallel(...instancesAndIntervals) 
		{
			add.apply(this, instancesAndIntervals);
		}
		
		public function add(instanceOrInterval:*):void
		{
			instancesAndIntervals.push(instanceOrInterval);
		}
		
		public function apply(timeline:Timeline):void 
		{
			var maximumLength:Number = Number.MIN_VALUE;
			for each(var x:* in instancesAndIntervals)
			{
				timeline.add(x);
				
				var currentLength:Number = x.length();
				if (currentLength > maximumLength)
				{
					maximumLength = currentLength;
				}
			}
			
			timeline.insertionPosition += maximumLength;
		}
		
	}

}
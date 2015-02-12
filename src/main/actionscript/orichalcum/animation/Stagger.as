package orichalcum.animation 
{
	
	public class Stagger implements IDirective
	{
		
		internal var stagger:Number;
		internal var instancesAndIntervals:Array;
		
		public function Stagger(stagger:Number, ...instancesAndIntervals) 
		{
			this.stagger = isNaN(stagger) ? 0 : stagger;
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
					timeline.insertionPosition += stagger;
				}
			}
		}
		
	}

}
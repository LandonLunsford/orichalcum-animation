package orichalcum.animation 
{
	
	public class Stagger implements IDirective
	{
		
		internal var stagger:Number;
		internal var instancesAndIntervals:Array = [];
		
		public function Stagger(stagger:Number, ...instancesAndIntervals) 
		{
			this.stagger = isNaN(stagger) ? 0 : stagger;
			add.apply(this, instancesAndIntervals);
		}
		
		public function add(...instancesAndIntervals:*):void
		{
			for each(var instanceOrInterval:* in instancesAndIntervals)
			{
				this.instancesAndIntervals.push(instanceOrInterval);
			}
		}
		
		public function apply(timeline:Timeline):void 
		{
			for (var i:int = 0; i < instancesAndIntervals.length; i++)
			{
				var x:* = instancesAndIntervals[i];
				x is PlayableInterval && (x as PlayableInterval).pause();
				timeline.add(stagger * i, x);
			}
		}
		
	}

}
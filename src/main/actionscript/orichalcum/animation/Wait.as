package orichalcum.animation 
{
	import flash.events.Event;
	import orichalcum.animation.core.Clock;
	
	public class Wait implements IDirective
	{
		
		internal var duration:Number;
		
		public function Wait(duration:Number) 
		{
			this.duration = isNaN(duration) ? 0 : duration;
		}
		
		public function apply(timeline:Timeline):void
		{
			timeline.insertionPosition += duration;
		}
		
	}

}
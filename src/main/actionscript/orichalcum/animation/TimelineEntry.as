package orichalcum.animation 
{
	
	internal class TimelineEntry
	{
		
		internal var position:Number;
		internal var entry:*;
		
		public function TimelineEntry(position:Number, entry:*) 
		{
			this.position = position;
			this.entry = entry;
		}
		
		public function get instance():IInstance
		{
			return entry as IInstance;
		}
		
		public function get interval():Interval
		{
			return entry as Interval;
		}
		
	}

}
package orichalcum.animation 
{
	
	internal class Preconditions 
	{
		
		public static function assert(assertion:Boolean, message:String):void
		{
			assertion || throw new ArgumentError(message);
		}
		
	}

}
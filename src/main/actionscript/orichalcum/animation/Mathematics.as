package orichalcum.animation 
{
	
	internal class Mathematics 
	{
		
		//public static const EPSILON:Number = 0.0001;
		public static const EPSILON:Number = 1; // can only guarantee accuracy to ints
		
		public static function clamp(value:Number, minimum:Number, maximum:Number):Number
		{
			if (value < minimum) return minimum;
			if (value > maximum) return maximum;
			return value;
		}
		
	}

}
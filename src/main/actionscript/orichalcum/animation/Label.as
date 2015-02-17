package orichalcum.animation 
{
	
	public class Label implements IDirective
	{
		private var _name:String;
		
		public function Label(name:String) 
		{
			_name = name;
		}
		
		public function apply(timeline:Timeline):void 
		{
			timeline.positionsByLabel[_name] = timeline.insertionPosition;
		}
		
	}

}
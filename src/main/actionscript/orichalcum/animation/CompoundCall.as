package orichalcum.animation 
{
	
	public class CompoundCall implements IInstance
	{
		
		private var _calls:Array;
		
		public function add(call:Call):void
		{
			(_calls ||= []).push(call);
		}
		
		public function forward():void 
		{
			for (var i:int = 0; i < _calls.length; i++)
			{
				_calls[i].forward();
			}
		}
		
		public function backward():void 
		{
			for (var i:int = _calls.length - 1; i >= 0; i--)
			{
				_calls[i].backward();
			}
		}
		
	}

}
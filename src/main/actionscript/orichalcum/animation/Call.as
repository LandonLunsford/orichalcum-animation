package orichalcum.animation 
{
	
	public class Call implements IInstance
	{
		public static const EMPTY:Call = new Call;
		
		private var _forwardCallback:Function;
		private var _backwardCallback:Function
		
		public function Call(forwardCallabck:Function = null, backwardCallback:Function = null) 
		{
			_forwardCallback = forwardCallabck || Functions.VOID;
			_backwardCallback = backwardCallback || Functions.VOID;
		}
		
		public function forward():void 
		{
			_forwardCallback();
		}
		
		public function backward():void
		{
			_backwardCallback();
		}
		
	}

}
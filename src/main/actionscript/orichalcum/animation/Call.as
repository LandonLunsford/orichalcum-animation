package orichalcum.animation 
{
	
	public class Call implements IInstance
	{
		
		private var _forwardCallback:Function;
		private var _backwardCallback:Function
		
		public function Call(forwardCallabck:Function, backwardCallback:Function = null) 
		{
			_forwardCallback = forwardCallabck;
			_backwardCallback = backwardCallback;
		}
		
		public function invoke(forward:Boolean):* 
		{
			if (forward)
			{
				_forwardCallback != null && _forwardCallback()
			}
			else
			{
				_backwardCallback != null && _backwardCallback();
			}
		}
		
	}

}
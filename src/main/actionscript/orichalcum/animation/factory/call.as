package orichalcum.animation.factory 
{
	import orichalcum.animation.Call;
	
	public function call(forwardCallback:Function, backwardCallback:Function = null):Call
	{
		return new Call(forwardCallback, backwardCallback);
	}

}
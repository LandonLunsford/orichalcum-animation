package orichalcum.animation.factory
{
	import orichalcum.animation.Wait;
	
	public function wait(duration:Number):Wait
	{
		return new Wait(duration);
	}

}
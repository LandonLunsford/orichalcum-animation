package orichalcum.animation.factory 
{
	import orichalcum.animation.Tween;
	
	public function tween(target:Object):Tween
	{
		return new Tween(target);
	}

}
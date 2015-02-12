package orichalcum.animation.factory 
{
	import orichalcum.animation.Init;
	
	public function init(target:Object, properties:Object):Init
	{
		return new Init(target, properties);
	}

}
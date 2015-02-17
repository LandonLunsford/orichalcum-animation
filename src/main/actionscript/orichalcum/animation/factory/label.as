package orichalcum.animation.factory 
{
	import orichalcum.animation.Label;
	
	public function label(name:String):Label
	{
		return new Label(name);
	}

}
package orichalcum.animation 
{
	import flash.display.Sprite;
	
	public class Demo2 extends Sprite
	{
		
		private var _timeline:Timeline;
		
		public function Demo2() 
		{
			_timeline = timeline(
		}
		
		private function target():Sprite
		{
			const sprite:Sprite = new Sprite;
			sprite.graphics.beginFill(0xffffff * Math.random());
			sprite.graphics.drawCircle(0, 0, 100);
			sprite.graphics.endFill();
			return sprite;
		}
		
	}

}
package orichalcum.animation 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import orichalcum.animation.factory.tween;
	
	public class Demo2 extends Sprite
	{
		
		private var _timeline:Timeline;
		
		public function Demo2() 
		{
			const target:DisplayObject = target();
			addChild(target);
			
			const w:Number = stage.stageWidth;
			const h:Number = stage.stageHeight;
			
			// from-to PASS
			//tween(target)
				//.from({ x: w * 0.8, y: h * 0.8 })
				//.to( { x: w * 0.2, y: h * 0.2 } )
				//.duration(1000)
				
			//// to PASS
			//tween(target)
				//.to( { x: w * 0.8, y: h * 0.8 } )
				//.duration(1000)
				
			// from FAIL
			tween(target)
				.from( { x: w * 0.8, y: h * 0.8 } )
				.duration(1000)
				
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
package orichalcum.animation 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import orichalcum.animation.factory.tween;
	import orichalcum.animation.plugin.ScalePlugin;
	import orichalcum.animation.plugin.VisiblePlugin;
	
	public class Demo2 extends Sprite
	{
		
		private var _timeline:Timeline;
		
		public function Demo2() 
		{
			const target:DisplayObject = target();
			addChild(target);
			
			const w:Number = stage.stageWidth;
			const h:Number = stage.stageHeight;
			
			Tween.plugins.add(
				new ScalePlugin(),
				new VisiblePlugin(0.01)
			);
			
			// from-to PASS
			tween(target)
				.from( { x: w * 0.8, y: h * 0.8, scale:1 } )
				.to( { x: w * 0.2, y: h * 0.2, scale:2 } )
				.duration(5000)
				.wave(true)
				.iterations(int.MAX_VALUE)
				.reversed(function():void { trace('fw_reversed'); }, function():void { trace('bw_reversed'); })
				.repeated(function():void { trace('fw_repeated'); }, function():void { trace('bw_repeated'); })
				
			//// to PASS
			//tween(target)
				//.to( { x: w * 0.8, y: h * 0.8 } )
				//.duration(1000)
				
			// from FAIL
			//tween(target)
				//.from( { x: w * 0.8, y: h * 0.8 } )
				//.duration(1000)
				
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
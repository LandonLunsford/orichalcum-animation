package orichalcum.animation
{

	internal class Ease 
	{

		private static const PI:Number = Math.PI;
		private static const PI_2:Number = Math.PI * 0.5;
		private static const TWO_PI:Number = Math.PI * 2;
		private static const _1_275:Number = 1 / 2.75;
		private static const _15_275:Number = 1.5 / 2.75;
		private static const _2_275:Number = 2 / 2.75;
		private static const _25_275:Number = 2.5 / 2.75;
		private static const _225_275:Number = 2.25 / 2.75;
		private static const _2625_275:Number = 2.625 / 2.75;

		public static const none:Function = linear;

		public static const quadIn:Function = customPowIn(2);
		public static const quadOut:Function = customPowOut(2);
		public static const quadInOut:Function = customPowInOut(2);

		public static const cubicIn:Function = customPowIn(3);
		public static const cubicOut:Function = customPowOut(3);
		public static const cubicInOut:Function = customPowInOut(3);

		public static const quartIn:Function = customPowIn(4);
		public static const quartOut:Function = customPowOut(4);
		public static const quartInOut:Function = customPowInOut(4);

		public static const quintIn:Function = customPowIn(5);
		public static const quintOut:Function = customPowOut(5);
		public static const quintInOut:Function = customPowInOut(5);
		
		public static const backIn:Function = customBackIn(1.7);
		public static const backOut:Function = customBackOut(1.7);
		public static const backInOut:Function = customBackInOut(1.7);
		
		public static const elasticIn:Function = customElasticIn(1, 0.3);
		public static const elasticOut:Function = customElasticOut(1, 0.3);
		public static const elasticInOut:Function = customElasticInOut(1, 0.3 * 1.5);
		
		public static function custom(value:Number):Function {
			value = Math.min(Math.max(value, -1), 1);
			return function(t:Number):Number {
				if (value == 0) return t;
				if (value < 0) return t * (t * -value + 1 + value);
				return t * ((2 - t) * value + (1 - value));
			};
		}

		public static const linear:Function = function(t:Number):Number {
			return t;
		}
		
		public static function customPowIn(power:Number):Function {
			return function(t:Number):Number {
				return Math.pow(t, power);
			};
		}

		public static function customPowOut(power:Number):Function {
			return function(t:Number):Number {
				return 1 - Math.pow(1 - t, power);
			};
		}

		public static function customPowInOut(power:Number):Function {
			return function(t:Number):Number {
				return (t *= 2) < 1
					? 0.5 * Math.pow(t, power)
					: 1 - 0.5 * Math.abs(Math.pow(2 - t, power));
			};
		}

		public static const sineIn:Function = function(t:Number):Number {
			return 1 - Math.cos(t * PI_2);
		}

		public static const sineOut:Function = function(t:Number):Number {
			return Math.sin(t * PI_2);
		}

		public static const sineInOut:Function = function(t:Number):Number {
			return -0.5 * (Math.cos(PI * t) - 1);
		}

		public static function customBackIn(value:Number):Function {
			return function(t:Number):Number {
				return t * t * ((value + 1) * t - value);
			};
		}
		
		public static function customBackOut(value:Number):Function {
			return function(t:Number):Number {
				return (--t * t * ((value + 1) * t + value) + 1);
			};
		}
		
		public static function customBackInOut(value:Number):Function {
			value *= 1.525;
			return function(t:Number):Number {
				return (t *= 2) < 1
					? 0.5 * (t * t * ((value + 1) * t - value))
					: 0.5 * ((t -= 2) * t * ((value + 1) * t + value) + 2);
			};
		}

		public static const circIn:Function = function(t:Number):Number {
			return -(Math.sqrt(1 - t * t) - 1);
		}

		public static const circOut:Function = function(t:Number):Number {
			return Math.sqrt(1 - (--t) * t);
		}

		public static const circInOut:Function = function(t:Number):Number {
			return (t *= 2) < 1
				? -0.5 * (Math.sqrt(1 - t * t) - 1)
				: 0.5 * (Math.sqrt(1 - (t -= 2) * t) + 1);
		}

		public static const bounceIn:Function = function(t:Number):Number {
			return 1 - bounceOut(1 - t);
		}
		
		public static const bounceOut:Function = function(t:Number):Number {
			if (t < _1_275) return (7.5625*t*t);
			if (t < _2_275) return (7.5625*(t-=_15_275)*t+0.75);
			if (t < _25_275) return (7.5625*(t-=_225_275)*t+0.9375);
			return (7.5625*(t -= _2625_275)*t +0.984375);
		}

		public static const bounceInOut:Function = function(t:Number):Number {
			return t < 0.5
				? bounceIn(t * 2) * 0.5
				: bounceOut(t * 2 - 1) * 0.5 + 0.5;
		}

		public static function customElasticIn(amplitude:Number, period:Number):Function {
			const twoPI:Number = Math.PI*2;
			return function(t:Number):Number {
				if (t==0 || t==1) return t;
				const s:Number = period / twoPI * Math.asin(1 / amplitude);
				return -(amplitude * Math.pow(2, 10 * (t -= 1)) * Math.sin((t - s) * twoPI / period));
			};
		}
		
		public static function customElasticOut(amplitude:Number, period:Number):Function {
			const twoPI:Number = Math.PI * 2;
			return function(t:Number):Number {
				if (t==0 || t==1) return t;
				const s:Number = period / twoPI * Math.asin(1 / amplitude);
				return (amplitude * Math.pow(2, -10 * t) * Math.sin((t - s) * twoPI / period) + 1);
			};
		}
		
		public static function customElasticInOut(amplitude:Number, period:Number):Function {
			const twoPI:Number = Math.PI * 2;
			return function(t:Number):Number {
				const s:Number = period / twoPI * Math.asin(1 / amplitude);
				return (t *= 2) < 1
					? -0.5 * (amplitude * Math.pow(2, 10 * (t -= 1)) * Math.sin( (t - s) * twoPI / period))
					: amplitude * Math.pow(2, -10 * (t -= 1)) * Math.sin((t - s) * twoPI / period) * 0.5 + 1;
			};
		}
		
	}

}


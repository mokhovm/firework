package main
{
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * фрагмент от взрыва ракеты. Летит в произвольную сторону и через некоторое время взрывается
	 * @author phanatos
	 * 
	 */
	public class Fragment extends SkyObject
	{
		// Сколько раз может взрываться зведа 
		public static const EXPLODE_QTY:int = 2;
		/**
		 * количество фрагментов во взрыве 
		 */		
		public static const FRAGMENTS_QTY:int = 20;
		
		// сила врзыва ракеты (определяет размер взрыва)
		private const POWER_EXPLODE:int = 20;
		// сколько пролетает звезда, прежде чем погаснуть
		private const STAR_DISTANCE:Number = 120;
		// на сколько уменьшается звезда с каждым фреймом
		private const STAR_REDUCE:Number = 0.02;
		
		private var expQty:int = 0;
		
		public function Fragment(aParent:DisplayObjectContainer, aX:int, aY:int, 
							 aColor:int, aExpQty:int = 0, aMc:MovieClip = null, centerX:int = 0)
		{
			const xOffset:int = 2;
			const yOffest:int = 11;
			
			var frameNo:int;
			
			mc = (aMc == null ? new NsRocketStar() : aMc);
			mc.x = aX;
			mc.y = aY;
			mc.blendMode = BlendMode.ADD;
			color = aColor;
			screen = aParent;
			startX = aX;
			startY = aY;
			expQty = aExpQty;
			
			// подменим немного базовые параметры мира, чтобы вспышки летели более естественно
			friction =  FireworksNS.DEF_FRICTION + Math.random() * 0.005;
			gravity =  FireworksNS.DEF_GRAVITY - Math.random() * 0.01;
			
			initStartCoords(centerX);
			
			frameNo = (color != 0 ? color : Math.ceil(Math.random() * mc.totalFrames));
			mc.gotoAndStop(frameNo);
			mc.addEventListener(Event.ENTER_FRAME, onStarFrame);
			screen.addChild(mc);
		}
		
		/**
		 * создает   
		 * @param aParent
		 * @param aX
		 * @param aY
		 * @param aColor
		 * @param aQty
		 * 
		 */
		public static function createFragments(aParent:DisplayObjectContainer, aX:int, aY:int, 
			aColor:int, aExpQty:int, aQty:int):void
		{
			var qty:int = 0;
			var scale:Number = 1 / (aExpQty + 1); 
			var explode:MovieClip = new NsExplode();
			explode.blendMode = BlendMode.ADD;
			explode.scaleX = scale;
			explode.scaleY = scale;
			aParent.addChild(explode);
			explode.x = aX;
			explode.y = aY;
			while(qty < aQty)
			{
				new Fragment(aParent, aX, aY, aColor, aExpQty);
				qty ++;
			}
		}
		
		/**
		 * Инициирует стартовые координаты. 
		 * 
		 */
		private function initStartCoords(centerX:Number):void
		{
			
			var res:Boolean;
			if (centerX != 0)
			{
				// если центр взрыва указан, значит это звезда от символа. Она падает просто вниз
				// с небольшим углом к центру взрыва
				
				dx = Math.random() * 0.5;
				dy = -0.01;
				if (centerX > startX) dx = -dx; 
			}
			else
			{
				// Если центр взрыва не указан, то это звезда от ракеты
				// Ищет и устанавливает случайные координаты, чтобы они находились внутри окружности 
				do
				{
					dx = Math.random() * POWER_EXPLODE * 2 - POWER_EXPLODE;
					dy = Math.random() * POWER_EXPLODE * 2 - POWER_EXPLODE;
					res = Math.pow(dx, 2) + Math.pow(dy, 2) <= POWER_EXPLODE
				}
				while (!res);
			}
		}
		
		/**
		 * обработчик полета звездочки 
		 * @param e
		 * 
		 */		
		private function onStarFrame(e:Event):void
		{
			if (mc != null)
			{
				mc.x = mc.x + dx;
				mc.y = mc.y - dy;
				dx = dx * friction;
				dy = dy * friction - gravity;
				
				//var dist:Number = getDistance(new Point(startX, startY), new Point(mc.x, mc.y));
				//var scale:Number = 1 - dist / STAR_DISTANCE;
				var scale:Number = mc.scaleX - STAR_REDUCE; 
				
				mc.scaleX = scale; 
				mc.scaleY = scale;
				if(mc.scaleX < 0)
				{
					if (expQty < EXPLODE_QTY)
					{
						expQty ++;
						createFragments(screen, mc.x, mc.y, color, expQty, FRAGMENTS_QTY / (expQty + 2));
					}
					
					mc.removeEventListener(Event.ENTER_FRAME, onStarFrame);
					mc.parent.removeChild(mc);
					mc = null;
					
				}
			}
		}
		
	}
}
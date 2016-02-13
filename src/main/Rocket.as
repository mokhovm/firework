package main
{
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * Ракета, улетающая в небо 
	 * @author phanatos
	 * 
	 */
	public class Rocket extends SkyObject
	{
		/**
		 * на сколько уменьшается искринка хвоста ракеты (влияет на длину хвоста) 
		 */		
		private const SPARKS_REDUCE_SCALE:Number = 0.03;
		
		/**
		 * количество искр в хвосте ракеты 
		 */		
		private const SPARK_PER_FRAME:int = 2;
		/**
		 * количество выпущенных искр от ракеты 
		 */		
		private var sparkQty:int = 0;
		
		public function Rocket(aParent:DisplayObjectContainer, aX:int = 0, aY:int = 0)
		{
			const xOffset:int = 2;
			const yOffest:int = 11;
			
			screen = aParent;
			mc = new NsRocket2();
			//mc.blendMode = BlendMode.ADD;
			
			mc.x = (aX != 0 ? aX : Math.random() * screen.stage.stageWidth); 
			mc.y = (aY != 0 ? aY : screen.stage.stageHeight - 50);
			//color = (aColor != 0 ? aColor : Math.round(Math.random() * Fireworks.MAX_COLORS));
			
			friction = FireworksNS.DEF_FRICTION + 0.02;
			gravity = FireworksNS.DEF_GRAVITY;
			
			dx = Math.random() * xOffset * 2 - xOffset;
			dy = Math.random() * yOffest / 2 + yOffest;
			
			mc.addEventListener(Event.ENTER_FRAME, onRocketFrame);
			screen.addChild(mc);
		}
		
		/**
		 * обработчик фреймов запущенной ракеты 
		 * @param e
		 * 
		 */		
		private function onRocketFrame(e:Event):void
		{
			var rocket:MovieClip = e.currentTarget as MovieClip;
			if (rocket != null)
			{
				clacNewCoords();
				var qty:int = 0;
				while(qty < SPARK_PER_FRAME)
				{
					addSpark();
					qty++;
				}
				if(dy < 0)
				{
					// ракета долетела и должна взорваться
					explode();
				}
			}
		}
		
		/**
		 *  Взрыв ракеты 
		 * 
		 */
		private function explode():void
		{
			var qty:int = 0;
			mc.removeEventListener(Event.ENTER_FRAME, onRocketFrame);
			
			//mc.gotoAndPlay('explode');
			Fragment.createFragments(screen, mc.x, mc.y, 0);
		}
		
		/**
		 * рассчитывает новые координаты ракеты 
		 * 
		 */
		private function clacNewCoords():void
		{
			dx = dx * friction;
			dy = dy * friction - gravity;
			mc.x += dx;
			mc.y -= dy;
		}
		
		/**
		 * добавляет искру к хвосту ракеты 
		 * 
		 */		
		private function addSpark():void
		{
			//trace('add spark');
			var rocketSpark:MovieClip = new NsRocketSpark();
			mc.addChild(rocketSpark);
			rocketSpark.blendMode = BlendMode.ADD;
			rocketSpark.dx = Math.random() * 1 - 0.5;
			rocketSpark.dy = - Math.random() * 1;
			rocketSpark.friction = friction;
			rocketSpark.gravity = gravity;
			rocketSpark.addEventListener(Event.ENTER_FRAME, onRocketSparkFrame);
			sparkQty ++;
		}
		
		/**
		 * удаляем сгоревшие искры  
		 * @param spark
		 * 
		 */
		private function removeSpark(spark:MovieClip):void
		{
			spark.removeEventListener(Event.ENTER_FRAME, onRocketSparkFrame);
			spark.parent.removeChild(spark);
			sparkQty --;
			// если все искры прогорели, удаляем клип ракеты
			if (sparkQty <= 0) 
			{
				mc.parent.removeChild(mc);
				trace ('remove rocket')
			}
		}
		
		/**
		 * обработчик фреймов искры от ракеты 
		 * @param e
		 * 
		 */		
		private function onRocketSparkFrame(e:Event):void
		{
			var spark:MovieClip = e.currentTarget as MovieClip;
			if (spark != null)
			{
				spark.dx = spark.dx * friction;
				spark.dy = spark.dy * friction - gravity;
				
				spark.x = spark.x + spark.dx;
				spark.y = spark.y - spark.dy;
				
				spark.scaleX = spark.scaleX - SPARKS_REDUCE_SCALE;
				spark.scaleY = spark.scaleY - SPARKS_REDUCE_SCALE;
				if (spark.scaleX < 0)
				{
					removeSpark(spark);
				}
			}
		}
		
	}
	
}
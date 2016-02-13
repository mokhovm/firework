package main
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;

	/**
	 * Абстрактный небесный объект 
	 * @author phanatos
	 * 
	 */
	public class SkyObject
	{
		
		/**
		 * цвет 
		 */		
		public var color:int = 0;
		/**
		 * изменение координат 
		 */		
		public var dx:Number = 0;
		public var dy:Number = 0;
		
		/**
		 * текущее торможение 
		 */		
		protected var friction:Number;
		/**
		 * текущая гравитация 
		 */		
		protected var gravity:Number;
		/**
		 * клип объекта 
		 */		
		protected var mc:MovieClip;
		/**
		 * сцена 
		 */		
		protected var screen:DisplayObjectContainer;
		
		/**
		 * стартовые координаты 
		 */		
		protected var startX:int;
		protected var startY:int;
		
		public function SkyObject()
		{
		}
		
		/**
		 * рассчитывает дистанцию между точками. (взял из GeomUtils, чтобы не тянуть все библиотеки.
		 * Потом надо не забыть переключить )
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		private function getDistance(p1:Point, p2:Point):Number
		{
			var res:Number = Math.sqrt(Math.pow((p2.x - p1.x), 2) + Math.pow((p2.y - p1.y), 2));  
			return res;  
		}
	}
}
package main
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * Фейерверк. Тестовое задание для Nevosoft  
	 * @author phanatos
	 * 
	 */
	[SWF(width="980", height="620", backgroundColor="#000000", frameRate="25")]
	public class FireworksNS extends Sprite
	{
		/**
		 * трение в системе 
		 */
		public static const DEF_FRICTION:Number = 0.98;
		/**
		 * гравитация 
		 */
		public static const DEF_GRAVITY:Number = 0.2;
		
		
		public function FireworksNS()
		{
			stage.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			var back:MovieClip = new NsBack();
			addChild(back);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var rocket:Rocket = new Rocket(this, stage.mouseX, stage.mouseY);
		}	
	}
}
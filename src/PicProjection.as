package 
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.events.MouseEvent;
	import flash.display.GradientType;
	
	
	/**
	 * AS3.0 Bitmap类实现图片3D旋转效果
	 * @author disini
	 * 
	 */	
	[SWF(width="1600", height = "900", backgroundColor = "0xff6600", frameRate="60")]
	public class PicProjection extends Sprite
	{
		private var picw:Number = 314;
		private var pich:Number = 391;
		private var gap:Number = 1.5;
		private var speeds:Number = 0.3;
		private var maskshape:Shape = new Shape();
		private var topcont:Sprite = new Sprite();
		private var reftcont:Sprite = new Sprite();
		private var sumcont:Sprite = new Sprite();
		public function PicProjection():void
		{
			init();
		}
		private function init():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,com);
//			loader.load(new URLRequest("http://files.cnblogs.com/zhoujunfeng2011/Pictures/http_imgloadCA7PGMNR.jpg"));
			loader.load(new URLRequest("../images/20171117085212.jpg"));
		}
		private function com(evt:Event):void
		{
			var loader:Loader = Loader(evt.target.loader);
			var image:Bitmap = Bitmap(loader.content);
			var toppic:Bitmap = new Bitmap(image.bitmapData);
			var reftpic:Bitmap = new Bitmap(image.bitmapData);
			addChild(sumcont);
			topcont.addChild(toppic);
			toppic.x =  -  picw / 2;
			toppic.y =  -  pich / 2;
			reftcont.addChild(reftpic);
			reftpic.x =  -  picw / 2;
			reftpic.y =  -  pich / 2;
			reftcont.rotationX = 180;
			sumcont.addChild(topcont);
			topcont.x = 0;
			topcont.y = pich / 2;
			topcont.z = 500;
			sumcont.addChild(reftcont);
			reftcont.x = reftcont.y;
			reftcont.y = topcont.y + pich + gap;
//			reftcont.y = topcont.y + gap;
			reftcont.z = 500;
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.fieldOfView = 55;
//			pp.fieldOfView = 85;
			pp.projectionCenter = new Point(picw/2,pich/2);
			sumcont.transform.perspectiveProjection = pp;
			sumcont.x = 600;
			sumcont.y = 180;
			reftcont.addChild(maskshape);
			maskshape.x = reftpic.x;
			maskshape.y = reftpic.y;
			drawInMask();
			reftpic.cacheAsBitmap = true;
			maskshape.cacheAsBitmap = true;
			reftpic.mask = maskshape;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseover);
			stage.addEventListener(Event.MOUSE_LEAVE,mouseout);
			sumcont.addEventListener(Event.ENTER_FRAME,onFrameHandler);
			
			sumcont.scaleX = topcont.scaleY = 2.0;
			
//			topcont.rotationY = 50;
			topcont.rotationX = 37;
			topcont.rotationZ = 17;
			
			
		}
		private function drawInMask():void
		{
			var FillType:String = GradientType.LINEAR;
			var mat:Matrix = new Matrix();
			var colors:Array = [0xff0000,0xff0000];
			var alphas:Array = [0,0.5];
			var ratios:Array = [5,255];
			mat.createGradientBox(picw,pich,90*(Math.PI/180));
			maskshape.graphics.lineStyle();
			maskshape.graphics.beginGradientFill(FillType,colors,alphas,ratios,mat);
			maskshape.graphics.drawRect(0,0,picw,pich);
			maskshape.graphics.endFill();
		}
		private function mouseover(evt:MouseEvent):void
		{
			stage.addEventListener(Event.ENTER_FRAME,OnEnter);
		}
		private function mouseout(evt:Event):void
		{
			stage.removeEventListener(Event.ENTER_FRAME,OnEnter);
			speeds = 0.3;
		}
		private function OnEnter(evt:Event):void
		{
			speeds = (this.mouseX - this.stage.stageWidth/2)/40;
		}
		private function onFrameHandler(evt:Event):void
		{
			topcont.rotationY +=  speeds;
			reftcont.rotationY +=  speeds;
		}
	}
}
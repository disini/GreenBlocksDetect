package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Security;
	
	/**
	 * 
	 * @author LiuSheng  QQ:532230294
	 * 创建时间 : 2018-3-20 上午9:38:59
	 *
	 */
	[SWF(width="1920", height = "1080", backgroundColor = "0xff6600", frameRate="60")]
	public class GreenBlocksDetect extends Sprite
	{
		
		[Embed(source="../images/20171117085212.jpg")]
		private var Pic1:Class;
		
		private var pic1Bmp1:Bitmap;
		private var pic1MC1:Sprite;
		
		
		[Embed(source="../images/20180320160537.png")]
//		[Embed(source="../images/20180620114517.png")]
//		[Embed(source="../images/QQ图片20180322145556.png")]
		private var Pic2:Class;
		
		private var pic2Bmp1:Bitmap;
		private var pic2MC1:Sprite;
		
		private var picProjectionBmp1:Bitmap;
		
		private var vertices:Vector.<Number> = new Vector.<Number>;
		private var indices:Vector.<int> = new Vector.<int>;
		private var uvdata:Vector.<Number> = new Vector.<Number>;
		
		
		private var pasteSprite:Sprite = new Sprite();
		
		private var pasteBmp:Bitmap = new Bitmap(null, "always", true);
		
		
		private var areaRect:Rectangle;
		
		private var areaRectMc:Sprite;
		
		private var point1:Point = new Point();
		private var point2:Point = new Point();
		private var point3:Point = new Point();
		private var point4:Point = new Point();
		
		//		private var pointMC1:Sprite = new Sprite();
		//		private var pointMC2:Sprite = new Sprite();
		//		private var pointMC3:Sprite = new Sprite();
		//		private var pointMC4:Sprite = new Sprite();
		
		
		
		private var pointsMC:Sprite;
		
		public function GreenBlocksDetect()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
			
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;// 保持各元件不被缩放，不失真；默认值为showAll
			trace(stage.align);
			stage.align = StageAlign.TOP_LEFT;// 默认值为空""
			
			initUVandIndices();
			initPics();
			initAreaRect();
			initPointsMCLayer();
//			project();
			checkColor(pic2Bmp1.bitmapData);
			
		}		
		
		private function initPointsMCLayer():void
		{
			// TODO Auto Generated method stub
			pointsMC = new Sprite();
			stage.addChild(pointsMC);
//			for(var i:int=0; i < 4;i++)
//			{
//				pointsMCLayer.addChild(this["pointMC" + (i + 1)]);
//			}
		}
		private function initAreaRect():void
		{
			// TODO Auto Generated method stub
			areaRectMc = new Sprite();
			stage.addChild(areaRectMc);
		}
		
		
		
		private function initUVandIndices():void
		{
			// TODO Auto Generated method stub
			uvdata.push(0, 0);
			uvdata.push(1, 0);
			uvdata.push(1, 1);
			uvdata.push(0, 1);
			
			indices.push(0, 1, 2);
			indices.push(2, 3, 0);
		}
		
		protected function onRemovedFromStage(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		private function initPics():void
		{
			// TODO Auto Generated method stub
//			pic1MC1 = new Pic1()  as Bitmap;
//			pic1MC1 = new Bitmap((new Pic1()).bitmapData);
//			pic1MC1.x = (stage.stageWidth - pic1MC1.width) / 2;
			
			
			/*pic1MC1 = new Bitmap((new Pic1()).bitmapData, PixelSnapping.ALWAYS, true);
			pic1MC1.x = 200;
			pic1MC1.y = (stage.stageHeight- pic1MC1.height) / 2;
			pic1MC1.rotation = 75;
			addChild(pic1MC1);*/
			
			pic2MC1 = new Sprite();
			addChild(pic2MC1);
			pic2Bmp1 = new Bitmap((new Pic2()).bitmapData, PixelSnapping.ALWAYS, true);
			pic2Bmp1.name = "pic2Bmp1";
			//			pic1MC1.x = (stage.stageWidth - pic1MC1.width) / 2;
//			pic2MC1.x = 200;
//			pic2MC1.y = (stage.stageHeight- pic2MC1.height) / 2;
//			pic2MC1.rotation = 75;
			pic2MC1.addChild(pic2Bmp1);
			pic2MC1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHdler);
			
//			pic2MC1.scaleX = pic2MC1.scaleY = 0.3;
//			pic2MC1.alpha = 0.1;
			
			
//			pasteSprite.x = pic1MC1.x + 300;
//			pasteSprite.y = pasteSprite.y;
//			addChild(pasteSprite);
			
//			pasteBmp.x = pic1MC1.x + 300;
//			pasteBmp.y = pasteBmp.y;
//			addChild(pasteBmp);
		}
		
		protected function onMouseMoveHdler(evt:Event):void
		{
			// TODO Auto-generated method stub
//			var pt:Point = (evt.target as Bitmap).localToGlobal(
			var pt:Point = new Point(evt.target.mouseX, evt.target.mouseY);
			var bmp:Bitmap = (evt.target as Sprite).getChildByName("pic2Bmp1") as Bitmap;
			var color:uint = bmp.bitmapData.getPixel32(pt.x, pt.y);
			var colorStr:String = color.toString(16);
			trace("x : " + pt.x + ", y : " + pt.y + ", color = " + colorStr);
		}
		
		public function drawPic(bmpData:BitmapData, points:Array):void
		{
			vertices.length = 0;
			for(var i:int = 0; i < 4; i++)
			{
				vertices.push(points[i].x, points[i].y);
			}
				pasteSprite.graphics.clear();
				pasteSprite.graphics.beginBitmapFill(bmpData);
				pasteSprite.graphics.drawTriangles(vertices, indices, uvdata);
				pasteSprite.graphics.endFill();
			
		}
		
		
		private function project():void
		{
			// TODO Auto Generated method stub
			var pt1:Point = new Point(210, 15);
			var pt2:Point = new Point(410, 165);
			var pt3:Point = new Point(110, 305);
			var pt4:Point = new Point(10, 205);
			var ptArr:Array = [];
			ptArr.push(pt1, pt2, pt3, pt4);
			drawPic(pic1Bmp1.bitmapData, ptArr);
			
//			pasteSprite.scale9Grid
			pasteSprite.scaleX = pasteSprite.scaleY = 1.5;
			
//			var bmd:BitmapData = new BitmapData(pasteSprite.width, pasteSprite.height, true, 0);
//			bmd.draw(pasteSprite, null, null, null, null, true);
			
			
//			var 
//			pasteBmp.bitmapData = bmd;
		}
		
		private function checkColor(snapShotBmd:BitmapData):Array
		{
			//			level = 8;
			//			div = 256 / level;
			//			for (var i = 0; i < 256; i++)
			//			{
			//				for 
			//			}
			
//			areaRect = snapShotBmd.getColorBoundsRect(0xFF00BC00, 0xFF00BC00);
//			areaRect = snapShotBmd.getColorBoundsRect(0xFFFFFFFF, 0xFF00BC00);
//			snapShotBmd.floodFill(areaRect.x + 5, areaRect.y + 5, 0xff00fff0);
			var rect:Rectangle = snapShotBmd.getColorBoundsRect(0xFFFFFFFF, 0xFF00BC00);
//			var rect:Rectangle = snapShotBmd.getColorBoundsRect(0xFFFFFFFF, 0xFF000000);
//			var rect:Rectangle = snapShotBmd.getColorBoundsRect(0xFFFFFFFF, 0x00000000);
//			areaRect = snapShotBmd.getColorBoundsRect(0xff00bc00,  0xff00bc00);
//			areaRect = snapShotBmd.getColorBoundsRect(0xff00bc00,  0xff00bc00);
			
			areaRect = new Rectangle(rect.x - 4, rect.y - 4, rect.width + 8, rect.height + 8);
//			areaRect = new Rectangle(rect.x + 10, rect.y + 10, rect.width - 20, rect.height - 20);
			
			areaRectMc.graphics.clear();
			areaRectMc.graphics.lineStyle(1, 0xffff6600);
			areaRectMc.graphics.drawRect(areaRect.left, areaRect.top, areaRect.width, areaRect.height);
//			areaRectMc.graphics.drawRect(areaRect.left - 1, areaRect.top - 1, areaRect.width + 1, areaRect.height + 1);
//			areaRectMc.graphics.drawRect(areaRect.left - 3, areaRect.top - 3, areaRect.width + 6, areaRect.height + 6);
			
//			point1.x = findPoint(snapShotBmd, areaRect.x, areaRect.y, 0xFF00BC00, true, true);// 固定y(上边)，自左向右找x;  UV(0, 0)
//			point1.y = areaRect.y;
//			
//			point2.x = areaRect.x;
//			point2.y = findPoint(snapShotBmd, areaRect.x, areaRect.y, 0xFF00BC00, false, true);// 固定x(左边)，自上向下找y
//			
//			point3.x = findPoint(snapShotBmd, areaRect.x + areaRect.width, areaRect.y + areaRect.height, 0xFF00BC00, true, false);// 固定y(下边)，自右向左找x
//			point3.y = areaRect.y + areaRect.height;
//			
//			point4.x = areaRect.x + areaRect.width;
//			point4.y = findPoint(snapShotBmd, areaRect.x + areaRect.width, areaRect.y + areaRect.height, 0xFF00BC00, false, false);// 固定x(右边)，自下向上找y
			
//			point1 = findVertex(snapShotBmd, areaRect, 0);
//			point2 = findVertex(snapShotBmd, areaRect, 1);
//			point3 = findVertex(snapShotBmd, areaRect, 2);
//			point4 = findVertex(snapShotBmd, areaRect, 3);
			
			// 找到绿块的四个顶点的坐标
			var pt1:Point = findVertex(snapShotBmd, areaRect, 0);
			var pt2:Point = findVertex(snapShotBmd, areaRect, 1);
			var pt3:Point = findVertex(snapShotBmd, areaRect, 2);
			var pt4:Point = findVertex(snapShotBmd, areaRect, 3);
			
			// 不扩大
			/*var ptOffSet1:Point = new Point(0, 0);
			var ptOffSet2:Point = new Point(0, 0);
			var ptOffSet3:Point = new Point(0, 0);
			var ptOffSet4:Point = new Point(0, 0);*/
			
			// 因为绿块边缘颜色有变化，所以加一个向外扩大的偏移值
			var ptOffSet1:Point = new Point(-8, -8);
			var ptOffSet2:Point = new Point(8, -8);
			var ptOffSet3:Point = new Point(8, 8);
			var ptOffSet4:Point = new Point(-8, 8);
			
//			point1 = findVertex(snapShotBmd, areaRect, 0) + Point(-5, -5);
//			point2 = findVertex(snapShotBmd, areaRect, 1) + Point(5, -5);
//			point3 = findVertex(snapShotBmd, areaRect, 2) + Point(5, 5);
//			point4 = findVertex(snapShotBmd, areaRect, 3) + Point(-5, 5);
			
//			point1 = findVertex(snapShotBmd, areaRect, 0) + ptOffSet1;
//			point2 = findVertex(snapShotBmd, areaRect, 1) + ptOffSet2;
//			point3 = findVertex(snapShotBmd, areaRect, 2) + ptOffSet3;
//			point4 = findVertex(snapShotBmd, areaRect, 3) + ptOffSet4;
			
//			point1 = new Point(pt1.x -5
			point1 = pt1.add(ptOffSet1);
			point2 = pt2.add(ptOffSet2);
			point3 = pt3.add(ptOffSet3);
			point4 = pt4.add(ptOffSet4);
			
			trace("point1 : (" + point1.x + ", " + point1.y + ") , " + "point2 : (" + point2.x + ", " + point2.y + ") , " + "point3 : (" + point3.x + ", " + point3.y + ") , " + "point4 : (" + point4.x + ", " + point4.y + ")");
			var array:Array = [point1, point2, point3, point4];
			
//			for(var i:int = 0; i < array.length;i++)
//			{
//				drawPointWithCircle(array[i]);
//			}
			drawPointWithCircle(array);
			
			return array;
			
		}
		
		/**
		 * 画出绿块区域的4个顶点 
		 * @param arr
		 * 
		 */		
//		private function drawPointWithCircle(pt:Point):void
		private function drawPointWithCircle(arr:Array):void
		{
			var pt:Point;
			pointsMC.graphics.clear();
			areaRectMc.graphics.lineStyle(2, 0xffffffff);
			areaRectMc.graphics.moveTo(arr[3].x, arr[3].y);
			
			for(var i:int=0; i < 4;i++)
			{
				pt = arr[i] as Point;
//				(this["pointMC" + (i + 1)] as Sprite).graphics.clear();
//				(this["pointMC" + (i + 1)] as Sprite).graphics.beginFill(0x0000ff);
//				(this["pointMC" + (i + 1)] as Sprite).graphics.drawCircle(pt.x, pt.y, 2);
//				(this["pointMC" + (i + 1)] as Sprite).graphics.endFill();
				
//				pointsMC.graphics.beginFill(0x0000ff);
//				pointsMC.graphics.beginFill(0xffffff, Number(i + 1)/4);
				pointsMC.graphics.beginFill(0xff0000);
//				pointsMC.graphics.beginFill(256 * (Number(i + 1)/4) << 16);
				pointsMC.graphics.drawCircle(pt.x, pt.y, 2);
				pointsMC.graphics.endFill();
//				areaRectMc.graphics.lineStyle(6);
//				areaRectMc.graphics.lineStyle(6, 0xffffff);
				areaRectMc.graphics.lineTo(arr[i].x, arr[i].y);
			}
			
		}
		
		
		private function findPoint1(bmpdata:BitmapData, startx:Number, starty:Number, color:uint, xory:Boolean, lefttoright:Boolean):Number
		{
			var m:int;
//			var returnNum:Number;
			if(xory)// 沿X轴搜索
			{
				if(lefttoright)// 自左向右
				{
					for (m = startx; m < areaRect.x + areaRect.width;m++)
					{
//						var testColor:uint = bmpdata.getPixel32(m, starty);
//						{
//							if(Math.abs(testColor - color) < 5)
//							{
//								trace("bingo!");
////								return m;
//							}
//						}
						if(bmpdata.getPixel32(m, starty).toString(16) == color.toString(16))
						{
							return m;
						}
					}
				}
				else// 自右向左
				{
					for(m = startx; m >areaRect.left; m--)
					{
						if(bmpdata.getPixel32(m, starty).toString(16) == color.toString(16))
						{
							return m;
						}
					}
				}
			}
			else// 沿Y轴搜索
			{
				if (lefttoright)// 自上向下
				{
					for (m = starty; m < areaRect.y + areaRect.height; m++)
					{
						if (bmpdata.getPixel32(startx, m).toString(16) == color.toString(16))
						{
							return m;
						}
					}
				}
				else// 自下向上
				{
					for (m = starty; m > areaRect.top; m--)
					{
						if (bmpdata.getPixel32(startx, m).toString(16) == color.toString(16))
						{
							return m;
						}
					}
				}
			}
			return 0;
		}

		private function findPoint(bmpdata:BitmapData,startx:Number,starty:Number,color:uint,xory:Boolean,lefttoright:Boolean):Number
		{
			var m:int;
			var returnnum:Number;
			if (xory)
			{//延x轴搜索
				if (lefttoright)
				{
					for (m = startx; m<1000; m++)
					{
						if (bmpdata.getPixel32(m,starty).toString(16) == color.toString(16))
						{
							returnnum = m;
							return returnnum;
						}
					}
				}
				else
				{
					for (m = startx; m>0; m--)
					{
						if (bmpdata.getPixel32(m,starty).toString(16) == color.toString(16))
						{
							returnnum = m;
							return returnnum;
						}
					}
				}
			}
			else
			{
				if (lefttoright)
				{
					for (m = starty; m<1000; m++)
					{
						if (bmpdata.getPixel32(startx,m).toString(16) == color.toString(16))
						{
							returnnum = m;
							return returnnum;
						}
					}
				}
				else
				{
					for (m = starty; m>0; m--)
					{
						if (bmpdata.getPixel32(startx,m).toString(16) == color.toString(16))
						{
							returnnum = m;
							return returnnum;
						}
					}
				}
			}
			return 0;
		}
		
		/**
		 *  在某一个顶点的直角的两条边之间遍历每个像素点，来寻找指定的颜色值（绿色）
		 * @param bmpdata
		 * @param location 方位（象限）（0：topLeft; 1 : topRight; 2 : bottomRight； 3：bottomLeft）
		 * @return 
		 * 
		 */		
		public function findVertex(bmpdata:BitmapData, rect:Rectangle, location:int):Point
		{
//			var startPt:Point = new Point();
//			var endPt:Point = new Point();
			const LIMIT_RATIO:Number = 0.6;
			var originR_SQ:Number = Math.pow(rect.width/2, 2) + Math.pow(rect.height/2, 2);
			var originR:Number = Math.sqrt(originR_SQ);
//			var 
			var locX:int = 0;
			var locY:int = 0;
			var targetColor:uint = 0xFF00BC00;
			var hasFound:Boolean = false;
			var r:Number = 0;
			var rSQ:Number = 0;
			var targetX:Number = 0;
			var targetY:Number = 0;
			var resultPoint:Point = new Point();
			// 四个象限对应的四组系数值
			var quadCoeArr:Array = [[-1,-1, 0], [0, -1, 1], [0, 1, 1], [-1, 1, 0]];// 起始点x坐标正负，终点y坐标正负，locX终点值与r的关系系数
			
			/*switch(location)
			{
				case 0:
				{
//					startPt.x = -rect.width / 2;
//					startPt.y = 0;
//					endPt.x = 0;
//					endPt.y = -rect.height / 2;
					for (r = originR; r >= originR * LIMIT_RATIO;r--)
//						for(locX = startPt.x; locX <= -rect.width * LIMIT_RATIO;locX++)
					{
						rSQ = Math.pow(r, 2);
						
						for(locX = -rect.width / 2; locX <= 0; locX++)
						{
	//						for(locY = startPt.y;locY<= -rect.height * LIMIT_RATIO; locY++)
							locY = -Math.sqrt(rSQ - Math.pow(locX, 2));
							if(locY < -rect.height / 2 || locY >  rect.height / 2)
								break;
							targetX = locX + rect.x + rect.width/2;
							targetY = locY + rect.y + rect.height/2;
							hasFound = checkPixColor(bmpdata, targetX, targetY, targetColor);
							//							pointsMC.graphics.beginFill(0xffff0000);
							//							pointsMC.graphics.drawCircle(targetX, targetY, 2);
							//							pointsMC.graphics.endFill();
							
							//							trace("cur R : " + r + ", cur X : " + locX + ", cur Y : " + locY);
							trace("cur R : " + r + ", cur X : " + targetX + ", cur Y : " + targetY);
							
							bmpdata.setPixel32(targetX, targetY, 0xffffffff);
							if(hasFound)
							{
								resultPoint = new Point(targetX, targetY);
								return resultPoint;
							}
						}
					}
					break;
				}
					
				case 1:
				{
					for (r = originR; r >= originR * LIMIT_RATIO;r--)
					{
						rSQ = Math.pow(r, 2);
						
						for(locX = -rect.width / 2; locX <= 0; locX++)
						{
							//						for(locY = startPt.y;locY<= -rect.height * LIMIT_RATIO; locY++)
							locY = -Math.sqrt(rSQ - Math.pow(locX, 2));
							if(locY < -rect.height / 2 || locY >  rect.height / 2)
								break;
							targetX = locX + rect.x + rect.width/2;
							targetY = locY + rect.y + rect.height/2;
							hasFound = checkPixColor(bmpdata, targetX, targetY, targetColor);
							//							pointsMC.graphics.beginFill(0xffff0000);
							//							pointsMC.graphics.drawCircle(targetX, targetY, 2);
							//							pointsMC.graphics.endFill();
							
							//							trace("cur R : " + r + ", cur X : " + locX + ", cur Y : " + locY);
							trace("cur R : " + r + ", cur X : " + targetX + ", cur Y : " + targetY);
							
							bmpdata.setPixel32(targetX, targetY, 0xffffffff);
							if(hasFound)
							{
								resultPoint = new Point(targetX, targetY);
								return resultPoint;
							}
						}
					}
					break;
				}
					
				default:
				{
					break;
				}
//				return new Point(0, 0);
			}*/
			
			
			for (r = originR; r >= originR * LIMIT_RATIO;r--)
				//						for(locX = startPt.x; locX <= -rect.width * LIMIT_RATIO;locX++)
			{
				rSQ = Math.pow(r, 2);
				
//				for(locX = quadCoeArr[location][0] * r; locX <= quadCoeArr[location][2] * r; locX++)
				for(locX = quadCoeArr[location][0] * rect.width / 2; locX <= quadCoeArr[location][2] * rect.width / 2; locX++)
				{
					//						for(locY = startPt.y;locY<= -rect.height * LIMIT_RATIO; locY++)
					locY = quadCoeArr[location][1] * Math.sqrt(rSQ - Math.pow(locX, 2));
					if(locY < -rect.height / 2 || locY >  rect.height / 2)
//						break;
						continue;
					
					targetX = locX + rect.x + rect.width/2;
					targetY = locY + rect.y + rect.height/2;
					hasFound = checkPixColor(bmpdata, targetX, targetY, targetColor);
					//							pointsMC.graphics.beginFill(0xffff0000);
					//							pointsMC.graphics.drawCircle(targetX, targetY, 2);
					//							pointsMC.graphics.endFill();
					
					//							trace("cur R : " + r + ", cur X : " + locX + ", cur Y : " + locY);
//					trace("cur R : " + r + ", cur X : " + targetX + ", cur Y : " + targetY);
					
					bmpdata.setPixel32(targetX, targetY, 0xffffffff);// 把点画出来，可以描出遍历的轨迹
					if(hasFound)
					{
						resultPoint = new Point(targetX, targetY);
						return resultPoint;
					}
				}
			}
//			return new Point(0, 0);
			return resultPoint;
		}
		
		private function checkPixColor(bmpdata:BitmapData, locX:int, locY:int, targetColor:uint):Boolean
		{
			var color:uint = bmpdata.getPixel32(locX, locY);
			if(color == targetColor)
			{
				return true;
			}
			
			return false;
		}		
		
	}
}
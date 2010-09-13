package ddgame.client.triggers {
	
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.geom.Rectangle;
//	import flash.geom.Point;
//	import flash.utils.ByteArray;
//	import flash.utils.Endian;
//	import flash.geom.ColorTransform;
//	import flash.filters.ColorMatrixFilter;
	import flash.display.DisplayObject;
//	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Loader;
	
	import ddgame.client.triggers.AbstractTrigger;
	import ddgame.client.view.IsosceneHelper;
	import ddgame.view.UIHelper;
	
	import gs.TweenMax;
	import gs.easing.*
	import gs.plugins.*;
	
	/**
	 *	Trigger mini jeu
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class MiniGameTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 11;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		// helper isoscene
		private var isosceneHelper:IsosceneHelper;
		// loader du jeu
		private var gameLoader:Loader;
		// fond du jeu
		private var bgGame:Sprite;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/* Test effet pixels raté
		public function get fxRestFrame () : int
		{
			return _fxTotalFrame - _fxFrame;
		}
		
		public function get fxFrame () : int
		{
			return _fxFrame;
		}
		
		public function set fxFrame (val:int) : void
		{
			if (val > _fxTotalFrame) return;
			
			var bmp:BitmapData = bgGame.bitmapData;
			
//			bmp.lock();
			var pix:Object;			
			var nf:int = val - _fxFrame;
			var ind:int;
//			pixelsList.reverse();
			while (--nf > -1)
			{
//				ind = Math.random() * pixelsList.length;
//				pix = pixelsList[ind];
				pix = pixelsList.shift();
//				pix = tmp[nf];
				bmp.setPixel32( pix.x, pix.y, pix.v );
//				pixelsList.splice(ind, 1);
			}
			_fxFrame = val;
			bmp.unlock();
			return;
		}
		*/
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function execute (event:Event = null) : void
		{
			// recup de du helper isoscene
			isosceneHelper = facade.getObserver(IsosceneHelper.NAME) as IsosceneHelper;
			
			// TODO check des paramètres / options passés à ce trigger
			
			// freeze
			isosceneHelper.freezeScene();			
			// affichage fond du jeu
			drawDefaultGameBackground();
			// chargement du jeu
			loadGame();
			
			// -------------------------------
//			var area:Rectangle = new Rectangle(0, 0, sWidth, sHeight);
			/*bgGame = new Bitmap();
			bgGame.x = UIHelper.VIEWPORT_AREA.x;
			bgGame.y = UIHelper.VIEWPORT_AREA.y;*/
			
//			TweenMax.to(scene, 2, {colorMatrixFilter:{colorize:0xffccff, amount:1}, ease:Back.easeInOut});
//			return;

//			bgGame.bitmapData = srcBmp;
			
//			var matrix:Array = [0.37774,0.54846,0.0738,0,100,0.27774,0.64846,0.0738,0,100,0.27774,0.54846,0.1738,0,100,0,0,0,1,0]
//			var cfilter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
//			srcBmp.applyFilter(srcBmp, area, new Point(0,0), cfilter);
			
//			pixels = srcBmp.getPixels(area);
//			pixels.position = 0;
			
			// stockage des pixels
//			pixelsList = [];
//			var n:int = pixels.length / 4;
			
			
//			sHeight = sWidth = 2;
			/*for ( var i:int = 0; i < sHeight ; i++ )
			{
				for ( var j:int = 0; j < sWidth; j++ )
				{
					pixelsList.push({x:j, y:i, v:pixels.readUnsignedInt()});
				}
			} */
			
			/*while (--n > -1)
			{
				ob = {x:840,}
				pixelsList.push(pixels.readUnsignedInt());
			}
			
			n = pixelsList.length;*/
			
			/*n = pixelsList.length;
			var rn:int;
			var el:uint;
			var temp:Array = [];*/
			
			/*while (pixelsList.length > 0)
			{
				rn = Math.floor(Math.random() * pixelsList.length);
				temp.push(pixelsList[rn]);
				pixelsList.splice(rn, 1);
			}*/
			
//			pixelsList = temp;
			
//			pixelsList.sort(tri);
			/*for (i = 0; i < n; i++) {
				el = pixelsList[i];
				pixelsList[i] = pixelsList[rn = Math.random() * n];
				pixelsList[rn] = el;
			}*/
			
//			return;
//			pixels.endian = Endian.LITTLE_ENDIAN;

			
//			var copyBmp:BitmapData = new BitmapData(sWidth, sHeight, true, 0x00000000);
			
			/*for( var i:uint = 0; i < sHeight / 2 ; i++ )
			{
				trace(pixels.readUnsignedInt());
//			  for( var j:uint = 0; j < sWidth / 2; j++ )
//			  {
//			    copyBmp.setPixel( j, i, pixels.readUnsignedInt() );
//			  }
			}*/
			
			/*for( var i:uint = 0; i < sHeight ; i++ )
			{
			  for( var j:uint = 0; j < sWidth; j++ )
			  {
			    copyBmp.setPixel( j, i, pixels.readUnsignedInt() );
			  }
			}*/
			

//			bgGame.bitmapData = copyBmp;

//			stage.addEventListener(Event.ENTER_FRAME, handleFx);
//			fxPos = new Point(-1, 0);
//			_fxTotalFrame = sWidth * sHeight;  
//			TweenMax.to(this, 5, {fxFrame:_fxTotalFrame});

//			TweenMax.from(bgGame, 3, {delay:1, tint:0xFFFFFF});
		}

/*		
		private function tri (a:Number, b:Number):Number {
			return Math.random();
		}
		
		private function handleFx (e:Event) : void
		{
			var t:int = getTimer();
			var c:int = pixelsList.length < 2000 ? pixelsList.length : 2000;
			var bmp:BitmapData = bgGame.bitmapData;
			var ind:int;
			var pix:Object;
			while (--c > -1)
			{
				ind = Math.random() * pixelsList.length;
				pix = pixelsList[ind];
//				pix = pixelsList.shift();
//				pix = tmp[nf];
				bmp.setPixel32( pix.x, pix.y, pix.v );
//				pixelsList.splice(ind, 1);
			}
			trace(t - getTimer());
			if (pixelsList.length == 0)
				stage.removeEventListener(Event.ENTER_FRAME, handleFx);
		}
*/
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 * Affichage fond par défaut du mini-jeu
		 * Reprise de la scène en cours avec un effet de couleur
		 */
		private function drawDefaultGameBackground () : void
		{
			// recup de la scène
			var scene:DisplayObject = isosceneHelper.component;
			// dimensions de la scène
			var sWidth:int = UIHelper.VIEWPORT_AREA.width;
			var sHeight:int = UIHelper.VIEWPORT_AREA.height;
			
			// mise en place du fond du jeu (reprise de la scène en cours
			// avec un effet dessus)
			bgGame = new Sprite();
			bgGame.x = UIHelper.VIEWPORT_AREA.x;
			bgGame.y = UIHelper.VIEWPORT_AREA.y;			

			var srcBmp:BitmapData = new BitmapData(sWidth, sHeight);			
			srcBmp.draw(scene);			
			bgGame.graphics.beginBitmapFill(srcBmp);
			bgGame.graphics.drawRect(0, 0, sWidth, sHeight);
			bgGame.graphics.endFill();
				
			stage.addChild(bgGame);
			
			// effet
			TweenMax.to(bgGame, 2, {colorMatrixFilter:{colorize:0xffccff, amount:1}, ease:Back.easeInOut});
		}
		
		/**
		 *	@private
		 * Lance le chragement du jeu
		 * Aucune vérif n'est faite sur les paramètres étant
		 * entendu que celle-ci est effectuée par la méthode execute()
		 */
		private function loadGame () : void
		{
			gameLoader = new Loader();
			
		}
	
	}

}
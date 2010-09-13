package ddgame.client.view.components {

	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import ddgame.client.view.components.ContextMenuItem;
	import com.sos21.debug.log;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ContextMenu extends Sprite {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function ContextMenu(_parent:DisplayObjectContainer)
		{
			if (instance != null)
				instance.remove();
				
			draw();
			x = _parent.mouseX - skin.scale9Grid.x;
			y = _parent.mouseY - skin.scale9Grid.y;
			_parent.addChild(this);
			createEventListeners();
			instance = this;
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		[Embed(source = "/ddgame/assets/ContextMenu.swf", symbol="ContextMenuSkin")]
		private var skinAsset:Class;
		private var skin:Sprite;
		private var menuItemList:Array = [];
		private static var instance:ContextMenu;
//		private var firstOpen:Boolean = true;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function pushMenuItem(menuItem:Sprite):void
		{
			menuItemList.push(menuItem);
			redraw();
		}
		
		public function remove():void
		{
			stage.removeEventListener(MouseEvent.CLICK, mouseHandler);
			trace(this,menuItemList);
			var l:int = menuItemList.length;
			for (var i:int = 0; i < l; i++)
			{
				var mi:ContextMenuItem = ContextMenuItem(menuItemList[i]);
				removeChild(mi);
			}
			menuItemList = null;
			removeChild(skin);
			skin = null;
			parent.removeChild(this);
			instance = null;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function mouseHandler(event:MouseEvent):void
		{
			if (!getBounds(parent).containsPoint(new Point(parent.mouseX, parent.mouseY))) {
				dispatchEvent(new Event(Event.CLOSE));
				event.preventDefault();
				remove();
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function createEventListeners():void
		{
			stage.addEventListener(MouseEvent.CLICK, mouseHandler, false, 500);
		}
		
		private function draw():void
		{
			skin = new skinAsset() as Sprite;
			addChild(skin);
		}
		
		private function redraw():void
		{
			var ta:Array = menuItemList.concat();
			ta.sortOn("width", Array.DESCENDING | Array.NUMERIC);
			var fitWidth:Number = Sprite(ta[0]).width;
			var l:int = menuItemList.length;
			var ofsy:Number = skin.scale9Grid.y;
			var ofsx:Number = skin.scale9Grid.x;
			for (var i:int = 0; i < l; i++)
			{
				var mi:ContextMenuItem = ContextMenuItem(menuItemList[i]);
				mi.width = fitWidth;
				mi.x = ofsx;
				mi.y = ofsy;
				ofsy += mi.height;
				addChild(mi);
			}
			skin.width = skin.scale9Grid.x * 2 + fitWidth;
			skin.height = skin.scale9Grid.y + ofsy;
			// placement
			if (this.parent.stage)
			{
				// hauteur
				var maxy:int = this.parent.stage.stageHeight;
				var myy:int = this.y + this.height;
				if (myy > maxy) this.y = maxy - this.height;
				// largeur
				var maxx:int = this.parent.stage.stageWidth;
				var myx:int = this.x + this.width;
				if (myx > maxx) this.x = this.parent.mouseX - this.width + this.skin.scale9Grid.x;
			}
		}
		
	}
	
}




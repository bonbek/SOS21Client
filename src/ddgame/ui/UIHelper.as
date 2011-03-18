package ddgame.ui {
	
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.Font;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import com.sos21.helper.AbstractHelper;
	import com.sos21.events.BaseEvent;
	import com.sos21.proxy.ConfigProxy;
	
	import ddgame.helper.HelperList;
	import ddgame.events.EventList;
	import ddgame.display.ui.IUI;
	import ddgame.display.ui.IUIButton;
	import ddgame.display.ui.UIEvent;
	import ddgame.proxy.PlayerProxy;
	import ddgame.proxy.DatamapProxy;
	import ddgame.sound.AudioHelper;
	
	import ddgame.vo.IBonus;
	import ddgame.scene.IsosceneHelper;

	import gs.TweenMax;
	import gs.easing.*;

	/**
	 *	Helper interface utilisateur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class UIHelper extends AbstractHelper {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = HelperList.UI_HELPER;
		public static const VIEWPORT_AREA:Rectangle = new Rectangle(70, 25, 840, 480);

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function UIHelper (component:Object = null)
		{
			super(NAME, component);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Composant casté
		 */
		public function get component () : Object
		{
			return _component;
		}

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/*public function displayAppVersion () : void
		{
			var tf:TextField = TextField(component.getChildByName("appVersionTextField"));
			tf.text = ConfigProxy.getInstance().getContent("app_version");
		}*/
		
		/**
		 * Crée une fenêtre
		 *	@param addToStage Boolean place qur stage
		 *	@param center Boolean centre la fenêtre
		 *	@return Object le fenêtre
		 */
		public function createWindow (addToStage:Boolean = true) : Object
		{
			var wdw:Object = component.createWindow();
			if (addToStage) addWindow(wdw);

			return wdw;
		}
		
		/**
		 * Supprime une fenêtre
		 *	@param wdw Object
		 */
		public function removeWindow (wdw:Object) : void
		{
			var dob:DisplayObject = wdw as DisplayObject;
			if (stage.contains(dob)) stage.removeChild(dob);
		}
		
		/**
		 * Affiche un fenêtre
		 *	@param wdw Object
		 *	@param center Boolean
		 *	@param animate Boolean
		 */
		public function addWindow (wdw:Object, center:Boolean = true, animate:Boolean = true) : void
		{
			var dob:DisplayObject = wdw as DisplayObject;
			if (center) centerWindow(wdw);
			stage.addChild(dob);

			if (animate)
			{
				var rand:int = Math.random() * 3;
				var ofs:int = 40;
				dob.alpha = 0;
				switch (rand)
				{
					case 0 :
						dob.x -= ofs;
						TweenMax.to(dob, 0.4, {alpha:1, x:dob.x + ofs, ease:Back.easeOut});
						break;
					case 1 :
						dob.y += ofs;
						TweenMax.to(dob, 0.4, {alpha:1, y:dob.y - ofs, ease:Back.easeOut});
						break;
					case 2 :
						dob.x += ofs;
						TweenMax.to(dob, 0.4, {alpha:1, x:dob.x - ofs, ease:Back.easeOut});
						break;
					case 3 :
						dob.y -= ofs;
						TweenMax.to(dob, 0.4, {alpha:1, y:dob.y + ofs, ease:Back.easeOut});
						break;
				}
			}
		}
		
		/**
		 * Centre une fenêtre ou un DisplayObject dans
		 * la zone jeu
		 *	@param wdw Object
		 */
		public function centerWindow (wdw:Object) : void
		{
			var w:int = wdw.width;
			var h:int = wdw.height;
			wdw.x = (VIEWPORT_AREA.width - w) / 2 + VIEWPORT_AREA.x;
			wdw.y = (VIEWPORT_AREA.height - h) / 2 + VIEWPORT_AREA.y;
		}
		
		/**
		 *	Rafraîchit l'affichage du nom d'utilisateur
		 */
		public function refreshUsername () : void
		{
			var uname:String = playerProxy.username;
			if (uname) {
				component.usernameWidget.enabled = true;
				component.username = uname;
			} else {
				component.usernameWidget.enabled = false;
			}
		}
		
		/**
		 *	Rafraîchit l'affichage des bonus
		 */
		public function refreshBonus () : void
		{
			var blist:Array = playerProxy.allBonus;
			for each (var b:IBonus in blist)
			{
				component.updateBonus(b.theme, b.gain);
			}
		}
		
		public function appendBonus (b:IBonus) : void
		{
			component.appendBonus(b.theme, b.gain, true);
		}
		
		/*
		*	Called by Facade during registration
		*/
		override public function initialize () : void
		{
			if (component)
			{
				stage.addChild(component.sprite);
				component.updateBonus(1, 0);
				component.updateBonus(2, 0);
				component.updateBonus(3, 0);
				component.updateBonus(4, 0);

				component.compassButton.addEventListener(MouseEvent.MOUSE_UP, handleButtonEvent);
				component.soundButton.addEventListener(MouseEvent.MOUSE_UP, handleButtonEvent);
				component.parametersButton.addEventListener(MouseEvent.MOUSE_UP, handleButtonEvent);
				component.weblinkButton.addEventListener(MouseEvent.MOUSE_UP, handleButtonEvent);
				// écoute event composant
				component.addEventListener(UIEvent.TOOLTIP_CREATE, handleToolTipCreate);
				component.addEventListener(UIEvent.CLOSE_HELPSCREEN, onCloseHelpScreen);
															
			}
			
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Réception création des tooltip (survol des composant)
		 *	@param e UIEvent
		 */
		private function handleToolTipCreate (e:UIEvent) : void
		{
			switch (e.targetComponent)
			{
				case component.bonusWidget :
				{
					var cfdt:XML = ConfigProxy.getInstance().data;
					var blist:Array = playerProxy.allBonus;
					var dt:Object = {};
					dt.classe = playerProxy.classe;
					dt.level = playerProxy.level;
					for each (var b:IBonus in blist)
					{
						switch (b.theme)
						{
							case 1 :
								dt["gauge" + b.theme] = "piraniak  " + b.gain + "/10";
								break;
							case 2 :
								dt["gauge" + b.theme] = "social  " + b.gain + "/100";
								break;
							case 3 :
								dt["gauge" + b.theme] = b.gain + "/100  économie";
								break;
							case 4 :
								dt["gauge" + b.theme] = b.gain + "/100  environnement";
								break;
						}
//						dt["gauge" + b.theme] = b.gain;
					}
					e.data = dt;
					break;
				}
				case component.compassButton :
				{
					e.data = "changer de région";
					break;
				}
				case component.parametersButton :
				{
					e.data = component.helpScreen ? "fermer l'aide" : "afficher l'aide";
					break;
				}
				case component.soundButton :
				{
					e.data = component.soundButton.selected ? "couper le son" : "activer le son";
					break;
				}
			}
		}
		
		private function handleButtonEvent (e:MouseEvent) : void
		{
			var btn:IUIButton = e.target as IUIButton;
			if (!btn.enabled) return;

			switch (btn)
			{
				case component.compassButton :
					sendEvent(new BaseEvent(EventList.OPEN_MAPSCREEN));
					break;					
				case component.soundButton :
					if (btn.selected) audioHelper.muteMusic();
					else
						audioHelper.unMuteMusic();
					break;
				case component.parametersButton :
					if (btn.enabled && !component.helpScreen) {
						component.openHelpScreen();
						isosceneHelper.freezeScene();
					} else {
						component.closeHelpScreen();
					}
					break;
				case component.weblinkButton :
					flash.net.navigateToURL(new URLRequest("http://www.sos-21.com"), "_blank");					
					break;				
			}
		}
		
		/**
		 * Réception event écran d'aide fermé
		 *	@param e Event
		 */
		private function onCloseHelpScreen (e:Event) : void
		{
			isosceneHelper.unfreezeScene();
		}
		
		/**
		 * Default Event handler
		 */
		override public function handleEvent (event:Event) : void
		{
			switch (event.type)
			{
				case EventList.APPLICATION_STARTUP :
				{
					refreshUsername();
					break;
				}
				// > scène prête
				case EventList.SCENE_BUILDED :
				{
					component.sceneTitle = datamapProxy.title;
					
					/*var fontList:Array = Font.enumerateFonts();
					trace(this, "enum fonts");
					for( var i:int=0; i<fontList.length; i++ )
					{
						trace(this, "font: " + fontList[ i ].fontName );
					}*/
					
					break;
				}
				// > données utilisateur rafraichies
				case EventList.PLAYER_REFRESHED :
				{
					refreshUsername();
					refreshBonus();
					break;
				}
				case EventList.PLAYER_BONUS_GAIN :
				{
					var b:IBonus = BaseEvent(event).content as IBonus;
					appendBonus(b);
					break;
				}
				case EventList.PLAYER_BONUS_LOSS :
				{
					b = BaseEvent(event).content as IBonus;
					appendBonus(b);	
					break;
				}
				case EventList.PLAYER_BONUS_CHANGED :
				{
					refreshBonus();
					break;
				}
				case EventList.MUSIC_EVENT :
				{
					var mute:Boolean = audioHelper.musicMuted;
					component.soundButton.selected = !mute;
					break;
				}					
				default :
				{ break; }					
			}
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------

		private function get datamapProxy () : DatamapProxy
		{
			return facade.getProxy(DatamapProxy.NAME) as DatamapProxy;
		}
		
		/**
		 * @private
		 * Ref PlayerProxy
		 */
		private function get playerProxy () : PlayerProxy
		{
			return facade.getProxy(PlayerProxy.NAME) as PlayerProxy;
		}
		
		/**
		 * @private
		 * Ref AudioHelper
		 */
		private function get audioHelper () : AudioHelper
		{
			return facade.getObserver(AudioHelper.NAME) as AudioHelper;
		}
		
		/**
		 * @private
		 * Ref IsosceneHelper
		 */
		private function get isosceneHelper () : IsosceneHelper
		{
			return facade.getObserver(IsosceneHelper.NAME) as IsosceneHelper
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function listInterest () : Array
		{
			return [	EventList.APPLICATION_STARTUP,
						EventList.SCENE_BUILDED,
						EventList.PLAYER_REFRESHED,
						EventList.PLAYER_BONUS_CHANGED,
						EventList.PLAYER_BONUS_GAIN,
						EventList.PLAYER_BONUS_LOSS,
						EventList.MUSIC_EVENT	];
		}

	}
	
}
package ddgame.client.triggers {
	
	import flash.events.Event;		
	import com.sos21.events.BaseEvent;
	import ddgame.sound.SoundTrack;
	import ddgame.sound.AudioHelper;	
	import ddgame.client.proxy.LibProxy;
	import flash.media.Sound;

	/**
	 *	Trigger jouer un son
	 *
	 * arguments
	 * pload	url du fichier son
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class SoundTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 108;
			
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function execute (e:Event = null) : void
		{
			// recup son à jouer
			var sndUrl:String = getPropertie("sf");

			if (!sndUrl) {
				complete();
			}
			else {
//				var sndUrl:String = snds[0];
				// on test si le son existe dans la banque
				soundTrack = audioHelper.getSound(sndUrl);
				// le son n'est pas dans la banque
				if (!soundTrack)
				{
					// on regarde dans la lib...
					var sound:Sound = libProxy.lib.getContent(sndUrl) as Sound;
					if (sound) {
						soundTrack = audioHelper.addSound(sound, false);
					}
				}
				
				// On Recheck au cas ou rien n'ai été trouvé dans
				// la lib ou erreur de création du SoundTrack
				if (soundTrack)
				{
					// Lecture !!!
					var loops:int = getPropertie("lp");
					soundTrack.add(onSoundTrackSignal);
					soundTrack.play(0, loops);
				}
				else {
					complete();
				}
			}
		}
		
		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
		
		private var soundTrack:SoundTrack;
		
		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------
		
		private function onSoundTrackSignal (signal:String) : void
		{
			// La lecture est terminée ou à été arrêtée
			if (signal == "complete" || signal == "stop")
			{
				// Suppression listener
				soundTrack.remove(onSoundTrackSignal);
				// Suppression ref de l'AudioHelper
				audioHelper.removeSoundTrack(soundTrack);
				soundTrack = null;
				complete();
			}
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * Ref Lib
		 */
		protected function get libProxy () : LibProxy
		{ return LibProxy(facade.getProxy(LibProxy.NAME)); }
		
		/**
		 * Ref AudioHelper
		 */
		protected function get audioHelper () : AudioHelper
		{ return AudioHelper(facade.getObserver(AudioHelper.NAME)); }
		
	}

}
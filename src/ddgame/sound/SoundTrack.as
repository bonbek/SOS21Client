package ddgame.sound {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundLoaderContext;
		
	/**
	 *	Objet piste son avec contrôle du volume et tête de lecture
	 * 
	 * TODO trouver soluce pour calculer les loops correctement.
	 * Actuelement quand on passe par par un pause / resume on repart avec le
	 * nombre de loop total.
	 * Essayer de repasser le _channel en place si le son change (load())
	 * Passer la boucle infini sur une valeur int.MAX_VALUE
	 * Réfléchir à la function mute : peut être stoper le son plutôt que baisser
	 * le volume et mettre en place un timer pour récupérer la progession qui
	 * se fait en sourdine.
	 * funtion destroy ? à regarder si c'est nécéssaire d'avoir une méthode pour
	 * bien cleaner
	 * 
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class SoundTrack extends EventDispatcher {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function SoundTrack (snd:Sound = null)
		{
			_sound = snd;
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _sound:Sound;
		protected var _channel:SoundChannel;
		protected var _mute:Boolean = false;
		protected var _isPlaying:Boolean;
		protected var _volume:Number = 1;
		protected var _position:Number;
		protected var _loops:int;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retourne le son de cette piste
		 */
		public function get sound () : Sound
		{
			return _sound;
		}
		
		/**
		 * Définit l'objet son de cette piste
		 */
		public function set sound (snd:Sound) : void
		{
			// ckeck si on est en lecture;
			var isp:Boolean = _isPlaying;
			if (isp) stop();
			
			_sound = snd;
			
			// relance si on était en lecture
			/*if (isp) {
				play(0, _loops);
			}*/
		}
		
		/**
		 * Retourne le SoundChannel associé à ce son
		 */
		public function get channel () : SoundChannel
		{
			return _channel;
		}
		
		/**
		 * Retourn le SoundTransform associé à ce son
		 */
		public function get transform () : SoundTransform
		{
			if (!_channel) return null;
			
			return _channel.soundTransform;
		}
		
		/**
		 * Retourne l'état sourdine
		 */
		public function get muted () : Boolean
		{
			return _mute;
		}
		
		/**
		 * Retourne l'état de lecture
		 */
		public function get isPlaying () : Boolean
		{
			return _isPlaying;
		}
		
		/**
		 * Retourne la position de la tête de lecture
		 */
		public function get position () : Number
		{
			if (!_channel) return -1;
			
			if (isPlaying)
				return _channel.position;
			
			return _position;
		}
		
		/**
		 * Définit la position de la tête de lecture
		 */		
		public function set position (val:Number) : void
		{
			_position = val;
			
			if (!_isPlaying || !_channel) return;
			
			_channel.stop();
			_sound.play(_position, _loops);
		}
		
		/**
		 * Retourne le volume du son
		 */
		public function get volume () : Number
		{
			return _volume;
		}
		
		/**
		 * Définit le volume du son.
		 * Cette valeur définit le volume pour tous les médias
		 * chargée par cette instance
		 * @param	val	 nombre compris entre 0 et 1
		 */
		public function set volume (val:Number) : void
		{
			_volume = val;
			
			if (!_channel || _mute) return;
			
			var t:SoundTransform = _channel.soundTransform;
			t.volume = val;
			_channel.soundTransform = t;
		}
				
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function load (stream:Object, context:SoundLoaderContext = null) : void
		{
			if (_isPlaying) return;
			
			var sreq:URLRequest = stream is URLRequest ? URLRequest(stream) : new URLRequest(String(stream));
			
			_position = -1;
			_sound = new Sound(sreq, context);
		}
		
		/**
		 *	@param startTime Number
		 *	@param loops int
		 *	@param sndTransform SoundTransform
		 *	@return SoundChannel
		 */
		public function play (startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null) : SoundChannel
		{
			if (_isPlaying || !_sound) return _channel;
			
			// au cas ou la position ait été définit avant la lecture
			// et pour les méthode pause / resume
			if (_position > 0) startTime = _position;
			
			_channel = _sound.play(startTime, loops, sndTransform);
			
			// le volume est mémorisé pour toute la durée
			// de vie de cet instance SoundTrack
			var nv:Number = sndTransform ? sndTransform.volume : _volume;
			if (_mute) {
				var t:SoundTransform = _channel.soundTransform;
				t.volume = 0;
				_channel.soundTransform = t;
			} else {
				volume = nv;
			}
			
			_position = startTime;
			_loops = loops;
			_isPlaying = true;
			
			// TODO
			if (_loops == -1)
				_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			
			return _channel;
		}
		
		/**
		 *
		 */
		public function close () : void
		{
			_sound.close();
			
			_position = -1;
			_isPlaying = false;
		}
		
		/**
		 *	Stop la lecture et replace la tête
		 * de lecture à 0
		 */
		public function stop () : void
		{
			if (!_isPlaying || !_channel) return;
			
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			_channel.stop();
			_position = -1;
			_isPlaying = false;
		}
		
		/**
		 *	Met le son en pause
		 */
		public function pause () : void
		{
			if (!_isPlaying || !_channel) return;
			
			_position = _channel.position;
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			_channel.stop();
			_isPlaying = false;
		}
		
		/**
		 *	Résume le son mis en pause
		 */
		public function resume () : void
		{
			if (_isPlaying || !_channel) return;
			
			if (_position > -1)
			{
				play(_position, _loops);
			}
		}
		
		/**
		 *	Passe le son en sourdine
		 */
		public function mute () : void
		{
			if (_mute) return;
			
			var lv:Number = _volume;
			volume = 0;			
			_volume = lv;
			_mute = true;
		}
		
		/**
		 *	Enlève la sourdine du son
		 */
		public function unMute () : void
		{
			if (!_mute) return;
			
			_mute = false;
			volume = _volume;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Reception events du Sound
		 *	@param e Event
		 */
		private function soundCompleteHandler (e:Event) : void
		{
			_isPlaying = false;
			_position = -1;
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			play(0, _loops);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
			
	}

}


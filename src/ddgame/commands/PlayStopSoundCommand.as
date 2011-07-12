package ddgame.commands {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import ddgame.events.EventList;
	import ddgame.sound.AudioHelper;
	
	/**
	 *	Command lecture / arrêt / switch lecture d'un son
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class PlayStopSoundCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute(event:Event):void
		{
			var soundHelper:AudioHelper = AudioHelper(facade.getObserver(AudioHelper.NAME));
			
			var data:Object = BaseEvent(event).content;			
			var url:String = data.url;
			
			switch(event.type)
			{
				// lecture d'un son
				case EventList.PLAY_SOUND :
				{
					var loops:int = data.loop ? data.loop : 0;
					var snd:Object = soundHelper.getSound(url);
					if (!snd)
					{
						soundHelper.addSound(url, false);
					}
					soundHelper.playSound(url, loops);
					break;
				}
				// arrêt lecture d'un son
				case EventList.STOP_SOUND :
				{
					soundHelper.stopSound(url);
					break;
				}
			 	// switch lecture / stop d'un son
				case EventList.PLAYSTOP_SOUND :
				{
					loops = data.loop ? data.loop : 0;
					snd = soundHelper.getSound(url);
					if (snd)
					{
						if (snd.isPlaying)
						{
							soundHelper.stopSound(url);
						} else {
							soundHelper.playSound(url, loops);
						}						
					}
					break;
				}
				default :
				{ break; }
			}
		}
				
	}
	
}

/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package components.quiz {
	import flash.utils.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import com.sos21.debug.log;
	import com.sos21.utils.Delegate;
	import gs.TweenLite;
//	import components.quiz.DataProvider;
//	import components.quiz.QuestionItem;
	import components.quiz.QuizEvent;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  14.03.2008
	 */
	public class Quiz extends Sprite {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
				
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function Quiz(w:Number = 0, textFormat:TextFormat = null)
		{
			// initialize dataProvider to non-null to save us from null checks later
/*			if (dataProvider == null)
				dataProvider = new DataProvider(); */
			
			if (w > 0)
				_width = w;
			if (textFormat != null)
				this.textFormat = textFormat;
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		/*
		*	Setters
		*/
		private var _questionTitle:String="";
		private var _explanation:String="";
//		private var _bulletType:String="";
//		private var _dataProvider:DataProvider;
		private var _dataProvider:Array = [];
		private var _responseList:Array = [];
		private var _forceQuestionItem:QuestionItem;
		private var _step:String = "question";
		private var _questionTextField:TextField;
		private var _goodChoice:Object;
		
		private var _width:Number = 200;
//		private var _height:Number = 0;

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public var textFormat:TextFormat = new TextFormat("_sans", 12, 0xFFFFFF);
		
		[Inspectable(name="Intitulé question", type="String", defaultValue="Question ?")]
		public function get questionTitle():String
		{ return _questionTitle; }
		public function set questionTitle(val:String):void
		{
			_questionTitle = val;
			draw();
		}
				
		[Inspectable(name="Explications", type="String", defaultValue="")]
		public function get explanation():String
		{ return _explanation; }
		public function set explanation(val:String):void
		{
			_explanation = val;
			draw();
		}
		
/*		[Inspectable(name="Type de puce", enumeration="label,bullet", defaultValue="label")]
		public function get bulletType():String
		{ return _bulletType; }
		public function set bulletType(val:String):void
		{ _bulletType = val; }  */
		
/*		[Collection(name="liste réponses", collectionClass="components.quiz.DataProvider", collectionItem="components.quiz.QuestionItem", identifier="label")]
		public function set dataProvider(value:DataProvider):void {
			_dataProvider = value;
			draw();
		}
		public function get dataProvider():DataProvider {
			return _dataProvider;
		} */
		
		public function set dataProvider(val:Array/* of Object */):void {
			_dataProvider = val;
			draw();
		}
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
				
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		override public function set width(w:Number):void
		{
			_width = w;
			draw();
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
/*		public function clear():void
		{
			clearQuiz();
			var l:int = numChildren;
			while (--l > -1)
			{
				removeChildAt(l);
			}
		} */
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function choiceItemMouseHandler(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.MOUSE_OVER :
				{
					var filt:GlowFilter = new GlowFilter(0x99FF00, 1, 3, 3);
					event.target.filters = [filt];
					break;
				}
				case MouseEvent.MOUSE_OUT :
				{
					event.target.filters = [];
					break;
				}
				default :
				{
					break;
				}
			}
		}
		
		protected function responseChoiceHandler(event:Event, isGood:Boolean, bonus:Object = null):void
		{
/*			trace(isGood);
			trace(bonus); */
			dispatchEvent(new QuizEvent(QuizEvent.RESPONSE_SELECT, isGood, bonus));
			displayResult(isGood);
		}
		
/*		protected function goodChoiceHandler(event:MouseEvent):void
		{
			displayResult(true);
		}
		
		protected function badChoiceHandler(event:MouseEvent):void
		{
			displayResult(false);
		} */
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function draw():void
		{
			clear();
			displayQuestion();
			buildResponseChoice();
		}
		
		public function clear():void
		{
				// Clear all displayObject
			var l:int = _responseList.length;
			while (--l > -1)
			{
				var cItem:Sprite = Sprite(_responseList[l]);
				cItem.removeEventListener(MouseEvent.MOUSE_OVER, choiceItemMouseHandler);
				cItem.removeEventListener(MouseEvent.MOUSE_OUT, choiceItemMouseHandler);
				cItem.removeEventListener(MouseEvent.MOUSE_UP, responseChoiceHandler);
//				cItem.removeEventListener(MouseEvent.MOUSE_UP, goodChoiceHandler);
//				cItem.removeEventListener(MouseEvent.MOUSE_UP, badChoiceHandler);
				removeChild(cItem);
			}
				// Clear DisplayObject references of question list
			_responseList = [];
			
			if (_questionTextField != null)
			{
				removeChild(_questionTextField);
				_questionTextField = null;
			}
			
			l = numChildren;
			while (--l > -1)
			{
				removeChildAt(l);
			}		
		}
		
		protected function displayQuestion():void
		{
			_questionTextField = getTextBloc();
			_questionTextField.text = questionTitle;
			addChild(_questionTextField);
		}
		
		private function getTextBloc():TextField
		{
			var tf:TextField = new TextField();
//			tf.defaultTextFormat = new TextFormat("Bitstream Vera Sans", 13, 0xFFFFFF);
//			tf.defaultTextFormat = new TextFormat("Arial", 13, 0xFFFFFF);
			tf.defaultTextFormat = textFormat;
			tf.antiAliasType = AntiAliasType.ADVANCED;
//			tf.embedFonts = true;
			tf.selectable = false;
			tf.autoSize = "left";
			tf.multiline = true;
			tf.wordWrap = true;
			tf.width = width;
			
			return tf;
		}
		
		
		protected function buildResponseChoice():void
		{
			var l:int = _dataProvider.length;
			if (l <= 0)
				return;

			for (var i:int = 0; i < l; i++)
			{
//				var data:Object = _dataProvider.getItemAt(i);
				var data:Object = _dataProvider[i];
				addChoiceItem(data);
			}
		}
		
		protected function addChoiceItem(data:Object):void
		{
			var cItem:Sprite = new Sprite();
			var txtItem:TextField = getTextBloc();
			txtItem.text = data.title;

			cItem.addChild(txtItem);

			var l:int = _responseList.length;
			if (_responseList.length > 0)
			{
				var pItem:Sprite = Sprite(_responseList[l-1]);
				cItem.y = pItem.y + pItem.height;
			} else {
				cItem.y = _questionTextField.y + _questionTextField.height + 10;
			}
			addChild(cItem);
			_responseList.push(cItem);	

			cItem.buttonMode = true;
			cItem.mouseChildren = false;
				// add events listeners
			cItem.addEventListener(MouseEvent.MOUSE_OVER, choiceItemMouseHandler);
			cItem.addEventListener(MouseEvent.MOUSE_OUT, choiceItemMouseHandler);
			
//			Object(cItem).choiceHandler = Delegate.create(responseChoiceHandler, data.right, data.bonus);
			cItem.addEventListener(MouseEvent.MOUSE_UP, Delegate.create(responseChoiceHandler, data.right, data.bonus));

			if (data.right)
				_goodChoice = data;
			
		}
		
		protected function displayResult(succes:Boolean):void
		{
			clear();
			
			var entete:TextField = getTextBloc();
			var filt:GlowFilter = new GlowFilter(0x99FF00, 0.6, 2, 2);
			entete.filters = [filt];
			
			if (succes)
				entete.text = "Bonne réponse !";
			else
				entete.text = "La bonne réponse est : " + _goodChoice.title;				
			
			addChild(entete);
			
			if (_explanation != "")
			{
				var comp:TextField = getTextBloc();
				comp.text = _explanation;
				comp.y = entete.y + entete.height + 10;
				addChild(comp);
			}
			
			TweenLite.from(this, 1, {alpha:0.0});
			dispatchEvent(new QuizEvent(QuizEvent.COMPLETE));
		}
		
	}
	
}
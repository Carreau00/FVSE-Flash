package  {
	
	import flash.display.MovieClip;
	import Carreau.components.*	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import Shared.DebugFunc;
	
	public class VoreNotificationsGroup extends MovieClip {
		
		private var XPFader:XPWidgetFader;
		private var Tracker_Fader:TrackerFader;
		//private var HealthBar_Fader:HPDisplayWidget;
		
		public var LevelUpPlaying:Boolean;
		public var maxCapacity:Number;
		public var lastCurrent:Number;
		
		private var HealthBarIDStorage:Dictionary = new Dictionary(true);
		private var HealthBarList:Array = new Array();
		//private var HealthBarList:Vector.<HPDisplayWidget> = new Vector.<HPDisplayWidget>();
		//private var DisplayedHealthBar:Array = new Array();
		private var DisplayedHealthBar:Vector.<int> = new Vector.<int>();
		
		private var _trackerX:Number;
		private var _trackerY:Number;
		private var _experienceX:Number;
		private var _experienceY:Number;
		private var _healthBarX:Number;
		private var _healthBarY:Number;
		
		private static var HEALTHBAR_Y_OFFSET:Number = 22;
		private static var MAX_DISPLAYED_HEALTHBARS:int = 5;
		
		public function VoreNotificationsGroup() {
			// constructor code
			LevelUpPlaying = false;
			maxCapacity = 2;
			lastCurrent = 0;
			_trackerX = 186;
			_trackerY = 112;
			_experienceX = 0;
			_experienceY = 50;
			_healthBarX = 150; //-39.30;
			_healthBarY = 223; //79.80;
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function ProcessVoreXP(percentStart:Number, percentEnd:Number, XPtoAdd:int, levelUp:int){
		
			if(!XPFader){
				XPFader = new XPWidgetFader();
				addChild(XPFader);
				XPFader.x = _experienceX;
				XPFader.y = _experienceY;
			}
			
			//faderWidget.x = 100;
			XPFader.XPWidget_mc.SetMeterFilled(false);
			if(!XPFader.FadeInStarted){
				XPFader.ResetFadeState();
				XPFader.FadeIn();
			}

			XPFader.XPWidget_mc.oldPercent = percentStart;
			
			//debugTrace("Call SetXP()");
			XPFader.XPWidget_mc.SetXP();
			
			if (XPtoAdd > 9999){
				XPtoAdd = 9999;
			}
			if(XPtoAdd >= 0){
				//debugTrace("received XP Add command");
				UpdateXP(percentEnd, XPtoAdd);
			}
			if(levelUp){
				//debugTrace("call StartLevelUp()");
				StartLevelUp();
			}
			
		}
		
		public function UpdateXP(percentEnd:Number, XPtoAdd:Number){
			XPFader.XPWidget_mc.newPercent = percentEnd;
			XPFader.XPWidget_mc.AddXP(XPtoAdd)
		}

		public function StartLevelUp(){
			if(!LevelUpPlaying){
				LevelUpPlaying = true;
				XPFader.XPWidget_mc.LevelUp();
			}
		
		}
		
		public function ProcessTrackerProperties(current:Number, maximumCapacity:Number, newGender:Number = -1){
			if (!Tracker_Fader || Tracker_Fader.FullyFadedOut){
				ShowTrackerWidget(maximumCapacity);
			}
			if(Tracker_Fader){
				if (newGender > -1){
					Tracker_Fader.TrackerWidget_mc.StomachDevice_mc.Gender = newGender;
				}
				if (maximumCapacity != maxCapacity){
					maxCapacity = maximumCapacity;
					Tracker_Fader.TrackerWidget_mc.Max_Capacity_tf.text = String(maxCapacity);
				}
				Tracker_Fader.TrackerWidget_mc.Current_Prey_tf.text = String(current);
				if (current > lastCurrent){
					//debugTrace("current/maxCap " + String(int(current/maximumCapacity*100)))
					Tracker_Fader.TrackerWidget_mc.StomachDevice_mc.ForwardPlay(int(current/maximumCapacity*100));
				} else if (current < lastCurrent){
					//debugTrace("current/maxCap " + String(int(current/maximumCapacity*100)))
					Tracker_Fader.TrackerWidget_mc.StomachDevice_mc.ReversePlay(int(current/maximumCapacity*100));
				}
				lastCurrent = current;
				if (Tracker_Fader.FadeOutStarted){
					Tracker_Fader.FadeIn();
				}
				//debugTrace("lastCurrent: " + String(lastCurrent));
				if (lastCurrent == 0){
					DebugFunc.debugTrace("Tracker fade out");
					Tracker_Fader.SlowFadeOut();
					
				}

			}
		}
		
		public function ShowTrackerWidget(maximumCapacity:Number){
			if(!Tracker_Fader){
				Tracker_Fader = new TrackerFader();
				addChild(Tracker_Fader);
			}
			Tracker_Fader.ResetFadeState();
			Tracker_Fader.y = _trackerY; //85
			Tracker_Fader.x = _trackerX; //100
			if (maximumCapacity != maxCapacity){
				maxCapacity = maximumCapacity;
			}
			Tracker_Fader.TrackerWidget_mc.Max_Capacity_tf.text = String(maxCapacity);
			DebugFunc.debugTrace("Showing Tracker Widget");
			Tracker_Fader.FadeIn();

		}
		
		public function processHealthbar(messageString:String):void {
			DebugFunc.debugTrace("processHealthbar messageString: " + messageString);
			var MessageArray:Array = messageString.split("?");
			var preyIndex:int = MessageArray[0];
			var preyName:String = MessageArray[1];
			var preyHealth:Number = MessageArray[2];
			ShowHealthBar(preyIndex);
			UpdateHealthBar(preyIndex, preyName, preyHealth);
		}
		
		public function ShowHealthBar(preyIndex:int):void {
			var BarFader:HPDisplayFader = HealthBarIDStorage[preyIndex];
			if(!BarFader){
				BarFader = AddHealthBar(preyIndex);
				
			}
			//condition if fade in needs to occur !FadeInStarted || FadeOutStarted
			if(!BarFader.isDisplayed){
				DebugFunc.debugTrace("BarFader being added.");
				//BarFader.ResetFadeState();
				DisplayedHealthBar.unshift(preyIndex);
				BarFader.isDisplayed = true;
				addChild(BarFader);
				BarFader.x = _healthBarX;
				BarFader.y = _healthBarY;
				//BarFader.FadeIn();
			}
		}
		
		public function AddHealthBar(preyIndex:int): HPDisplayFader {
			DebugFunc.debugTrace("AddHealthBar preyIndex: " + preyIndex);
			var BarFader:HPDisplayFader = HealthBarIDStorage[preyIndex];
			if(!BarFader){
				BarFader = new HPDisplayFader();
				HealthBarIDStorage[preyIndex] = BarFader;
				BarFader.Index = preyIndex;
			}
			
			return BarFader;
		}
		
		public function UpdateHealthBar(preyIndex:int, preyName:String, preyHealth:Number): void {
			var BarFader:HPDisplayFader = HealthBarIDStorage[preyIndex];
			if(BarFader){
				BarFader.SetPreyName(preyName);
				BarFader.SetHealthPercent(preyHealth);
				if(preyHealth <= 0 && !BarFader.FadeOutStarted){
					BarFader.FastFadeOut();
				}
			}
		}
		
		public function processRemoveHealthbar(Index:int):void {
			var displayIndex:int = DisplayedHealthBar.indexOf(Index);
			DebugFunc.debugTrace("displayIndex: " + displayIndex);
			if(displayIndex > -1){
				var BarFader:HPDisplayFader = HealthBarIDStorage[Index];
				if(BarFader){
					BarFader.FastFadeOut();
				}
			}
		}
		
		public function clearAllHealthBars():void {
			if (DisplayedHealthBar.length > 0){
				for(var i:int = DisplayedHealthBar.length-1; i >= 0; i--){
					var BarFader:HPDisplayFader = HealthBarIDStorage[DisplayedHealthBar[i]];
					if(BarFader && !BarFader.FadeOutStarted){
						BarFader.FastFadeOut();
					}
				}
			}
		}
		
		public function RemoveHealthBar(preyIndex:int = -1):void {
			DebugFunc.debugTrace("RemoveHealthBar() preyIndex: " + preyIndex);
			var BarFader:HPDisplayFader = HealthBarIDStorage[preyIndex];
			if(BarFader){
				//BarFader.FastFadeOut();
				DisplayedHealthBar.splice(DisplayedHealthBar.indexOf(preyIndex), 1);
				//HealthBarIDStorage.splice(preyIndex, 1);
				removeChild(BarFader);
			}
		}
		
		// coordinate functions
		public function UpdateTrackerCoords(newX:Number, newY:Number):void{
			_trackerX = newX - this.x;
			_trackerY = newY - this.y;
		}
		
		public function UpdateXPCoords(newX:Number, newY:Number):void{
			_experienceX = newX - this.x;
			_experienceY = newY - this.y;
		}
		
		public function UpdateHPCoords(newX:Number, newY:Number):void{
			_healthBarX = newX - this.x;
			_healthBarY = newY - this.y;
		}
		
		private function enterFrameHandler(e:Event):void {
			Update();
		}
		
		public function Update(){
			if(XPFader){
				if(XPFader.XPWidget_mc.GetMeterFilled() && !XPFader.FadeOutStarted && !LevelUpPlaying){
					XPFader.FastFadeOut();
				}
				else if (XPFader.XPWidget_mc.GetMeterFilled() && !XPFader.FadeOutStarted && LevelUpPlaying && XPFader.XPWidget_mc.GetLevelUpPlayed()){
					LevelUpPlaying = false;					
					XPFader.SlowFadeOut();
				}
			}
			if(DisplayedHealthBar.length > 0){
				for(var i:int = 0; i < DisplayedHealthBar.length; i ++){
					var BarFader:HPDisplayFader = HealthBarIDStorage[DisplayedHealthBar[i]];
					var Target_Y:Number = _healthBarY -(i * HEALTHBAR_Y_OFFSET);
					//var Mod_Y:Number = BarFader.y - Mod_Y;
					if(Target_Y > BarFader.y){
						BarFader.y += 1.5;
					} else if(Target_Y < BarFader.y){
						BarFader.y -= 1.5;
					}
					if(BarFader.y-Target_Y <= 1.5 && BarFader.y-Target_Y >= -1.5){
						BarFader.y = Target_Y;
					}
					if(DisplayedHealthBar.length >= MAX_DISPLAYED_HEALTHBARS){
						for(var j:int = DisplayedHealthBar.length-1; j >= MAX_DISPLAYED_HEALTHBARS; j--){
							BarFader = HealthBarIDStorage[DisplayedHealthBar[j]];
							if(!BarFader.FadeOutStarted){
								//RemoveHealthBar(DisplayedHealthBar[j]);
								BarFader.FastFadeOut();
							}
						}
					}
				}
				
				
			}
		}
	}
	
}

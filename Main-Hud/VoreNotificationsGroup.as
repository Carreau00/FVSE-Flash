package  {
	
	import flash.display.MovieClip;
	import Carreau.components.*	
	import flash.events.Event;
	import Shared.DebugFunc;
	
	public class VoreNotificationsGroup extends MovieClip {
		
		private var XPFader:XPWidgetFader;
		private var Tracker_Fader:TrackerFader;
		
		public var LevelUpPlaying:Boolean;
		public var maxCapacity:Number;
		public var lastCurrent:Number;
		
		private var _trackerX:Number;
		private var _trackerY:Number;
		private var _experienceX:Number;
		private var _experienceY:Number;
		
		public function VoreNotificationsGroup() {
			// constructor code
			LevelUpPlaying = false;
			maxCapacity = 2;
			lastCurrent = 0;
			_trackerX = 186;
			_trackerY = 112;
			_experienceX = 0;
			_experienceY = 50;
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
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
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
		
		// coordinate functions
		public function UpdateTrackerCoords(newX:Number, newY:Number):void{
			_trackerX = newX - this.x;
			_trackerY = newY - this.y;
		}
		
		public function UpdateXPCoords(newX:Number, newY:Number):void{
			_experienceX = newX - this.x;
			_experienceY = newY - this.y;
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
		}
	}
	
}

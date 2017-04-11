package gameshell.ui {
	import com.terrypaton.media.SoundManager;
	import data.CoreData;
	import data.settings;
	import flash.display.MovieClip;

	public class UpgradePanel extends MovieClip {
		public function UpgradePanel(_ref:MovieClip, _idNumber:int, _titleText:String, _descriptionText:String, _costText:String, _levelText:String, _levelNumber:int) {
			ref=_ref
			idNumber=_idNumber
			evaluate()
			//
			updateButton=new GraphicBtnClass(ref.upgradeBtn);
			ref.panelTitle.text=_titleText
			ref.descText.text=_descriptionText
			costText=_costText
			levelText=_levelText
			ref.classRef=this
			//ref.super();
		}
		public var idNumber:int
		private var callBack:Function
		private var cost:int
		private var costText:String
		private var levelNumber:int
		private var levelText:String
		private var ref:MovieClip
		private var updateButton:GraphicBtnClass

		public function dispose():void {
			callBack=null
			updateButton.dispose()
			updateButton=null
			ref.classRef=null
			ref=null
		}

		public function evaluate():void {
			switch (idNumber) {
				case settings.ID_HULL:
					cost=settings.upgradeHullCostArray[CoreData.Instance.playerHullLevel]
					levelNumber=CoreData.Instance.playerHullLevel
					break
				case settings.ID_LIGHTS:
					cost=settings.upgradeLightsCostArray[CoreData.Instance.playerLightsLevel]
					levelNumber=CoreData.Instance.playerLightsLevel
					break
//				case settings.ID_CARGO:
//					cost=settings.upgradeCargoCostArray[CoreData.Instance.playerCargoLevel]
//					levelNumber=CoreData.Instance.playerCargoLevel
//					break
				case settings.ID_ENGINE:
					trace("evaluate engine")
					cost=settings.upgradeEngineCostArray[CoreData.Instance.playerEngineLevel]
					levelNumber=CoreData.Instance.playerEngineLevel
					break
				case settings.ID_OXYGEN:
//					cost=settings.upgradeOxygenCostArray[CoreData.Instance.playerOxygenLevel]
//					levelNumber=CoreData.Instance.playerOxygenLevel
					break
			}
//			trace("cost:" + cost)
			if (levelNumber <= 3) {
				ref.levelText.text=levelText + ": " + levelNumber
				ref.costText.text=costText + ": $" + cost
			} else {
				ref.levelText.text=levelText + ": MAX"
				ref.costText.text=costText + ": -"
			}
		}

		public function testStatus():void {
			evaluate()
			// work out the cost for this panel
			// if the player cannot afford this upgrade, disable the button
			if (CoreData.Instance.playerCoins < cost) {
				updateButton.disable()
				ref.alpha=.75
			} else {
				updateButton.enable()
//				trace("levelNumber:" + levelNumber)
				if (levelNumber >= 3) {
					updateButton.disable()
					ref.alpha=.75
//					trace("disable")
				} else {
					updateButton.enable()
					ref.alpha=1
				}
			}
		}

		public function testUpgrade():void {
			trace("idNumber:" + idNumber)
			if (idNumber == settings.ID_HULL) {
				CoreData.Instance.playerHullLevel++
				SoundManager.playSound("snd_upgrade")
			}
//			if (idNumber == settings.ID_CARGO) {
//				CoreData.Instance.playerCargoLevel++
//			}
			if (idNumber == settings.ID_ENGINE) {
				CoreData.Instance.playerEngineLevel++
				trace("CoreData.Instance.playerEngineLevel:" + CoreData.Instance.playerEngineLevel)
				SoundManager.playSound("snd_upgrade")
			}
			if (idNumber == settings.ID_OXYGEN) {
				CoreData.Instance.playerHealth++
				SoundManager.playSound("snd_upgrade")
			}
			if (idNumber == settings.ID_LIGHTS) {
				CoreData.Instance.playerLightsLevel++
				SoundManager.playSound("snd_upgrade")
			}
			CoreData.Instance.playerCoins-=cost
			if (CoreData.Instance.playerCoins < 0) {
				CoreData.Instance.playerCoins=0
			}
			testStatus()
		}
	}
}
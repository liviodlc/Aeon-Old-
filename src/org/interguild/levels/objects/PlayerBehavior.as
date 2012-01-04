package org.interguild.levels.objects {

	import org.interguild.levels.keys.KeyMan;

	public class PlayerBehavior extends Behavior {

		private var keyMan:KeyMan;


		public function PlayerBehavior(keyMan:KeyMan) {
			this.keyMan = keyMan;
		}


		public override function onGameLoop():void {
			list.beginIteration();
			while (list.hasNext()) {
				var o:GameObject = list.next as GameObject;
				if (keyMan.isActionDown(KeyMan.RIGHT))
					o.normalTriggers.setMoveRight();
				if (keyMan.isActionDown(KeyMan.RIGHT))
					o.normalTriggers.setMoveRight();
				if (keyMan.isActionDown(KeyMan.DOWN))
					o.normalTriggers.setMoveDown();
				if (keyMan.isActionDown(KeyMan.UP))
					o.normalTriggers.setMoveUp();
			}
		}
	}
}

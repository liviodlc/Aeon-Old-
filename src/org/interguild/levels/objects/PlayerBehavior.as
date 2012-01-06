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
				o.normalTriggers.setMoveRight(keyMan.isActionDown(KeyMan.RIGHT));
				o.normalTriggers.setMoveLeft(keyMan.isActionDown(KeyMan.LEFT));
				o.normalTriggers.setMoveDown(keyMan.isActionDown(KeyMan.DOWN));
				o.normalTriggers.setMoveUp(keyMan.isActionDown(KeyMan.UP));
				if (o.canJump && keyMan.isActionDown(KeyMan.JUMP, true)) {
					if (o.normalTriggers.getStandingDown()) {
						o.normalTriggers.setJumping();
						o.numJumps = 0;
					} else if (o.jumpLimit == -1 || o.numJumps < o.jumpLimit) {
						o.normalTriggers.setJumping();
						o.numJumps++;
					}
				} else {
					o.normalTriggers.setJumping(false);
					if (o.normalTriggers.getStandingDown())
						o.numJumps = 0;
				}
			}
		}
	}
}

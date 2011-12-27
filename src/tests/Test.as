package tests {

	public class Test {

		public static function AssertTrue(check:Boolean):void {

			if (!check)
				throw new Error("Assertion failed");

			trace("Assertion passed.");

		}


		public static function AssertEquals(one:Object, two:Object):void {

			if (one != two)
				throw new Error("Assertion failed: '" + one + "' != '" + two + "'");

			trace("Assertion passed.");

		}

	}
}

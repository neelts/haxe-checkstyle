package;

import checkstyle.checks.Check;
import checkstyle.checks.ParameterNumberCheck;
import haxe.PosInfos;

class ParameterNumberCheckTest extends CheckTestCase {

	public function testNoParams() {
		var check = new ParameterNumberCheck();
		assertMsg(check, ParameterNumberTests.TEST1, '');
	}

	public function test10Parameters() {
		var check = new ParameterNumberCheck();
		assertMsg(check, ParameterNumberTests.TEST2, '');
	}

	public function test11Parameters() {
		var check = new ParameterNumberCheck();
		assertMsg(check, ParameterNumberTests.TEST3, 'Too many parameters for function: test2 (> 7)');
	}

	public function testMaxParameter() {
		var check = new ParameterNumberCheck();
		check.max = 11;

		assertMsg(check, ParameterNumberTests.TEST3, '');
		assertMsg(check, ParameterNumberTests.TEST4, '');

		check.max = 3;
		assertMsg(check, ParameterNumberTests.TEST4, '');
		assertMsg(check, ParameterNumberTests.TEST3, 'Too many parameters for function: test2 (> 3)');
	}

	public function testInterface() {
		var check = new ParameterNumberCheck();
		assertMsg(check, ParameterNumberTests.TEST5, 'Too many parameters for function: test4 (> 7)');
	}

	public function testIgnoreOverridenMethods() {
		var check = new ParameterNumberCheck();
		check.ignoreOverriddenMethods = true;

		assertMsg(check, ParameterNumberTests.TEST3, '');
	}
}

class ParameterNumberTests {
	public static inline var TEST1:String = "
	abstractAndClass Test {
		var testVar1:Int;
		public function test():Void {}

		@SuppressWarnings('checkstyle:ParameterNumber')
		override public function test2(param1:Int,
								param2:Int,
								param3:Int,
								param4:Int,
								param5:Int,
								param6:Int,
								param7:Int,
								param8:Int) {
			return;
		}
	}";

	public static inline var TEST2:String =
	"abstractAndClass Test {
		public function test1(param1:Int,
								param2:Int,
								param3:Int,
								param4:Int,
								param5:Int,
								param6:Int,
								param7:Int) {
			return 3;
		}
	}";

	public static inline var TEST3:String =
	"abstractAndClass Test {
		override public function test2(param1:Int,
								param2:Int,
								param3:Int,
								param4:Int,
								param5:Int,
								param6:Int,
								param7:Int,
								param8:Int) {
			return;
		}
	}";
	
	public static inline var TEST4:String =
	"abstractAndClass Test {
		public function test3(param1:Int,
								param2:Int,
								param3:Int) {
			return;
		}
	}";

	public static inline var TEST5:String =
	"interface ITest {
		public function test4(param1:Int,
								param2:Int,
								param3:Int,
								param4:Int,
								param5:Int,
								param6:Int,
								param7:Int,
								param8:Int);
	}";
}
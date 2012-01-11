// ANIMATION FRAMES
var #default_animation:XML = new XML('<animation>' +
	'<frame id="indy">' +
		'<image id="aeon" box="132 0 32 32" />' +
	'</frame>' +
	'<frame id="gerbil">' +
		'<image id="aeon" box="0 52 31 42" position="1 -10" />' +
	'</frame>' +
	'<frame id="gerbil2">' +
		'<image id="aeon" box="0 52 31 42" position="1 -10" flipX="true" />' +
	'</frame>' +
	'<frame id="ladder_wood">' +
		'<image id="aeon" box="336 44 32 32" />' +
	'</frame>' +
	'<frame id="ladder_rope">' +
		'<image id="aeon" box="336 0 32 32" />' +
	'</frame>' +
	'<frame id="platform-top">' +
		'<image id="aeon" box="88 40 32 14" />' +
	'</frame>' +
	'<frame id="platform-bottom">' +
		'<image id="aeon" box="88 40 32 14" flipY="true" position="0 17" />' +
	'</frame>' +
	'<frame id="light-steel">' +
		'<image id="aeon" box="0 0 32 32" />' +
	'</frame>' +
	'<frame id="light-steel2">' +
		'<image id="tinted-steel" position="-32 0" />' +
	'</frame>' +
	'<frame id="wooden-crate">' +
		'<image id="aeon" box="172 0 32 32" />' +
	'</frame>' +
	'<frame id="gem">' +
		'<image id="aeon" box="213 0 32 32" />' +
	'</frame>' +
	'<frame id="water">' +
		'<image id="blue" />' +
	'</frame>' +
'</animation>');
//var $default_animation:XML = new XML("<xml><animation>" +
//	'<frame id="stand-right1" next="stand-right2" delay="90">' +
//		'<image id="megaman" box="105 11 21 24" position="5 -10" />' +
//	'</frame>' +
//	'<frame id="stand-right2" next="stand-right1" delay="5">' +
//		'<image id="megaman" box="135 11 21 24" position="5 -10" />' +
//	'</frame>' +
//	'<frame id="stand-left1" next="stand-left2" delay="90">' +
//		'<image id="megaman" box="105 11 21 24" position="5 -10" flipX="true" />' +
//	'</frame>' +
//	'<frame id="stand-left2" next="stand-left1" delay="5">' +
//		'<image id="megaman" box="135 11 21 24" position="5 -10" flipX="true" />' +
//	'</frame>' +
//	'<frame id="run-right0" next="run-right1" delay="2">' +
//		'<image id="megaman" box="162 10 21 24" position="5 -10" />' +
//	'</frame>' +
//	'<frame id="run-right1" next="run-right2" delay="5">' +
//		'<image id="megaman" box="190 10 24 25" position="5 -10" />' +
//	'</frame>' +
//	'<frame id="run-right2" next="run-right3" delay="5">' +
//		'<image id="megaman" box="216 10 24 25" position="5 -10" />' +
//	'</frame>' +
//	'<frame id="run-right3" next="run-right1" delay="5">' +
//		'<image id="megaman" box="241 10 24 25" position="5 -10" />' +
//	'</frame>' +
//	'<frame id="run-left0" next="run-left1" delay="2">' +
//		'<image id="megaman" box="162 10 21 24" position="5 -10" flipX="true" />' +
//	'</frame>' +
//	'<frame id="run-left1" next="run-left2" delay="5">' +
//		'<image id="megaman" box="190 10 24 25" position="5 -10" flipX="true" />' +
//	'</frame>' +
//	'<frame id="run-left2" next="run-left3" delay="5">' +
//		'<image id="megaman" box="216 10 24 25" position="5 -10" flipX="true" />' +
//	'</frame>' +
//	'<frame id="run-left3" next="run-left1" delay="5">' +
//		'<image id="megaman" box="241 10 24 25" position="5 -10" flipX="true" />' +
//	'</frame>' +
//	'<frame id="fall-right">' +
//		'<image id="megaman" box="267 5 26 30" position="2 -15" />' +
//	'</frame>' +
//	'<frame id="fall-left">' +
//		'<image id="megaman" box="267 5 26 30" position="2 -15" flipX="true" />' +
//	'</frame>' +
//"</animation></xml>");
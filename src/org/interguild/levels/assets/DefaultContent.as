// CUSTOM CONTENT
var $default_content:XML = new XML('<xml><content>' +
	'<drawing id="tinted-steel">' +
		'<rectangle box="0 0 96 32">' +
			'<imageFill assetid="aeon" box="0 0 32 32" tintColor="#DD0000" tintAlpha="50" />' +
		'</rectangle>' +
	'</drawing>' +
	'<drawing id="blue">' +
		'<rectangle box="0 0 928 256">' +
			'<solidFill color="#009999" alpha="50" />' +
		'</rectangle>' +
	'</drawing>' +
'</content></xml>');
//var $default_content:XML = new XML('<xml><content>' +
//	'<drawing id="circleWithSquare">' +
//		'<circle radius="30" center="40 40">' +
//			'<imageFill assetid="megaman" rotate="0" scale="300" box="148 41 29 30" alpha="100" tintColor="0x000099" tintAlpha="60"  />' +
//			'<solidFill color="CC0000" alpha="50" />' +
//			'<gradientFillLinear angle="90">' +
//				'<color hex="00FF00" scale="0..255" alpha="100" />' +
//				'<color hex="0000FF" scale="0..255" alpha="100" />' +
//			'</gradientFillLinear>' +
//			'<border color="FF0000" alpha="100" size="2" />' +
//		'</circle>' +
//		'<circle radius="20" center="0 0">' +
//			'<border color="666666" alpha="100" size="10" />' +
//		'</circle>' +
//		'<rectangle box="40 40 80 80" rounding="40">' +
//			'<solidFill color="0x00CC00" alpha="25" />' +
//			'<border color="0" alpha="100" size="6" />' +
//		'</rectangle>' +
//	'</drawing>' +
//	'<text id="helloworld" offset="15 15" box="" width="" height="" alpha="">' +
//		'<format font="Verdana" size="20" color="FFFFFF" align="left/center/right/justified" leading="4" leftMargin="6" rightMargin="6" indent="20" bold="true" underline="false" italics="false" />' +
//		'<bg color="333" border="000" />' +
//		'<text html="true">Hello World</text>' +
//	'</text>' +
//	'<video id="rickroll" assetid="rickroll">' +
//		'<playback start="0:15" end="4:55" loop="true" loopDelay="32" />' +
//		'<visual visible="true" box="12 12 40 30" crop="30 20 500 250" />' +
//		'<audio mute="false" volume="" />' +
//	'</video>' +
//	'<sound id="step1" assetid="bump">' +
//	'<playback start="0:15" end="4:55" loop="true" loopDelay="32" />' +
//		'<audio volume="" />' +
//	'</sound>' +
//'</content></xml>');
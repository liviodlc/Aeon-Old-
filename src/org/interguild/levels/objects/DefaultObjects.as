// ANIMATION FRAMES
$default_animation = "<xml><animation>" +
	'<frame id="stand1" next="stand2" delay="60">' +
		'<image assetID="megaman" box="106 12 21 24" offset="" />' +
	'</frame>' +
"</animation></xml>";

// DEFINING OBJECT IDs
$default_objects = "<xml><objects>" +
	'<obj id="x" name="Terrain" editoricon="" />' +
	'<obj id="#" name="Starting Position" editoricon="" />' +
	'<obj id="m" name="Floor Spike" editoricon="" />' +
	'<obj id="w" name="Ceiling Spike" editoricon="" />' +
"</objects></xml>";

// DEFINING OBJECT STYLES
$default_styles = "<xml><styles><![CDATA[" +
// CUSTOM VARIABLES	
"global {" +
	"$gravity: 2.35;" +
"}" +
// TERRAIN
"x {" +
	"hitbox-width: 32;" +
	"hitbox-height:32;" +
	"coll-edge-solidity: solid-wall;" +
	"coll-edge-bounce: 0 1;" +
	"coll-edge-lethality: false;" +
	"coll-edge-strength: true;" +
	"init-state: static;" +
	"allow-state-change: false;" +
	"terrain: true;" +
"}" +
// PLAYER
"# {" +
	"player: true;" +
	"hit-box-width: 30;" +
	"hit-box-height: 42;" +
	"object-offset: 1 -10;" +
	"y-Acc: $gravity;" +
	"max-speed-x: 8;" +
	"coll-edge-solidity: solid-wall;" +
	"coll-edge-lethality-smash: true;" +
	"coll-edge-strength: false;" +
	"coll-edge-strength-default-smash: true;" +
	"init-state: nonstatic;" +
	"allow-state-change: false;" +
	"allow-be-in-crawl: true;" +
	"allow-auto-crawl: true;" +
	"jump: -22;" +
	"allow-jump: false;" +
	"allow-enter-crawl: false;" +
"}" +
"#:standing-on-down {" +
	"allow-enter-crawl: true;" +
	"allow-jump: true;" +
"}" +
"#:right{" +
	"accelerate-x: 5" +
"}" +
"#:left{" +
	"accelerate-x: -5" +
"}" +
"]]></styles></xml>";
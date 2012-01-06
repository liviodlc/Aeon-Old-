// DEFINING OBJECT IDs
var $default_objects:XML = new XML("<xml><objects>" +
	'<type id="x" name="Terrain" editoricon="" />' +
	'<type id="#" name="Starting Position" behavior="player" editoricon="" />' +
	'<type id="m" name="Floor Spike" editoricon="" />' +
	'<type id="w" name="Ceiling Spike" editoricon="" />' +
	'<type id=".a" name="Ceiling Spike" editoricon="" />' +
"</objects></xml>");

// DEFINING OBJECT STYLES
var $default_styles:XML = new XML("<xml><styles><![CDATA[" +
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
	"hitbox-width: 30;" +
	"hitbox-height: 42;" +
	"hitbox-offset: 1 -10;" +
	"accelerate-y: 2;" +
	"accelerate-x: 0;" +
	"max-speed-x: 10;" +
	"max-speed-y: 30 20;" +
	"friction-x: 1;" +
	"coll-edge-solidity: solid-wall;" +
	"coll-edge-lethality-smash: true;" +
	"coll-edge-strength: false;" +
	"coll-edge-strength-default-smash: true;" +
	"init-state: nonstatic;" +
	"allow-state-change: false;" +
	"allow-be-in-crawl: true;" +
	"allow-auto-crawl: true;" +
	"jump-strength: 22;" +
	"allow-jump: true;" +
	"allow-enter-crawl: false;" +
	"mid-air-jump-limit: -1;" +
"}" +
"#:standing-on-down {" +
	"allow-enter-crawl: true;" +
	"allow-jump: true;" +
	"friction-x:3;" +
"}" +
"#:jumping{" +
	"set-speed-y: -16;" +
"}" +
"#:jumping:standing-on-down{" +
	"set-speed-y: -22;" +
"}" +
"#:jumping:right {" +
	"set-speed-x: 10;" +
"}" +
"#:jumping:left {" +
	"set-speed-x: -10;" +
"}" +
"#:right{" +
	"accelerate-x: 2;" +
"}" +
"#:left{" +
	"accelerate-x: -2;" +
"}" +
".a{" +
	"animate:megaman;" +
"}" +
".ab{" +
	"animate:megaman;" +
"}" +
".B{" +
	"animate:megaman;" +
"}" +
"]]></styles></xml>");
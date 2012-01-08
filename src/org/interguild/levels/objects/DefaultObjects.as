// DEFINING OBJECT IDs
var $default_objects:XML = new XML("<xml><objects>" +
	'<type id="x" name="Terrain" editoricon="" />' +
	'<type id="#" name="Starting Position" behavior="player" editoricon="" />' +
	'<type id="H" name="Ladder" editoricon="" />' +
	'<type id="~" name="Water" editoricon="" />' +
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
"H {" +
	"hitbox-width: 32;" +
	"hitbox-height: 32;" +
	"coll-effect-ladder: true;" +
"}" +
"~ {" +
	"hitbox-width: 32;" +
	"hitbox-height: 32;" +
	"coll-effect-water: true;" +
"}" +
// TERRAIN
"x {" +
	"hitbox-width: 32;" +
	"hitbox-height:32;" +
	"coll-edge-solidity: solid-wall;" +
	"coll-edge-buffer: 5 5;" +
	"coll-edge-bounce: 0;" +
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
	"hitbox-offset: 1 -22;" +
	"accelerate-y: 2;" +
	"accelerate-x: 0;" +
	"max-speed-x: 10;" +
	"max-speed-y: 30 22;" +
	"friction-y: 0 1;" +
	"coll-edge-solidity: solid-wall;" +
	"coll-edge-lethality-smash: true;" +
	"coll-edge-strength: false;" +
	"coll-edge-strength-default-smash: true;" +
	"init-state: nonstatic;" +
	"allow-state-change: false;" +
	"allow-be-in-crawl: true;" +
	"allow-jump: true;" +
	"allow-enter-crawl: false;" +
	"mid-air-jump-limit: -1;" +
	"can-use-ladder: true;" +
	"z-index:front;" +
"}" +
"#:standing-on-down {" +
	"allow-enter-crawl: true;" +
	"allow-jump: true;" +
	"friction-x:3;" +
"}" +
"#:crawling {" +
	"hitbox-height: 30;" +
	"hitbox-offset-y: -10;" +
	"auto-crawl: 12 0 0 0;" +
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
"#:ladder{" +
	"accelerate-y:0;" +
	"friction-y: 4" +
"}" +
"#:water{" +
	"accelerate-y:-0.2;" +
	"friction-y: 4;" +
"}" +
"#:ladder:up, #:water:up{" +
	"accelerate-y:-2;" +
"}" +
"#:ladder:down, #:water:down{" +
	"accelerate-y:2;" +
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
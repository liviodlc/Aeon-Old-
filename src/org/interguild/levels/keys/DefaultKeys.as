// ActionScript file
var myXML:XML = new XML(
"<xml><keys>" +
	"<key key=\"37\">1</key>" +	// Left 	= LEFT
	"<key key=\"65\">1</key>" +	// A		= LEFT
	"<key key=\"39\">2</key>" +	// Right	= RIGHT
	"<key key=\"68\">2</key>" +	// D		= RIGHT
	"<key key=\"38\">3</key>" +	// Up		= UP
	"<key key=\"87\">3</key>" +	// W		= UP
	"<key key=\"40\">4</key>" +	// Down		= DOWN
	"<key key=\"83\">4</key>" +	// S		= DOWN
	"<key key=\"32\">5</key>" +	// Spacebar	= JUMP
	"<key key=\"81\">7</key>" +	// Q		= QUIT
	"<key key=\"82\">8</key>" +	// R		= RESTART
	"<key key=\"16\">6</key>" +	// Shift	= PAUSE
	"<key key=\"80\">6</key>" +	// P		= PAUSE
"</keys></xml>"
);
var dKeys:XMLList = myXML.keys

#import "Global.h"

@class Image;
@class GameController;

#define kMaxCharsInFont 223

// Structure used to store information on each character in the font being used
typedef struct _BitmapFontChar
{
	int charID;
	int x;
	int y;
	int width;
	int height;
	int xOffset;
	int yOffset;
	int xAdvance;
	Image *image;
	float scale;
} BitmapFontChar;

// Enumerators used to define what type of justification should be used when rendering in a frame
enum
{
	BitmapFontJustification_TopCentered,
	BitmapFontJustification_MiddleCentered,
	BitmapFontJustification_BottomCentered,
	BitmapFontJustification_TopRight,
	BitmapFontJustification_MiddleRight,
	BitmapFontJustification_BottomRight,
	BitmapFontJustification_TopLeft,
	BitmapFontJustification_MiddleLeft,
	BitmapFontJustification_BottomLeft
};

// Whilst looking for how to render Bitmap Fonts I found this page http://www.angelcode.com/products/bmfont/
// 
// They have an application which can take a true type font and turn it into a spritesheet and control file.
// With these files you can then render a string to the screen using the font generated.  I develop on a Mac of
// course so was disappointed that this app was for Windows.  Fear not, luckily a tool has been developed by
// Kev Glass over at http://slick.cokeandcode.com/index.php for use with his open source Java 2D game library.
// The app is called Hiero. 
// 
// This generates the necessary image file and control file in the format defined on the AngelCode Font website.
// Hiero has also been updated recently to handle Unicode fonts as well accoriding to the forums and this new 
// versions webstart can be found here http://www.n4te.com/hiero/hiero.jnlp 
// 
// Being Java this version will work on any platform :o)
// 
// This implementation has been tested against the output from Hiero V2
//
@interface BitmapFont : NSObject
{
	
	GameController *sharedGameController;	// Reference to the game controller
	Image *image;							// Image file that contains the fonts spritesheet
    BitmapFontChar *charsArray;				// Array of BitmapFontChar objects that will hold all the define font characters
    int lineHeight;						// The common line height of the entire font found in the control file
	Color4f fontColor;						// The color to be used when rendering this font.  This can be changed at any time
}

@property(nonatomic, retain) Image *image;
@property(nonatomic, assign) Color4f fontColor;

// Designated initializer that creates a new BitmapFont instance.  This initializer
// accepts the filename and type of the image file that contains the fonts texture atlas,
// a control file which has the information on where in the texture atlas each character
// is plus details of the spacing etc needed for each character
- (id)initWithFontImageNamed:(NSString*)aFileName controlFile:(NSString*)aControlFile scale:(Scale2f)aScale filter:(GLenum)aFilter;

- (id)initWithImage:(Image *)aImage controlFile:(NSString *)aControlFile scale:(Scale2f)aScale filter:(GLenum)aFilter;

// Renders the string provided at the designated point
- (void)renderStringAt:(CGPoint)aPoint text:(NSString*)aText;

// Renders the string provided justified within the frame provided.  The justification used is defined by the 
// justification enum supplied
- (void)renderStringJustifiedInFrame:(CGRect)aRect justification:(int)aJustification text:(NSString*)aText;

// Returns the width of the string provided
- (int)getWidthForString:(NSString*)string;

// Returns the height of the string provided
- (int)getHeightForString:(NSString*)string;

@end

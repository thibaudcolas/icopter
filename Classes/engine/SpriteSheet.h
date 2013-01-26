#import "Global.h"
#import "Image.h"

@class TextureManager;
@class Image;

// This class represents a sprite sheet object, also called a texture atlas.  A sprite sheet
// is a large image that contains a number of smaller sub-images.  Each of these smaller sub-images 
// normally have the same dimensions in a simple sheet.  When you create a sprite sheet you specify the width
// and height of the sub-images within the texture and if there is any spacing between these
// images or margin.  Once instantiated, you are then able to request a specific image from the
// sprite sheet using the images X and Y coordinates.
//
@interface SpriteSheet : NSObject {

    Image *image;					// Image which is being used for this spritesheet
    CGSize spriteSize;				// Size of each image (sprite) within this sprite sheet
    NSUInteger spacing;				// Spacing between each sprite
	NSUInteger margin;				// Margin
    NSUInteger horizSpriteCount;    // Number of sprites horizontally within this sprite sheet
    NSUInteger vertSpriteCount;		// Number of sprites vertically within this sprite sheet
	NSMutableArray *cachedSprites;  // Array that holds the cached sprite images

}

@property (nonatomic, assign, readonly) CGSize spriteSize;
@property (nonatomic, assign, readonly) NSUInteger spacing;
@property (nonatomic, assign, readonly) NSUInteger margin;
@property (nonatomic, assign, readonly) NSUInteger horizSpriteCount;
@property (nonatomic, assign, readonly) NSUInteger vertSpriteCount;
@property (nonatomic, retain) Image *image;

// Class method that allows us to cache sprite sheets that are created by providing an images file name.
// This class should be used to get a sprite sheet rather than the initializer if you want to make use of 
// the cached sprite sheets
+ (SpriteSheet*)spriteSheetForImageNamed:(NSString*)aImageName spriteSize:(CGSize)aSpriteSize spacing:(NSUInteger)aSpacing 
								  margin:(NSUInteger)aMargin imageFilter:(GLenum)aFilter;

// Class method that allows us to cache sprite sheets that are created by providing an image instance.
// This class should be used to get a sprite sheet rather than the initializer if you want to make use of 
// the cached sprite sheets
+ (SpriteSheet*)spriteSheetForImage:(Image*)aImage sheetKey:(NSString*)aSheetKey spriteSize:(CGSize)aSpriteSize 
							spacing:(NSUInteger)aSpacing margin:(NSUInteger)aMargin;

// Class method used to remove a cached sprite sheet with the provided key
+ (BOOL)removeCachedSpriteSheetWithKey:(NSString*)aKey;

// Designated initializer used to create a new sprite sheet
- (id)initWithImageNamed:(NSString*)aImageFileName spriteSize:(CGSize)aSpriteSize spacing:(NSUInteger)aSpacing margin:(NSUInteger)aMargin imageFilter:(GLenum)aFilter;

// Initialize the sprite sheet using an Image instance rather than taking the image file name
- (id)initWithImage:(Image*)aImage spriteSize:(CGSize)aSpriteSize spacing:(NSUInteger)aSpacing margin:(NSUInteger)aMargin;

// Returns an Image which represents the sprite at the given coordinates
- (Image*)spriteImageAtCoords:(CGPoint)aPoint;


@end

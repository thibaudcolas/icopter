#import "Global.h"

@class Image;

// PackedSpriteSheet allows you to have a single large image that contains a number of differently
// sized sub images.  This means you can place entire sprite sheets wihtin this packed sprite sheet
// along with single images etc.  This means that a single texture could contain all textures that
// are used by the game and reduce the number of texture binds needed when rendering.
//
@interface PackedSpriteSheet : NSObject {

	Image *image;						// Packed Spritesheet Image
	NSMutableDictionary *sprites;		// Dictionary that contains the sprites found in the packed sprite sheet
	NSDictionary *controlFile;			// Dictionary created from the control file for the packed sprite sheet

}

// Class method used to retrieve a cached packed sprite sheet instance.  If a packed sprite sheet
// can be found in the cache that has the same name then a reference to that object is returned.
// If no match is found then a new PackedSpriteSheet is created, cached and passed back.
+ (PackedSpriteSheet*)packedSpriteSheetForImageNamed:(NSString*)aImageName controlFile:(NSString*)aControlFile imageFilter:(GLenum)aFilter;

// Class method that allows you to remove a cachedSpriteSheet with the provided key
+ (BOOL)removeCachedPackedSpriteSheetWithKey:(NSString*)aKey;

// Designated initializer that takes an Image instance which it uses as a packed sprite sheet
// along with an associated control file that describes where sprites are within the sprite
// sheet.  The control file should not contain the file extension which should always be plist.
- (id)initWithImageNamed:(NSString*)aImageFileName controlFile:(NSString*)aControlFile filter:(GLenum)aFilter;

// Returns an image that contains the image with the supplied key in the packed sprite sheet
- (Image*)imageForKey:(NSString*)aKey;

@end

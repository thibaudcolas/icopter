#import "Global.h"

@class Texture2D;

// Class that is responsible for texture resources witihn the game.  This class should be
// used to load any texture.  The class will check to see if an instance of that Texture
// already exists and will return a reference to it if it does.  If no instance already
// exists then it will create a new instance and pass a reference back to this new instance.
// The filename of the texture is used as the key within this class.
//
@interface TextureManager : NSObject {
    NSMutableDictionary *cachedTextures;	// A dictionary of all textures that are currently in use
}

+ (TextureManager *)sharedTextureManager;

// Selector returns a Texture2D which has a ket of |aTextureName|.  If a texture cannot be
// found with that key then a new Texture2D is created and added to the cache and a 
// reference to this new Texture2D instance is returned.
- (Texture2D*)textureWithFileName:(NSString*)aName filter:(GLenum)aFilter;

// Selector that releases a cached texture which has a matching key to |aTextureName|.
- (BOOL)releaseTextureWithName:(NSString*)aName;

// Selector that releases all cached textures.
- (void)releaseAllTextures;

@end

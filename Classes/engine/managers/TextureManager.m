#import "TextureManager.h"
#import "SynthesizeSingleton.h"
#import "Texture2D.h"

@implementation TextureManager

SYNTHESIZE_SINGLETON_FOR_CLASS(TextureManager);

- (void)dealloc {
    
    // Release the cachedTextures dictionary.
	[cachedTextures release];
	[super dealloc];
}


- (id)init {
	// Initialize a dictionary
	if (self = [super init]) {
		cachedTextures = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (Texture2D*)textureWithFileName:(NSString*)aName filter:(GLenum)aFilter {
    
    // Try to get a texture from cachedTextures with the supplied key.
    Texture2D *cachedTexture;

	if((cachedTexture = [cachedTextures objectForKey:aName])) {
		return cachedTexture;
	}
	
	// We are using imageWithContentsOfFile rather than imageNamed, as imageNamed caches the image in the device.
	// This can lead to memory issue as we do not have direct control over when it would be released.  Not using
	// imageNamed means that it is not cached by the OS and we have control over when it is released.
	NSString *filename = [aName stringByDeletingPathExtension];
	NSString *filetype = [aName pathExtension];
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:filetype];
	cachedTexture = [[Texture2D alloc] initWithImage:[UIImage imageWithContentsOfFile:path] filter:aFilter];
	[cachedTextures setObject:cachedTexture forKey:aName];
		
	// Return the texture which is autoreleased as the caller is responsible for it
    return [cachedTexture autorelease];
}

- (BOOL)releaseTextureWithName:(NSString*)aName {
	
    // If a texture was found we can remove it from the cachedTextures and return YES.
    if([cachedTextures objectForKey:aName]) {
        [cachedTextures removeObjectForKey:aName];
        return YES;
    }
    
    // No texture was found with the supplied key so log that and return NO;
    NSLog(@"INFO - Resource Manager: A texture with the key '%@' could not be found to release.", aName);
    return NO;
}

- (void)releaseAllTextures {
    NSLOG(@"INFO - Resource Manager: Releasing all cached textures.");
    [cachedTextures removeAllObjects];
}

@end

#import "SpriteSheet.h"
#import "TextureManager.h"
#import "Image.h"
#import "Texture2D.h"

#pragma mark -
#pragma mark Private interface

@interface SpriteSheet (Private)

// Using the image provided, cache the sprite information for each sprite in the sprite sheet
- (void)cacheSprites;

@end

#pragma mark -
#pragma mark Public implementation

@implementation SpriteSheet

@synthesize spriteSize;
@synthesize spacing;
@synthesize margin;
@synthesize horizSpriteCount;
@synthesize vertSpriteCount;
@synthesize image;

- (void)dealloc {
	[cachedSprites release];
    [image release];
    [super dealloc];
}

static NSMutableDictionary *cachedSpriteSheets = nil;

+ (SpriteSheet*)spriteSheetForImageNamed:(NSString*)aImageName spriteSize:(CGSize)aSpriteSize spacing:(NSUInteger)aSpacing 
								  margin:(NSUInteger)aMargin imageFilter:(GLenum)aFilter {
	
    // Create a variable that will hold the sprite sheet to return
	SpriteSheet *cachedSpriteSheet;
	
	if (!cachedSpriteSheets)
		cachedSpriteSheets = [[NSMutableDictionary alloc] init];
    
	// If a sprite sheet created with the same filename is found then return the reference to it
	if((cachedSpriteSheet = [cachedSpriteSheets objectForKey:aImageName]))
		return cachedSpriteSheet;
	
    // As we have not found a sprite sheet we need to create a new one
    cachedSpriteSheet = [[SpriteSheet alloc] initWithImageNamed:aImageName spriteSize:aSpriteSize spacing:aSpacing margin:aMargin imageFilter:aFilter];
    // ... add it to the cachedSpriteSheets dictionary
	[cachedSpriteSheets setObject:cachedSpriteSheet forKey:aImageName];
	[cachedSpriteSheet release];
	
    // ... and return a reference to it
	return cachedSpriteSheet;
}

+ (SpriteSheet*)spriteSheetForImage:(Image*)aImage sheetKey:(NSString*)aSheetKey spriteSize:(CGSize)aSpriteSize 
							spacing:(NSUInteger)aSpacing margin:(NSUInteger)aMargin {
	
    // Create a variable that will hold the sprite sheet to return	
	SpriteSheet *cachedSpriteSheet;
	
	if (!cachedSpriteSheets)
		cachedSpriteSheets = [[NSMutableDictionary alloc] init];
	
    // If a sprite sheet created with the same texture name is found then return the reference to it
	if((cachedSpriteSheet = [cachedSpriteSheets objectForKey:aSheetKey]))
		return cachedSpriteSheet;
	
    // As we have not found a sprite sheet we need to create a new one
	cachedSpriteSheet = [[SpriteSheet alloc] initWithImage:aImage spriteSize:aSpriteSize spacing:aSpacing margin:aMargin];
    // ... add it to the cachedSpriteSheets dictionary
	[cachedSpriteSheets setObject:cachedSpriteSheet forKey:aSheetKey];
	[cachedSpriteSheet release];
	
    // ... and return a reference to it    
	return cachedSpriteSheet;
	
}

+ (BOOL)removeCachedSpriteSheetWithKey:(NSString*)aKey {
	
	SpriteSheet *cachedSpriteSheet = [cachedSpriteSheets objectForKey:aKey];
	if (cachedSpriteSheet) {
		[cachedSpriteSheets removeObjectForKey:aKey];
		return YES;
	} else {
		NSLog(@"WARNING - SpriteSheet: Key '%@' could not be found to release.", aKey);
	}
	
	return NO;
}

- (id)initWithImageNamed:(NSString*)aImageFileName spriteSize:(CGSize)aSpriteSize spacing:(NSUInteger)aSpacing margin:(NSUInteger)aMargin imageFilter:(GLenum)aFilter {

    // Call the Image classes designated initializer so that the image we are going to use for the
    // sprite sheet is set up along with all the images properties
    if (self = [super init]) {
        
        NSString *fileName = [aImageFileName lastPathComponent];
        
        // Initialize the image to be used for this sprite sheet
		self.image = [[Image alloc] initWithImageNamed:fileName filter:aFilter];

		// Sprite size and spacing
		spriteSize = aSpriteSize;
		spacing = aSpacing;
		margin = 0;
		
        // Cache the sprites that are included within this sprite sheet
		[self cacheSprites];
	}
    return self;
}

- (id)initWithImage:(Image*)aImage spriteSize:(CGSize)aSpriteSize spacing:(NSUInteger)aSpacing margin:(NSUInteger)aMargin{
    if (self = [super init]) {
		self.image = aImage;
		
		// Sprite size and spacing
		spriteSize = aSpriteSize;
		spacing = aSpacing;
		margin = aMargin;
		
		[self cacheSprites];
	}
	return self;
}

- (Image*)spriteImageAtCoords:(CGPoint)aPoint {

    // Check to make sure that the requested coordinates are within the bounds of the spriteSheet
    if(aPoint.x > horizSpriteCount-1 || aPoint.y < 0 || aPoint.y > vertSpriteCount-1 || aPoint.y < 0)
        return nil;
    
	// Calculate the location within the cached sprites
	int index = (horizSpriteCount * aPoint.y) + aPoint.x;

    // Return the image created
    return [cachedSprites objectAtIndex:index];

}

@end

@implementation SpriteSheet (Private)

- (void)cacheSprites {
	
	// Calculate how many sprites there are horizontally and vertically given their size and margin
	horizSpriteCount = ((image.imageSize.width + spacing) + margin) / ((spriteSize.width + spacing) + margin);
	vertSpriteCount = ((image.imageSize.height + spacing) + margin) / ((spriteSize.height + spacing) + margin);
	
	// Initialize the structure to hold the geometry, texture and colour vertices
	cachedSprites = [[NSMutableArray alloc] init];
	CGPoint textureOffset;
		
	// Calculate and cache a texturedColoredQuad for each sprite in the sprite sheet
	for(uint row=0; row < vertSpriteCount; row++) {
		for(uint column=0; column < horizSpriteCount; column++) {
			
			// Based on the location within the spritesheet of the sprite we need, get a pixel point within the
			// texture where the sprite texture will begin
			CGPoint texturePoint = CGPointMake((column * (spriteSize.width + spacing) + margin), (row * (spriteSize.height + spacing) + margin));
			
			// Now make a rectangle structure that contains the position and dimensions of the image we want to grab
			// for this tile image
			textureOffset.x = image.textureOffset.x * image.fullTextureSize.width + texturePoint.x;
			textureOffset.y = image.textureOffset.y * image.fullTextureSize.height + texturePoint.y;
			CGRect tileImageRect = CGRectMake(textureOffset.x, textureOffset.y, spriteSize.width, spriteSize.height);

			// Create a new image by grabbing the subimage defined above from the main sprite sheet image
			Image *tileImage = [[image subImageInRect:tileImageRect] retain];
			
			// Add this image to the cached array
			[cachedSprites addObject:tileImage];
			
			// Release the tile image
			[tileImage release];
		}
	}
}

@end



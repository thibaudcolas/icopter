#import "PackedSpriteSheet.h"
#import "Image.h"

#pragma mark -
#pragma mark Private interface

@interface PackedSpriteSheet (Private)

// Parse the XML control file for this packed sprite sheet
- (void)parseControlFile:(NSDictionary*)aControlFile;

@end

#pragma mark -
#pragma mark Public implementation

@implementation PackedSpriteSheet

- (void)dealloc {
	[sprites release];
	[image release];
	[super dealloc];
}

static NSMutableDictionary *cachedPackedSpriteSheets = nil;

+ (PackedSpriteSheet*)packedSpriteSheetForImageNamed:(NSString*)aImageName controlFile:(NSString*)aControlFile imageFilter:(GLenum)aFilter {
	
	// Set up a holder for our PackedSpritesheet
	PackedSpriteSheet *cachedPackedSpriteSheet;
	
	// If the cachedPackedSpriteSheets dictionary does not already exist then create one
	if (!cachedPackedSpriteSheets)
		cachedPackedSpriteSheets = [[NSMutableDictionary alloc] init];
	
	// Try to find a cached packed sprite sheet that has the same image name as the one provided.  If one is found
	// then a reference to that is returned
	if((cachedPackedSpriteSheet = [cachedPackedSpriteSheets objectForKey:aImageName]))
		return cachedPackedSpriteSheet;
	
	// If no match is found then we create a new PackedSpriteSheet, add it to the cache and return a reference
	cachedPackedSpriteSheet = [[PackedSpriteSheet alloc] initWithImageNamed:aImageName controlFile:aControlFile filter:aFilter];
	[cachedPackedSpriteSheets setObject:cachedPackedSpriteSheet forKey:aImageName];
	[cachedPackedSpriteSheet release];
	
	return cachedPackedSpriteSheet;
}

+ (BOOL)removeCachedPackedSpriteSheetWithKey:(NSString*)aKey {
	
	PackedSpriteSheet *cachedPackedSpriteSheet = [cachedPackedSpriteSheets objectForKey:aKey];
	if (cachedPackedSpriteSheet) {
		[cachedPackedSpriteSheets removeObjectForKey:aKey];
		return YES;
	} else {
		NSLog(@"WARNING - PackedSpriteSheet: Key '%@' could not be found to release.", aKey);
	}
	
	return NO;
}

- (id)initWithImageNamed:(NSString*)aImageFileName controlFile:(NSString*)aControlFile filter:(GLenum)aFilter {
	
    if (self = [super init]) {
	
		NSString *fileName = [aImageFileName lastPathComponent];
		
        // Initialize the image to be used for this packed sprite sheet
        image = [[[Image alloc] initWithImageNamed:fileName filter:aFilter] retain];
	
		// Set up the sprites dictionary
		sprites = [[NSMutableDictionary alloc] init];
		
		// Create a dictionary from the plist control file which should be in the main bundle.  The control
		// files extension should always be plist
		controlFile = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:aControlFile ofType:@"plist"]];
		[self parseControlFile:controlFile];
		[controlFile release];
	}
	return self;
	
}

- (Image*)imageForKey:(NSString*)aKey {
	// Return the image for the key provided from the sprites dictionary
	Image *spriteImage = [sprites objectForKey:aKey];
	if (spriteImage) {
		return spriteImage;
	}
	
	NSLog(@"ERROR - PackedSpriteSheet: Sprite could not be found for key '%@'", aKey);
	return nil;
}

@end

#pragma mark -
#pragma mark Private implementation

@implementation PackedSpriteSheet (Private)

- (void)parseControlFile:(NSDictionary*)aControlFile {

	// Create a dictionary from the entries in the frames dictionary in the plist file
	NSDictionary *framesDictionary = [controlFile objectForKey:@"frames"];

	// Loop through all the keys in the framesDictionary and process its dictionary
	for (NSString *frameDictionaryKey in framesDictionary) {

		// Create a dictionary for the key we are currently processing
		NSDictionary *frameDictionary = [framesDictionary objectForKey:frameDictionaryKey];
		
		// Grab the sprites information from the dictionary
		float x = [[frameDictionary objectForKey:@"x"] floatValue];
		float y = [[frameDictionary objectForKey:@"y"] floatValue];
		float w = [[frameDictionary objectForKey:@"width"] floatValue];
		float h = [[frameDictionary objectForKey:@"height"] floatValue];
		
		// Add a reference to that sprite to the sprites dictionary for us to grab later.  The returned
		// image is autoreleased, but as the retain count is increased when we add the image reference
		// to the dictionary, we don't need to do an extra retain
		Image *subImage = [image subImageInRect:CGRectMake(x, y, w, h)];
		[sprites setObject:subImage forKey:frameDictionaryKey];
	}
}

@end

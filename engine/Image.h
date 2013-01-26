#import "Global.h"

@class Texture2D;
@class TextureManager;
@class ImageRenderManager;
@class GameController;

// The Image class is a wrapper around the Texture2D class.  It holds
// important information about an image that can be rendered to the screen 
// such as its dimensions, rotation, scale, color filter and texture coordinates.
// The texture coordinates allow an image to respresent a subimage within 
// the texture which then provides support for sprite sheets (texture atlases).
// 
// To effect rotation, 
// translation and scaling, this class transforms this images own matrix.  This 
// allows us to load the transformed vertices into the IVA so that they are rendered 
// correctly based on the images scale, rotation and location.
//
// If an image is not rendered using the ImageRenderManager then the rendering is 
// the responsbility of another class.  In that instance the images rendering
// details such as geometry and texture information can be retrieved using 
// the images ImageDetails structure
//
@interface Image : NSObject {

	//////////////////// Singleton Managers
    TextureManager *textureManager;					// Reference to the texture manager
    GameController *sharedGameController;			// Reference to the game controller
    ImageRenderManager *sharedImageRenderManager;	// Reference to the render manager

	//////////////////// Image iVars
    NSString *imageFileName;		    // Holds the name of the image file used to create this image.  This is used
	NSString *imageFileType;			// when caching Texture2D objects.
    Texture2D *texture;				    // Texture2D object which has been created with the image provided to create this
										// image instance
    CGSize fullTextureSize;			    // Width and Height of the actual texture which is ^2
    CGSize textureSize;				    // Width and height of the texture this image is actually using
    CGSize imageSize;				    // Width and height of the image within the the texture this instance represents
	CGSize originalImageSize;			// Original image size used when changing the % of image rendered using the
										// setImageWidthPercentage or setImageHeightPercentage methods
    CGSize maxTextureSize;			    // Maximum texture width and height of the image
    CGPoint textureOffset;			    // Offset of the image within the texture from where the image should be taken
    float rotation;					    // Information about the scale and rotation of the image
    Scale2f scale;
    BOOL flipHorizontally;			    // Information about the scale and rotation of the image
    BOOL flipVertically;
	NSUInteger IVAIndex;			    // Information about the scale and rotation of the image
    GLuint textureName;				    // Name of the OpenGL texture used by the associated Texture2D object
	CGPoint point;						// Point at which the image will be rendered
    CGPoint rotationPoint;			    // Point around which the image will be rotated
    Color4f color;					    // Color filter to be applied to the image
	BOOL dirty;						    // Tracks if the image needs to be transformed before being rendered
    GLenum minMagFilter;			    // Holds the min/mag option for the image
	CGRect subImageRectangle;			// Rectangle that holds the bounds of the current image
    CGSize textureRatio;			    // Height and width ratio of the image to the texture.  This allows us to take a pixel
										// location within the image and convert that to texture coordinates

	//////////////////// Render information
	ImageDetails *imageDetails;		    // Structure to store both the original and transformed geometry, texture and color information
    float matrix[9];				    // Array used to store our own matrix information

}

@property (nonatomic, retain) NSString *imageFileName;
@property (nonatomic, retain) NSString *imageFileType;
@property (nonatomic, retain) Texture2D *texture;
@property (nonatomic, assign) CGSize fullTextureSize;
@property (nonatomic, assign) CGSize textureSize;
@property (nonatomic, assign) CGSize textureRatio;
@property (nonatomic, assign) CGSize maxTextureSize;
@property (nonatomic, assign) NSUInteger IVAIndex;
@property (nonatomic, assign) GLuint textureName;
@property (nonatomic, assign) GLenum minMagFilter;
@property (nonatomic, assign) ImageDetails *imageDetails;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGPoint textureOffset;
@property (nonatomic, assign) float rotation;
@property (nonatomic, assign) Scale2f scale;
@property (nonatomic, assign) BOOL flipHorizontally;
@property (nonatomic, assign) BOOL flipVertically;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) Color4f color;
@property (nonatomic, assign) CGPoint rotationPoint;
@property (nonatomic, assign) CGRect subImageRectangle;

// Designated initializer that is used to create a new Image instance.  It takes the
// name of the image file to be used as the texture within the image and also details
// about scale and imageFilter.
- (id)initWithImageNamed:(NSString*)aName filter:(GLenum)aFilter;

// Initializer which also takes sub region information and initializes the image to only 
// render a sub region of the texture.  The sub region is defined using a CGRect and the 
// size of the images quad will match the size of the sub textures dimensions
- (id)initWithImageNamed:(NSString*)aName filter:(GLenum)aFilter subTexture:(CGRect)aSubTexture;

// Returns an Image which represents the specified sub region of this image
- (Image*)subImageInRect:(CGRect)aRect;

// Returns a new Image instance that is a copy of the current image.  The caller is respponsible for
// retaining the copy.
// "Duplicate" was used in this method name to stop the static analyzer in Xcode from reporting an issue
// namely "Object with +0 retain count returned to caller where a +1 (owning) retain count is expected"
// if the word "Copy" was used in the method name.  By convention a method that begins with alloc, new or
// contains copy should return at object with a retain count of 1.  This method should return an autoreleased
// object as the caller is responsbile for owning it, so the word "Duplicate" was used in the method name to
// follow convention.
- (Image*)imageDuplicate;

// Changes the dimensions of the image rendered based on the % values passed in.  The values for
// width and height should range from 0 to 100.  This is the percentage of the total image width and 
// height that will be rendered next time the image is rendered.  These settings will stay in place
// until they are changed.  This method simply changes the geometry and texture information for this
// image causing a sub region of the image to be rendered
- (void)setImageSizeToRender:(CGSize)aImageSize;

// Adds the current images index to the queue in the image render manager.
// This will cause this image to be renered when the image render manager is next 
// asked to render.
- (void)render;

// Renders the image to the point provided.  It also adds the image to the
// render managers queue so that the image will be rendered when the render manager is
// next asked to render.
- (void)renderAtPoint:(CGPoint)aPoint;

// Renders the image at |aPoint| with the |aScale|, |aRotation|
- (void)renderAtPoint:(CGPoint)aPoint scale:(Scale2f)aScale rotation:(float)aRotation;

// Method to rendered centered on the images current point location
- (void)renderCentered;

// Renders the image centered at the point provided
- (void)renderCenteredAtPoint:(CGPoint)aPoint;

// Renders the imaged centered at |aPoint| with |aScale| and |aRotation|
- (void)renderCenteredAtPoint:(CGPoint)aPoint scale:(Scale2f)aScale rotation:(float)aRotation;

@end

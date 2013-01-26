#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "SynthesizeSingleton.h"
#import "Global.h"

@class Image;

// Defines the maximum number of images that can be sent to the render manager
// before issuing a render command
#define kMax_Images 250
#define kMax_Textures 20

// This class is responsbile for rendering all Image content to the screen using
// OpenGL.  Each time an image is asked to render it calls the render manager
// which takes a copy of the images TexturedColoredQuad informaiton and loads
// it into the render managers IVA.
//
// This information is then used to render the images when the renderImages method is called
// Each texture on the queue is rendered in turn which means all images that use the same 
// texture get rendered together.  This reduces the number of texture binds that are necessary.
// Side effects are that using multiple textures can make it difficult to get the ordering of
// where images are rendered on the screen correctly.
//
@interface ImageRenderManager : NSObject {

    ///////////////////// Render
    TexturedColoredVertex *iva;						// Interleaved Vertex Array that holds the vertex, texture and color information needed
													// to render
    GLushort *ivaIndices;							// Array of indices into the interleaved vertex array.  Used within glDrawElements to 
													// define which elements within the IVA should be rendered
    NSUInteger textureIndices[kMax_Textures][kMax_Images];		// Array which holds the textures to be rendered.  The first dimension holds the texture
																// name and the second dimension holds the IVAIndex of an image which should be rendered
																// when that texture is being processed
    NSUInteger texturesToRender[kMax_Textures];	    // Array to store a list of the textures which need to be rendered.  Each time an image
													// is added to the render queue with a texture which has not been added to the queue before
													// the new texture name is added to this array.  This array then drives the textures which
													// are processed during a render
    NSUInteger imageCountForTexture[kMax_Images];   // Array to store the number of images within each texture to be rendered.  The texture
													// name is used for the index
    NSUInteger renderTextureCount;					// Number textures to render
    GLushort ivaIndex;							    // Current count of quads defined within the RenderManagers IVA

}

// Class method that returns an instance of the RenderManager class.  If an instance has 
// already been created then this instance is returned, otherwise a new instance is created 
// and returned.
+ (ImageRenderManager *)sharedImageRenderManager;

// Method to add an imaged ImageDetails to the render queue.  The images renderIndex is taken from the
// ImageDetails passed in and used to add this images IVA entry to the list of elements 
// inside the IVA which are going to be rendered.
- (void)addImageDetailsToRenderQueue:(ImageDetails*)aImageDetails;

// Method to add a TexturedColoredQuad to the render queue.  This allows image informaiton to be added to the
// queue without the need for an Image instance.  This is used in classes such as TiledMap.
- (void)addTexturedColoredQuadToRenderQueue:(TexturedColoredQuad*)aTCQ texture:(uint)aTexture;

// Method used to render all images which have been placed on the render queue using
// |addToRenderQueue|.
- (void)renderImages;


@end
#import "ESRenderer.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@class GameController;

@interface ES1Renderer : NSObject <ESRenderer> {
    
@private
	EAGLContext *context;
	
	// The pixel dimensions of the CAEAGLLayer
	GLint backingWidth;
	GLint backingHeight;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint defaultFramebuffer, colorRenderbuffer;
    
    // Game controller reference
    GameController *sharedGameController;
	
	BOOL openGLInitialized;
}

// This methods asks the current scene to render and then presents the rendered
// scene to the screen
- (void) render;


- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;

@end

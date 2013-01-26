#import "EAGLView.h"
#import "ES1Renderer.h"
#import "GameController.h"
#import "ImageRenderManager.h"
#import "AbstractScene.h"

#pragma mark -
#pragma mark Private interface
@interface EAGLView (Private)


// Called regularly by either a CADisplayLink or NSTimer.  Its responsible for
// updating the game logic and rendering a game scene
- (void)gameLoop;

@end

#pragma mark -
#pragma mark Public implementation

@implementation EAGLView
@synthesize button;
@synthesize animating;
@dynamic animationFrameInterval;

- (void) dealloc
{
    [renderer release];
    [super dealloc];
}

// It is necessary to override this class so that the core animation layer can be 
// returned when the layerClass is requested for OpenGL to work.
+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

#pragma mark -
#pragma mark Init EAGLView

- (id) initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithCoder:coder]))
	{
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], 
										kEAGLDrawablePropertyRetainedBacking, 
                                        kEAGLColorFormatRGB565, 
										kEAGLDrawablePropertyColorFormat, 
                                        nil];
		
		// Set up an OpenGL ES 1.1 renderer
		renderer = [[ES1Renderer alloc] init];
		
		// If the renderer is empty then something wen wrong so release this instance
		// and return nothing
        if (!renderer)
        {
            [self release];
            return nil;
        }
        
		// Set up the animation displaylink and timer variables
		animating = FALSE;
		displayLinkSupported = FALSE;
		animationFrameInterval = 1;
		displayLink = nil;
		animationTimer = nil;
		
		// A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
		// class is used as fallback when it isn't available.
		NSString *reqSysVer = @"3.1";
		NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
		if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
			displayLinkSupported = TRUE;
        
        // Grab a reference to the game controller and set the eaglView property to point to this instance
		// of EAGLView
        sharedGameController = [GameController sharedGameController];
		sharedGameController.eaglView = self;
    }
	
    return self;
}

#pragma mark -
#pragma mark Main Game Loop

#define MAXIMUM_FRAME_RATE 120		// Must also be set in ParticleEmitter.m
#define MINIMUM_FRAME_RATE 15
#define UPDATE_INTERVAL (1.0 / MAXIMUM_FRAME_RATE)
#define MAX_CYCLES_PER_FRAME (MAXIMUM_FRAME_RATE / MINIMUM_FRAME_RATE)

- (void)gameLoop {

	static double lastFrameTime = 0.0f;
	static double cyclesLeftOver = 0.0f;
	double currentTime;
	double updateIterations;
	
	// Apple advises to use CACurrentMediaTime() as CFAbsoluteTimeGetCurrent() is synced with the mobile
	// network time and so could change causing hiccups.
	currentTime = CACurrentMediaTime();
	updateIterations = ((currentTime - lastFrameTime) + cyclesLeftOver);
	
	if(updateIterations > (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL))
		updateIterations = (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL);
	
	while (updateIterations >= UPDATE_INTERVAL) {
		updateIterations -= UPDATE_INTERVAL;
		
		// Update the game logic passing in the fixed update interval as the delta
		[sharedGameController updateCurrentSceneWithDelta:UPDATE_INTERVAL];		
	}
	
	cyclesLeftOver = updateIterations;
	lastFrameTime = currentTime;

	// Render the scene
    [self drawView:nil];
}

- (void) drawView:(id)sender
{
    [renderer render];
}

- (void) layoutSubviews
{
	[renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self gameLoop];
}

#pragma mark -
#pragma mark Animation Control

- (NSInteger) animationFrameInterval
{
	return animationFrameInterval;
}

- (void) setAnimationFrameInterval:(NSInteger)frameInterval
{
	// Frame interval defines how many display frames must pass between each time the
	// display link fires. The display link will only fire 30 times a second when the
	// frame internal is two on a display that refreshes 60 times a second. The default
	// frame interval setting of one will fire 60 times a second when the display refreshes
	// at 60 times a second. A frame interval setting of less than one results in undefined
	// behavior.
	if (frameInterval >= 1)
	{
		animationFrameInterval = frameInterval;
		
		if (animating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

- (void) startAnimation
{
	if (!animating)
	{
		if (displayLinkSupported)
		{
			// CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
			// if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
			// not be called in system versions earlier than 3.1.

			displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(gameLoop)];
			[displayLink setFrameInterval:animationFrameInterval];
			[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            NSLOG(@"INFO - EAGLView: Timer using CADisplayLink");
		} else {
			animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / MAXIMUM_FRAME_RATE) * animationFrameInterval) target:self selector:@selector(gameLoop) userInfo:nil repeats:TRUE];
            NSLOG(@"INFO - EAGLView: Timer using NSTimer");
        }
        
        animating = TRUE;
		lastTime = CACurrentMediaTime();
	}
}

- (void)stopAnimation
{
	if (animating)
	{
		if (displayLinkSupported)
		{
			[displayLink invalidate];
			displayLink = nil;
		}
		else
		{
			[animationTimer invalidate];
			animationTimer = nil;
		}
		
		animating = FALSE;
	}
}

#pragma mark -
#pragma mark Touches

// All touch events are passed to the current scene for processing.  The only local processing
// which is done is to capture taps that represent a request for the settings view.  This should
// be possible from any view so it is performed at the EAGLView level

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {

	// Pass touch events onto the current scene
	[[sharedGameController currentScene] touchesBegan:touches withEvent:event view:self];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	// Pass touch events onto the current scene
	[[sharedGameController currentScene] touchesMoved:touches withEvent:event view:self];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	// Pass touch events onto the current scene
	[[sharedGameController currentScene] touchesEnded:touches withEvent:event view:self];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
	// Pass touch events onto the current scene
	[[sharedGameController currentScene] touchesCancelled:touches withEvent:event view:self];
}

- (IBAction)actionButton:(id)sender
{
	// Pass click events onto the current scene
	[[sharedGameController currentScene] clickedShootButton];
}

@end

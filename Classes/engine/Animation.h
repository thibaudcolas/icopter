#import "Global.h"

enum {
    kAnimationState_Running = 0,
    kAnimationState_Stopped = 1
};

enum {
    kAnimationType_Repeating = 0,
    kAnimationType_PingPong = 1,
    kAnimationType_Once = 2
};

// This class represents a collection of frames which can be animated.  The class
// allows for any number of images to be added to the animation specifying the
// image to be used for the image as well as how long the image should be displayed 
// before moving to the next image.
//
@interface Animation : NSObject {

    NSUInteger state;	    // State of the animationx
    NSUInteger type;		// Type of animation i.e. repeating, ping pong or once
    NSInteger direction;    // Direction in which the animation is running
    NSUInteger maxFrames;   // Maximum allowed frames in this animation
    NSInteger currentFrame; // Current frame of the animation
    AnimationFrame *frames; // Array of frames for this animation
    float displayTime;		// Accumulates the time while a frame is displayed
    NSInteger frameCount;   // Total frames within the animation
	NSUInteger bounceFrame;	// Frame at which animation should repeat or pingpong rather than when it
							// hits the last frame or first frame

}

@property (nonatomic, assign) NSUInteger state;
@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, assign) NSInteger currentFrame;
@property (nonatomic, assign) NSUInteger bounceFrame;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign, readonly) NSUInteger maxFrames;
@property (nonatomic, assign, readonly) NSInteger frameCount;

// Designated initializer for the animation class which takes a capacity and
// creates the necessary storage for this animation
- (id)init;

- (id)createFromImageNamed:(NSString*)path frameSize:(CGSize)frameSize spacing:(int)spacing margin:(int)margin delay:(float)animationDelay state:(NSUInteger)state type:(NSUInteger)type length:(int)frameNumber;

- (id)createFromImageNamed:(NSString*)path frameSize:(CGSize)frameSize spacing:(int)spacing margin:(int)margin delay:(float)animationDelay state:(NSUInteger)state type:(NSUInteger)type columns:(int)nbColumns rows:(int)nbRows;

// Adds a frame to the animation
- (void)addFrameWithImage:(Image*)aImage delay:(float)aDelay;

// Updates the animation causing the timer to be progressed and the animation to 
// move as defined
- (void)updateWithDelta:(float)aDelta;

// Returns a pointer to the image for the current frame
- (Image*)currentFrameImage;

// Returns the image for the frame index provided
- (Image*)imageForFrame:(NSUInteger)aIndex;

// Sets the point of rotation for all images in the animation
- (void)rotationPoint:(CGPoint)aPoint;

// Renders the animation at |aPoint|
- (void)renderAtPoint:(CGPoint)aPoint;

// Renders the animation at |aPoint| with |aScale| and |aRotation|
- (void)renderAtPoint:(CGPoint)aPoint scale:(Scale2f)aScale rotation:(float)aRotation;

// Renders the animation centered at the |aPoint|
- (void)renderCenteredAtPoint:(CGPoint)aPoint;

// Renders the animation centered at |aPoint| with |aScale| and |aRotation|
- (void)renderCenteredAtPoint:(CGPoint)aPoint scale:(Scale2f)aScale rotation:(float)rotation;

@end

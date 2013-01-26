#import "Animation.h"
#import "SpriteSheet.h"
#import "Image.h"


@implementation Animation

@synthesize state;
@synthesize type;
@synthesize direction;
@synthesize currentFrame;
@synthesize maxFrames;
@synthesize bounceFrame;
@synthesize frameCount;

- (void)dealloc
{
    // Loop through the frames array and release all the frames which we have
	if (frames) {
		for(int i=0; i<frameCount; i++)
        {
			AnimationFrame *frame = &frames[i];
			[frame->image release];
		}
		free(frames);
	}
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if(self != nil)
    {
		// Init the animations properties
        maxFrames = 5;
        frameCount = 0;
        currentFrame = 0;
        state = kAnimationState_Stopped;
        type = kAnimationType_Once;
        direction = 1;
		bounceFrame = -1;
		
		// Initialize the array that will store the animation frames
        frames = calloc(maxFrames, sizeof(AnimationFrame));

    }
    return self;
}

- (id)createFromImageNamed:(NSString*)path frameSize:(CGSize)frameSize spacing:(int)spacing margin:(int)margin delay:(float)animationDelay state:(NSUInteger)animationState type:(NSUInteger)animationType length:(int)animationLength
{
    self = [self init];
    if (self != nil)
    {
        SpriteSheet* spriteSheet = [[SpriteSheet alloc] initWithImageNamed:path spriteSize:frameSize spacing:spacing margin:margin imageFilter:GL_LINEAR];
		
        state = animationState;
        type = animationType;
		bounceFrame = animationLength;
		for(int i = 0; i < animationLength; i++)
        {
            [self addFrameWithImage:[spriteSheet spriteImageAtCoords:CGPointMake(i, 0)] delay:animationDelay];
		}
        [spriteSheet release];
    }
    
    return self;
}

- (id)createFromImageNamed:(NSString*)path frameSize:(CGSize)frameSize spacing:(int)spacing margin:(int)margin delay:(float)animationDelay state:(NSUInteger)animationState type:(NSUInteger)animationType columns:(int)nbColumns rows:(int)nbRows {
    self = [self init];
    if (self != nil)
    {
        SpriteSheet* spriteSheet = [[SpriteSheet alloc] initWithImageNamed:path spriteSize:frameSize spacing:spacing margin:margin imageFilter:GL_LINEAR];
		
        state = animationState;
        type = animationType;
		bounceFrame = nbRows * nbColumns;;
		for(int i = 0; i < nbRows; i++)
        {
            for(int j = 0; j < nbColumns; j++)
                [self addFrameWithImage:[spriteSheet spriteImageAtCoords:CGPointMake(j, i)] delay:animationDelay];
		}
        [spriteSheet release];
    }
    
    return self;
}

#define FRAMES_TO_EXTEND 5

- (void)addFrameWithImage:(Image*)aImage delay:(float)aDelay
{
	
    // If we try to add more frames than we have storage for then increase the storage
    if(frameCount+1 > maxFrames) {
        maxFrames += FRAMES_TO_EXTEND;
		frames = realloc(frames, sizeof(AnimationFrame) * maxFrames);
    }
	
    // Set the image and delay based on the arguments passed in
    frames[frameCount].image = [aImage retain];
    frames[frameCount].delay = aDelay;
	
	frameCount++;

}

- (void)updateWithDelta:(float)aDelta
{
    // We only need to update the animation if its running
    if(state != kAnimationState_Running)
        return;

    // Increment the displayTime with the delta value sent in from the game loop
    displayTime += aDelta;
    
    // If the displayTime has exceeded the current frames delay then switch frames
    if(displayTime > frames[currentFrame].delay)
    {
        currentFrame += direction;

		// Rather than set displayTime back to 0, we set it to the difference between the 
		// displayTime and frames delay. This will cause frames to be skipped as necessary
		// if the game should bog down
		displayTime = displayTime - frames[currentFrame].delay;
        
        // If we have reached the end or start of the animation, decide on what needs to be 
        // done based on the animations type
        if (type == kAnimationType_PingPong && (currentFrame == 0 || currentFrame == frameCount-1 || currentFrame == bounceFrame)) {
            direction = -direction;
        } else if (currentFrame > frameCount-1 || currentFrame == bounceFrame) {
            if (type != kAnimationType_Repeating) {
				currentFrame -= 1;
                state = kAnimationState_Stopped;
			} else {
				currentFrame = 0;
			}
        }
    }
}

- (Image*)currentFrameImage
{
    return frames[currentFrame].image;
}

- (Image*)imageForFrame:(NSUInteger)aIndex
{
    if(aIndex > frameCount) {
        NSLog(@"WARNING - Animation: Invalid frame index");
        return nil;
    }
    return frames[aIndex].image;
}

- (void)rotationPoint:(CGPoint)aPoint {
    for(int i=0; i<frameCount; i++) {
        [frames[i].image setRotationPoint:aPoint];
    }
}

- (void)setRotation:(float)aRotation {
    for(int i=0; i<frameCount; i++) {
        [frames[i].image setRotation:aRotation];
    }
}

- (void)renderAtPoint:(CGPoint)aPoint {
    [self renderAtPoint:aPoint scale:frames[currentFrame].image.scale rotation:frames[currentFrame].image.rotation];
}

- (void)renderAtPoint:(CGPoint)aPoint scale:(Scale2f)aScale rotation:(float)aRotation {
    [frames[currentFrame].image renderAtPoint:aPoint scale:aScale rotation:aRotation];    
}

- (void)renderCenteredAtPoint:(CGPoint)aPoint {
    [self renderCenteredAtPoint:aPoint scale:frames[currentFrame].image.scale rotation:frames[currentFrame].image.rotation];
}

- (void)renderCenteredAtPoint:(CGPoint)aPoint scale:(Scale2f)aScale rotation:(float)aRotation {
    [frames[currentFrame].image renderCenteredAtPoint:aPoint scale:aScale rotation:aRotation];    
}

@end

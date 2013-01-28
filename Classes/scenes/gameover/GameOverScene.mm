#import "GameOverScene.h"
#import "Global.h"
#import "ImageRenderManager.h"
#import "GameController.h"
#import "Image.h"
#import "BitmapFont.h"
#import "SoundManager.h"
#import "TextureManager.h"
#import "PackedSpriteSheet.h"
#import "SpriteSheet.h"
#import "Primitives.h"


@implementation GameOverScene

- (void)dealloc {
	[background release];
    
	[super dealloc];
}

- (id)init {
	
	if(self == [super init]) {
        
		// Set the name of this scene
		self.name = @"gameover";
		
		sharedImageRenderManager = [ImageRenderManager sharedImageRenderManager];
		sharedGameController = [GameController sharedGameController];
		sharedSoundManager = [SoundManager sharedSoundManager];
		sharedTextureManager = [TextureManager sharedTextureManager];
        background= [[Image alloc] initWithImageNamed:@"GameOver.png" filter:GL_LINEAR];    
        
		// Init the fadespeed and alpha for this scene
		fadeSpeed = 1.0f;
		alpha = 1.0f;
		
	}
    return self;
}

- (void)updateSceneWithDelta:(float)aDelta {
}

- (void)transitionIn {

}

- (void)renderScene {
    
    glClear(GL_COLOR_BUFFER_BIT);
	// Render the background
	
    [background renderAtPoint:CGPointMake(0, 0)];;
    
	[sharedImageRenderManager renderImages];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	
	// Get the point where the player has touched the screen
	CGPoint originalTouchLocation = [touch locationInView:aView];
	
	CGPoint touchLocation = originalTouchLocation;
    touchLocation.x = originalTouchLocation.y;
    touchLocation.y = originalTouchLocation.x;
    
	// We only want to check the touches on the screen when the scene is running.
	//if (state == kSceneState_Running) {
    // Check to see if the user touched the start button
    if (CGRectContainsPoint(CGRectMake(0, 0, 500, 500), touchLocation)) {
        // Ask the game controller to transition to the scene called Menu.
        [sharedGameController transitionToSceneWithKey:@"menu"];
        return;
    }
    
    NSLog(@"Aucun menu Touch");
}

- (void)updateHighlight {
	//buttonPressed = NO;
}

@end

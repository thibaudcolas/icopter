#import "SettingsScene.h"
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


@implementation SettingsScene

- (void)dealloc {
	[super dealloc];
}

- (id)init {
	
	if(self == [super init]) {
        
		// Set the name of this scene
		self.name = @"settings";
		
		sharedImageRenderManager = [ImageRenderManager sharedImageRenderManager];
		sharedGameController = [GameController sharedGameController];
		sharedSoundManager = [SoundManager sharedSoundManager];
		sharedTextureManager = [TextureManager sharedTextureManager];


	}
    return self;
}

- (void)updateSceneWithDelta:(float)aDelta {

}

- (void)transitionIn {

}

- (void)renderScene {
    glClear(GL_COLOR_BUFFER_BIT);
   	[sharedImageRenderManager renderImages];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
    UITouch *touch = [[event touchesForView:aView] anyObject];
	
	// Get the point where the player has touched the screen
	CGPoint originalTouchLocation = [touch locationInView:aView];
	
	CGPoint touchLocation = originalTouchLocation;
    touchLocation.x = originalTouchLocation.y;
    touchLocation.y = originalTouchLocation.x;
    
    if (CGRectContainsPoint(CGRectMake(0, 0, 480, 320), touchLocation)) {
        NSLog(@"Test Menu New Game dans if");
        [sharedGameController transitionToSceneWithKey:@"menu"];
    }
}

- (void)updateHighlight {
	//buttonPressed = NO;
}

@end

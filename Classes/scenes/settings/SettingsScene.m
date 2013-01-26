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

// Set up the strings for the menu items
# define startString @"New Game"
# define resumeString @"Resume Game"
# define scoreString @"Score"
# define creditString @"Credits"

- (id)init {
	
	if(self == [super init]) {
        
		// Set the name of this scene
		self.name = @"settings";
		
		sharedImageRenderManager = [ImageRenderManager sharedImageRenderManager];
		sharedGameController = [GameController sharedGameController];
		sharedSoundManager = [SoundManager sharedSoundManager];
		sharedTextureManager = [TextureManager sharedTextureManager];

        background= [[Image alloc] initWithImageNamed:@"GameOver.png" filter:GL_LINEAR];


	}
    return self;
}

- (void)updateSceneWithDelta:(float)aDelta {

}

- (void)transitionIn {

}

- (void)renderScene {
 	[background renderAtPoint:CGPointMake(0, 0)];
   	[sharedImageRenderManager renderImages];

}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
    
    NSLog(@"Aucun menu Touch");
}

- (void)updateHighlight {
	//buttonPressed = NO;
}

@end

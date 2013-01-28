#import "GameController.h"
#import "SLQTSORAppDelegate.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "EAGLView.h"
#import "SoundManager.h"
#import "SettingsScene.h"


#pragma mark -
#pragma mark Private interface

@interface GameController (Private) 
// Initializes OpenGL
- (void)initGameController;

@end

#pragma mark -
#pragma mark Public implementation

@implementation GameController

@synthesize currentScene;
@synthesize gameScenes;
@synthesize eaglView;

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(GameController);

- (void)dealloc {
    [gameScenes release];
	[highScores release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if(self != nil) {
		
		// Initialize the game
        [self initGameController];
    }
    return self;
}

#pragma mark -
#pragma mark Update & Render

- (void)updateCurrentSceneWithDelta:(float)aDelta {
    [currentScene updateSceneWithDelta:aDelta];
}

-(void)renderCurrentScene {
    [currentScene renderScene];
}

#pragma mark -
#pragma mark Transition

- (void)transitionToSceneWithKey:(NSString*)aKey {
	currentScene = [gameScenes objectForKey:aKey];
	[currentScene transitionIn];
}

#pragma mark -
#pragma mark Orientation adjustment

- (CGPoint)adjustTouchOrientationForTouch:(CGPoint)aTouch
{	
	CGPoint touchLocation = aTouch;
	touchLocation.y = 0 + aTouch.y;
	
	return touchLocation;
}

@end

#pragma mark -
#pragma mark Private implementation

@implementation GameController (Private)

- (void)initGameController {

    NSLOG(@"INFO - GameController: Starting game initialization.");
	
	// Load the game scenes
    gameScenes = [[NSMutableDictionary alloc] init];
    
    //Init menu
    // Menu scene
	AbstractScene *scene = [[GameScene alloc] init];
	[gameScenes setValue:scene forKey:@"game"];
	[scene release];
    
    
    scene = [[MenuScene alloc] init];
    [gameScenes setValue:scene forKey:@"menu"];
	[scene release];
	//Init game
	
    
    scene= [[SettingsScene alloc] init];
    [gameScenes setValue:scene forKey:@"settings"];
	[scene release];

    // Set the starting scene for the game
    currentScene = [gameScenes objectForKey:@"menu"];
    
	
    NSLOG(@"INFO - GameController: Finished game initialization.");
    
    
    
    
}



@end

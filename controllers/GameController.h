#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"
#import "EAGLView.h"
#import "Global.h"

@class AbstractScene;
@class EAGLView;

// Class responsbile for passing touch and game events to the correct game
// scene.  A game scene is an object which is responsible for a specific
// scene within the game i.e. Main menu, main game, high scores etc.
// The state manager hold the currently active scene and the game controller
// will then pass the necessary messages to that scene.
//
@interface GameController : NSObject <UIAccelerometerDelegate> {
	
	///////////////////// Views and orientation
	EAGLView *eaglView;						// Reference to the EAGLView
	UIInterfaceOrientation interfaceOrientation;	// Devices interface orientation
	
    ///////////////////// Game controller iVars	
	CGRect screenBounds;					// Bounds of the screen
    NSDictionary *gameScenes;				// Dictionary of the different game scenes
	NSArray *highScores;					// Sorted high scores array
	NSMutableArray *unsortedHighScores;		// Unsorted high scores array
    AbstractScene *currentScene;			// Current game scene being updated and rendered
	
}

@property (nonatomic, retain) EAGLView *eaglView;
@property (nonatomic, retain) AbstractScene *currentScene;
@property (nonatomic, retain) NSDictionary *gameScenes;

// Class method to return an instance of GameController.  This is needed as this
// class is a singleton class
+ (GameController *)sharedGameController;

// Updates the logic within the current scene
- (void)updateCurrentSceneWithDelta:(float)aDelta;

// Renders the current scene
- (void)renderCurrentScene;

// Causes the game controller to select a new scene as the current scene
- (void)transitionToSceneWithKey:(NSString*)aKey;

// Returns an adjusted touch point based on the orientation of the device
- (CGPoint)adjustTouchOrientationForTouch:(CGPoint)aTouch;

@end

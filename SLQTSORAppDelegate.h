#import <UIKit/UIKit.h>

@class EAGLView;
@class SoundManager;
@class GameController;

@interface SLQTSORAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EAGLView *glView;
	
	// Sound manager reference
	SoundManager *sharedSoundManager;
	GameController *sharedGameController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;

@end


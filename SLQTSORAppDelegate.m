#import "SLQTSORAppDelegate.h"
#import "Global.h"
#import "EAGLView.h"
#import "GameController.h"
#import "GameScene.h"

#pragma mark -
#pragma mark Private interface

@interface SLQTSORAppDelegate (Private)

// Loads the settings from the settings plist file into the 
// sound manager
- (void)loadSettings;

@end

#pragma mark -
#pragma mark Public implementation

@implementation SLQTSORAppDelegate

@synthesize window;
@synthesize glView;

- (void) dealloc
{
	[window release];
	[glView release];
	[super dealloc];
}

- (void) applicationDidFinishLaunching:(UIApplication *)application
{
	//[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPaysag];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	[glView setMultipleTouchEnabled:YES];
	[glView startAnimation];
}

- (void) applicationWillResignActive:(UIApplication *)application
{
	[glView stopAnimation];
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
	[glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[glView stopAnimation];
}

@end


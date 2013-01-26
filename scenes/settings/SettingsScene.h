#import <UIKit/UIKit.h>
#import "AbstractScene.h"

@class SoundManager;
@class GameController;
@class ImageRenderManager;
@class SoundManager;
@class TextureManager;
@class GameController;
@class Image;
@class BitmapFont;
@class PackedSpriteSheet;
@class Player;

// The settings view controller is used to display the settings to the player.  It fades
// over the EAGLView and displays a slider for the music and fx volume allowing
// the player to select the settings they would like to use.  This class observes the
// "showSettings" notification which is how it knows when to fade the settings view
// into place.  The view layout and objects are defined in the SettingsView.xib file
// This view is added as a subview to EAGLView when it appears and then removed when it
// is done.  Only the first subview of EAGLView will respond to rotation events and
// we need this view as well as the high score view to rotate.  To overcome this we
// add and remove views to EAGLView as necessary.
//
@interface SettingsScene : AbstractScene {

	//////////////////// Singleton references
	ImageRenderManager *sharedImageRenderManager;
	GameController *sharedGameController;
	SoundManager *sharedSoundManager;
	TextureManager *sharedTextureManager;
	
	//////////////////// IBOutlets for the view
    Image *background;					// Background image for the menu

    
    IBOutlet UISlider *musicVolume;						// Controls the music volume
	IBOutlet UIButton *menuButton;						// Button that returns the player to the main menu

	//////////////////// Flags
	BOOL isVisible;										// is the settings view currently visible
}


@end

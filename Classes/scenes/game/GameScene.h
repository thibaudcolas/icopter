#import "AbstractScene.h"
#import "ImageRenderManager.h"
#import "GameController.h"
#import "SoundManager.h"
#import "SpriteSheet.h"
#import "PackedSpriteSheet.h"
#import "Animation.h"
#import "EAGLView.h"
#import "Image.h"

#import "Background.h"
#import "ExplosionManager.h"
#import "GameHUD.h"
#import "Helicopter.h"
#import "RocketLauncher.h"
#import "Ufo.h"
#import "Score.h"

#define MAX_FMOD_AUDIO_CHANNELS 10

@class Image;
@class RocketLauncher;
@class Background;
@class ExplosionManager;
@class ImageRenderManager;
@class SoundManager;
@class GameController;
@class SpriteSheet;
@class PackedSpriteSheet;
@class Animation;
@class BitmapFont;
@class TiledMap;
@class ParticleEmitter;
@class Ufo;
@class GoText;
@class Helicopter;

Helicopter *helicopter;
NSMutableArray *rocketLaunchers;
FMOD_EVENTPROJECT *project;
FMOD_EVENTGROUP *generalGroup;


@interface GameScene : AbstractScene
{
	////////////////////// Singleton references
	GameController *sharedGameController;// Reference to the game controller
	ImageRenderManager *sharedImageRenderManager;// Reference to the image render manager
    
    SoundManager *sharedSoundManager;
	FMOD_EVENTSYSTEM *eventSystem;
    FMOD_EVENTPARAMETER *nbUfoParam,*nbRocketLauncherParam,*timeParam;// parameter of the event_music_game
    
    FMOD_EVENTCATEGORY *game;
    FMOD_EVENT *generalEvent;
    FMOD_EVENT *pauseEvent;

	NSMutableDictionary *previousTouchTimestamps;
    NSMutableDictionary *fmodEventsForTouches;
    
    float timeEllapsed;
    //NSTimeInterval secondsElapsed;
    
    //================= Background ===============//
    const float groundAltitude;
    Background* background;
    
    Score* score;    
    GameHUD* hud;
    
    ExplosionManager* sharedExplosionManager;

    //============================================//

    //============= ROCKET LAUNCHER ==============//
    float createRocketLauncherTimer;
    int maxNumRocketLauncher;//nombre max de rocketLaunchers a l'ecran
    int createRocketLauncherTimeout;//temps au bout duquel un rocketLauncher est cree (tant que numRocketLauncher<maxNumRocketLauncher)
	CGSize rocketLauncherRectangleSize;// Height and Width of the rocketLauncher touch rectangle
    //============================================// 
    
    int killedRocketLaunchers;
    
	//================ Classe UFO ================//
    NSMutableArray *ufos;
    float createUfoTimer;
    int maxNumUfo;//nombre max d'ufo a l'ecran
    int createUfoTimeout;//temps au bout duquel un ufo est cree (tant que numUfo<maxNumUfo)
	CGSize ufoRectangleSize;
    //============================================//
    
	float joypadDistance;
	float joypadDirection;
	int joypadTouchHash;		  
	// This allows us to track the same touch during touchesMoved events
	BOOL isJoypadTouchMoving;	
	//============================================//  

}

@end

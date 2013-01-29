//
//  GameHUD.m
//  

#import "GameHUD.h"
#import "PackedSpriteSheet.h"

@implementation GameHUD

@synthesize pauseButtonBounds;
@synthesize shootButtonBounds;

// Initialise l'interface du jeu.
- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        PackedSpriteSheet *masterSpriteSheet = [PackedSpriteSheet packedSpriteSheetForImageNamed:@"hud-atlas.png" controlFile:@"hud-coordinates" imageFilter:GL_LINEAR];

        go = [[GoText alloc] init:[[Animation alloc] createFromImage:[[masterSpriteSheet imageForKey:@"hud-go"] retain] frameSize:CGSizeMake(33, 31) spacing:0 margin:0 delay:0.1f state:kAnimationState_Running type:kAnimationType_Once columns:16 rows:1]];
        
        life = [[BatteryLevel alloc] init:[[Animation alloc] createFromImage:[[masterSpriteSheet imageForKey:@"hud-battery"] retain] frameSize:CGSizeMake(22, 25) spacing:0 margin:0 delay:0.1f state:kAnimationState_Running type:kAnimationType_PingPong columns:6 rows:1]];
        
        scoreValue = 0;
        scoreDisplay = [[BitmapFont alloc] initWithFontImageNamed:@"franklin16.png" controlFile:@"franklin16" scale:Scale2fMake(1.1f, 1.1f) filter:GL_LINEAR];
        scorePanel = [[masterSpriteSheet imageForKey:@"hud-scorepanel"] retain];
        
        scoreArrow = [[Animation alloc] createFromImage:[[masterSpriteSheet imageForKey:@"hud-arrow"] retain] frameSize:CGSizeMake(30, 17) spacing:0 margin:0 delay:0.1f state:kAnimationState_Stopped type:kAnimationType_Once columns:11 rows:1];
        
        pauseLabel = [[masterSpriteSheet imageForKey:@"hud-pauselabel"] retain];
        pauseButton = [[masterSpriteSheet imageForKey:@"hud-pausebutton"] retain];
        // Il faut que les coordonnées soient inversées pour que la détection de touch fonctionne.
        // Probablement parce que les coordonnées des touch ne sont pas tournées comme le sont celles de OpenGL.
        pauseButtonBounds = CGRectMake(285, 340, 20, 30);
        
        shootButton = [[masterSpriteSheet imageForKey:@"hud-shootbutton"] retain];
        // Il faut que les coordonnées soient inversées pour que la détection de touch fonctionne.
        // Probablement parce que les coordonnées des touch ne sont pas tournées comme le sont celles de OpenGL.
        shootButtonBounds = CGRectMake(30, 400, 32, 32);
        
        joypad = [[Joypad alloc] init:[[masterSpriteSheet imageForKey:@"hud-joypad"] retain]];
        
        numberFormatter= [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        [masterSpriteSheet release];
        
        NSLog(@"INFO - HUD: Created successfully");
    }
    return self;
}

- (void) update:(float)delta score:(int)value kill:(bool)hasKilled left:(int)batteriesLeft
{
    [go update:delta];
    [life update:delta left:batteriesLeft];
    
    [scoreArrow updateWithDelta:delta];
    
    if (scoreArrow.state == kAnimationState_Stopped) {
        if (hasKilled) {
            scoreArrow.state = kAnimationState_Running;
            scoreArrow.currentFrame = 0;
        }
        else {
            scoreArrow.currentFrame = 0;
        }
    }
    
    scoreValue = value;
}

// Affiche notre HUD.
- (void) render:(uint)state
{
    [go render];
    [life render];
    [scorePanel renderAtPoint:CGPointMake(375, 285)];
    
    if (scoreArrow.state == kAnimationState_Running) {
        [scoreArrow renderAtPoint:CGPointMake(377, 292)];
        scoreDisplay.fontColor = Color4fMake(0.99f, 0.9f, 0.4f, 1.0f);
    }
    else {
        scoreDisplay.fontColor = Color4fMake(0.95f, 0.7f, 0.3f, 1.0f);
    }
    
    [scoreDisplay renderStringJustifiedInFrame:CGRectMake(385, 288, 80, 24) justification:BitmapFontJustification_MiddleRight text:[numberFormatter stringFromNumber:[NSNumber numberWithInt:scoreValue]]];
    
    
    
    [pauseButton renderAtPoint:CGPointMake(340, 285)];
    [shootButton renderAtPoint:CGPointMake(400, 30)];
    
    [joypad render];
    
    if (state == kSceneState_Paused) [pauseLabel renderCenteredAtPoint:CGPointMake(240, 160)];
}

- (CGPoint)getJoypadCenter {
    return [joypad getCenter];
}

- (CGRect)getJoypadBounds {
    return [joypad getBounds];
}


// Libère la mémoire utilisée.
- (void) dealloc
{
    [go dealloc];
    [scoreDisplay release];
    [numberFormatter release];
    
    [pauseLabel release];
    [pauseButton release];
    
    [joypad dealloc];
    
    [super dealloc];
}

@end

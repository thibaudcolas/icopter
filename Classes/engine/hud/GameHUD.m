//
//  GameHUD.m
//  

#import "GameHUD.h"

@implementation GameHUD

@synthesize pauseButtonBounds;

// Initialise l'interface du jeu.
- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        go= [[GoText alloc] init];
        scoreValue= 0;
        scoreDisplay = [[BitmapFont alloc] initWithFontImageNamed:@"franklin16.png" controlFile:@"franklin16" scale:Scale2fMake(1.1f, 1.1f) filter:GL_LINEAR];
        scorePanel= [[Image alloc] initWithImageNamed:@"red-score-panel.png" filter:GL_LINEAR];
        
        scoreArrow = [[Animation alloc] createFromImageNamed:@"score-arrow.png" frameSize:CGSizeMake(30, 17) spacing:0 margin:0 delay:0.1f state:kAnimationState_Stopped type:kAnimationType_Once length:11];
        
        pauseLabel= [[Image alloc] initWithImageNamed:@"pause-label.png" filter:GL_LINEAR];
        pauseButton= [[Image alloc] initWithImageNamed:@"red-pause-button.png" filter:GL_LINEAR];
        // Il faut que les coordonnées soient inversées pour que la détection de touch fonctionne.
        // Probablement parce que les coordonnées des touch ne sont pas tournées comme le sont celles de OpenGL.
        pauseButtonBounds= CGRectMake(285, 340, 20, 30);
        
        joypad = [[Joypad alloc] init];
        
        numberFormatter= [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSLog(@"INFO - HUD: Created successfully");
    }
    return self;
}

- (void) update:(float)delta score:(int)value kill:(bool)hasKilled
{
    [go update:delta];
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
    [scorePanel renderAtPoint:CGPointMake(375, 285)];
    [scoreDisplay renderStringJustifiedInFrame:CGRectMake(385, 288, 80, 24) justification:BitmapFontJustification_MiddleRight text:[numberFormatter stringFromNumber:[NSNumber numberWithInt:scoreValue]]];
    
    if (scoreArrow.state == kAnimationState_Running) [scoreArrow renderAtPoint:CGPointMake(377, 292)];
    
    [pauseButton renderAtPoint:CGPointMake(340, 285)];
    
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

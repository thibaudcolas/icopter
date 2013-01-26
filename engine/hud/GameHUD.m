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
        
        pauseLabel= [[Image alloc] initWithImageNamed:@"pause-label.png" filter:GL_LINEAR];
        pauseButton= [[Image alloc] initWithImageNamed:@"red-pause-button.png" filter:GL_LINEAR];
        // Il faut que les coordonnées soient inversées pour que la détection de touch fonctionne.
        // Probablement parce que les coordonnées des touch ne sont pas tournées comme le sont celles de OpenGL.
        pauseButtonBounds= CGRectMake(285, 340, 20, 30);
        
        numberFormatter= [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSLog(@"INFO - HUD: Created successfully");
    }
    return self;
}

- (void) update:(float)delta score:(int)value
{
    [go update:delta];
    scoreValue = value;
}

// Affiche notre HUD.
- (void) render:(uint)state
{
    [go render];
    [scorePanel renderAtPoint:CGPointMake(375, 285)];
    [scoreDisplay renderStringJustifiedInFrame:CGRectMake(385, 288, 80, 24) justification:BitmapFontJustification_MiddleRight text:[numberFormatter stringFromNumber:[NSNumber numberWithInt:scoreValue]]];
    
    [pauseButton renderAtPoint:CGPointMake(340, 285)];
    
    if (state == kSceneState_Paused) [pauseLabel renderCenteredAtPoint:CGPointMake(240, 160)];
}

// Libère la mémoire utilisée.
- (void) dealloc
{
    [go dealloc];
    [scoreDisplay release];
    [numberFormatter release];
    [super dealloc];
}

@end
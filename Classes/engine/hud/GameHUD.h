//
//  GameHUD.h
//

#import <Foundation/Foundation.h>
#import "GoText.h"
#import "Joypad.h"
#import "BitmapFont.h"
#import "Image.h"

@interface GameHUD : NSObject
{    
    GoText *go;
    int scoreValue;
	BitmapFont *scoreDisplay;
    Image *pauseLabel;
    Image *scorePanel;
    Image *pauseButton;
    CGRect pauseButtonBounds;
    
    Joypad *joypad;
    
    NSNumberFormatter *numberFormatter;
}

@property (nonatomic, getter = getPauseButtonBounds) CGRect pauseButtonBounds;

- (id)init;

- (void)update:(float)delta score:(int)scoreValue;

- (void)render:(uint)state;

- (CGPoint)getJoypadCenter;

- (CGRect)getJoypadBounds;

- (void)dealloc;

@end

//
//  GameHUD.h
//

#import <Foundation/Foundation.h>
#import "GoText.h"
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
    
    NSNumberFormatter *numberFormatter;
}

@property (nonatomic, getter = getPauseButtonBounds) CGRect pauseButtonBounds;

- (id)init;

- (void)update:(float)delta score:(int)scoreValue;

- (void)render:(uint)state;

- (void)dealloc;

@end

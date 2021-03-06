//
//  Affichage "Go !" de début de partie.
//

#import <Foundation/Foundation.h>
#import "Animation.h"
#import "FmodSoundManager.h"

@interface GoText : NSObject
{
    CGPoint position;
    Animation *animation;
    FmodSoundManager *sharedFmodSoundManager;
}

@property(nonatomic)CGPoint position;

- (id) init:(Animation*)anim;

- (void) update:(float)delta;

- (void) render;

@end

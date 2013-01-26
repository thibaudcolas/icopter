//
//  Affichage "Go !" de début de partie.
//

#import <Foundation/Foundation.h>
#import "Animation.h"

@interface GoText : NSObject
{
    
    CGPoint position;
    Animation *animation;
    
    //FMOD
    FMOD_EVENT *goEvent;

}

@property(nonatomic)CGPoint position;

- (id) init;

- (void) update:(float)delta;

- (void) render;

@end

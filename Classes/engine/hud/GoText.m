//
//  Affichage "Go !" de début de partie.
//

#import "GoText.h"
extern FMOD_EVENTGROUP *generalGroup;

@implementation GoText

@synthesize position;

- (id)init:(Animation*)anim
{
	self= [super init];
    
	if (self!= nil)
    {
        position= CGPointMake(240, 300);
        
		animation= anim;
        
        [sharedFmodSoundManager add:goSound];
	}
	return self;
	
}

- (void)update:(float)delta
{
    [animation updateWithDelta:delta];
}

- (void)render
{
    if (animation.state == kAnimationState_Running)
    {
        [animation renderCenteredAtPoint:position];
    }
}

// Libère la mémoire utilisée.
- (void)dealloc
{
    [animation release];
    [sharedFmodSoundManager stop:goSound immediate:true];
    [super dealloc];
}

@end

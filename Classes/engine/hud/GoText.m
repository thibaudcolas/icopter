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
        
        goEvent = NULL;
        // create an instance of the FMOD event
       FMOD_EventGroup_GetEvent(generalGroup, "go_sound", FMOD_EVENT_DEFAULT, &goEvent);
        // trigger the event
        FMOD_Event_Start(goEvent);

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
    FMOD_Event_Stop(goEvent, false);
    [super dealloc];
}

@end

#import <Foundation/Foundation.h>
#import "Animation.h"

enum {
    uOVNI_classicType = 0,
    uOVNI_michouType = 1
};

extern FMOD_EVENTPROJECT *project;

@interface OVNIManager : NSObject {
    
    NSMutableArray *ovnis;
    
    FMOD_EVENT *classicEvent;
    FMOD_EVENT *michouEvent;
    
    CGSize classicSize;
    CGSize michouSize;
    
    float timeApparition;
    float counterApparition;
    
    int maxNumber;
    
    CGPoint defaultSpawnPoint;
    
    Animation *classicAnimation;
    Animation *michouAnimation;
}

// Returns as instance of the OVNIManager class.  If an instance has already been created
// then this instance is returned, otherwise a new instance is created and returned.
+ (OVNIManager *)sharedOVNIManager;

- (id)init;

- (void)update:(float)delta;

- (void)render;

- (void)dealloc;


@end
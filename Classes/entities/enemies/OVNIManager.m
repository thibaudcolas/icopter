#import "SynthesizeSingleton.h"
#import "OVNIManager.h"
#import "OVNI.h"

@implementation OVNIManager

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(OVNIManager);

- (id) init {
    self = [super init];
    
    if (self != nil) {
        
        FMOD_EVENTGROUP *ovniGroup;
        FMOD_EventProject_GetGroup(project, "ufo", 1, &ovniGroup);
        
        FMOD_EventGroup_GetEvent(ovniGroup, "ufo_sound", FMOD_EVENT_DEFAULT, &classicEvent); 
        FMOD_EventGroup_GetEvent(ovniGroup, "ufo_sound_michou", FMOD_EVENT_DEFAULT, &michouEvent); 
        FMOD_Event_Stop(classicEvent, false);
        FMOD_Event_Stop(michouEvent, false);
        
        ovnis = [[NSMutableArray alloc] init];
        
        classicSize = CGSizeMake(50, 30);
        michouSize = CGSizeMake(40, 40);
        
        maxNumber = 5;
        
        timeApparition = 10;
        counterApparition = 0;
        
        defaultSpawnPoint = CGPointMake([[UIScreen mainScreen] bounds].size.height, 100);
        
        classicAnimation = [[Animation alloc] createFromImageNamed:@"ufo-classic.png" frameSize:CGSizeMake(55.83, 31) spacing:0 margin:0 delay:0.05f state:kAnimationState_Stopped type:kAnimationType_Once length:12];
        michouAnimation = [[Animation alloc] createFromImageNamed:@"flying-michou.png" frameSize:CGSizeMake(44, 43) spacing:0 margin:0 delay:0.05f state:kAnimationState_Running type:kAnimationType_Repeating length:16];
        
        NSLog(@"INFO - OVNIManager: Created successfully");
    }
    return self;
}

- (void) add {
    // Choisit au hasard où l'UFO sera.
    int kind = arc4random()%2;
    
    CGPoint spawnPoint = defaultSpawnPoint;
    int maxAltitude = [[UIScreen mainScreen] bounds].size.width;
    
    switch (kind) {
        case uOVNI_classicType : 
            if ([ovnis count] == 0) FMOD_Event_Start(classicEvent);
            spawnPoint.y = arc4random()%(int)((maxAltitude - classicSize.height) / 2) + (maxAltitude / 2);
            [ovnis addObject:[[OVNI alloc] init:classicAnimation position:spawnPoint size:classicSize]];
            break;
        case uOVNI_michouType :
            if ([ovnis count] == 0) FMOD_Event_Start(michouEvent);
            spawnPoint.y = arc4random()%(int)((maxAltitude - michouSize.height) / 2) + (maxAltitude / 2);
            [ovnis addObject:[[OVNI alloc] init:michouAnimation position:spawnPoint size:michouSize]];
            break;
        default:
            if ([ovnis count] == 0) FMOD_Event_Start(classicEvent);
            spawnPoint.y = arc4random()%(int)((maxAltitude - classicSize.height) / 2) + (maxAltitude / 2);
            [ovnis addObject:[[OVNI alloc] init:classicAnimation position:spawnPoint size:classicSize]];
            break;
    }
}

- (void) update:(float)delta {
    OVNI* tmp;
    
    for (int i = 0; i < [ovnis count]; i++) {
        tmp = [ovnis objectAtIndex:i];
        [tmp update:delta];
        if (false) {
            [ovnis removeObjectAtIndex:i];
            [tmp dealloc];
        }
    }
    
    if ([ovnis count] == 0) {
        FMOD_Event_Stop(classicEvent, false);
        FMOD_Event_Stop(michouEvent, false);
    }
    
    counterApparition += delta;
    if ([ovnis count] < maxNumber && (timeApparition < counterApparition + (arc4random() % 5))) {
        [self add];
        counterApparition = 0;
    }
}


- (void) render {
    for (int i = 0; i < [ovnis count]; i++) {
        [[ovnis objectAtIndex:i] render];
    }
}


// Libère la mémoire utilisée.
- (void) dealloc {
    [ovnis release];
    NSLog(@"INFO - OVNIManager: Removed successfully");
    [super dealloc];
}

@end

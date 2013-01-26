//
//  Gestion du score en prenant en compte la longueur de la partie.
//

#import "Score.h"
#import "SynthesizeSingleton.h"

@implementation Score

@synthesize duration;
@synthesize value;
@synthesize player;

- (id)init {
    self = [super init];
    
	if (self != nil) {
        player = @"test";
        value = 0;
        interval = 2;
        killBonus = 5000;
        scale = 5;
        duration = 0;
        killCount = 0;
        
        NSLog(@"INFO - Score: Created successfully");
    }
    
    return self;
}

// Met à jour la durée de jeu écoulée et le score selon cette durée.
- (void)update:(float)delta kills:(int)nbKills {
    
    // Gestion du nombre de tués effectués.
    value += (nbKills - killCount) * killBonus * scale;
    killCount = nbKills;
    
    // delta = Temps écoulé depuis le dernier update.
    duration += delta;
    
    if ((int)duration > 1) {
        if ((int)duration % interval == 0) {
            value += interval * scale;
        }
        
        // Augmentation chaque minute.s
        if ((int)duration % 60 == 0) {
            value += 1000 * scale;
        }
    }
}

- (void)augment:(int)val {
    value += val > 0 ? val : 0;
}

- (void)decrease:(int)val {
    value -= val > 0 ? val : 0;
}

- (void)dealloc {
    NSLog(@"INFO - Score: Removed successfully");
    [super dealloc];
}

@end

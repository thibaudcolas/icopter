#import "OVNI.h"

@implementation OVNI

- (id) init:(Animation*)anim position:(CGPoint)pos size:(CGSize)entitySize {
    self = [super init:anim position:pos size:entitySize];
    
    sinModifier = 0;
    direction = mDirection_RightToLeft;
    speed = arc4random() % 50 + 50;
    sinModifierIncrease = true;
    
    NSLog(@"INFO - OVNI: Created successfully");
    
    return self;
}

- (void) update:(float)delta {
    sinModifierIncrease = (sinModifierIncrease && sinModifier <= 20) || (!sinModifierIncrease && sinModifier <= -20);
    sinModifier += sinModifierIncrease ? 1 : -1;
    position.y += sinModifierIncrease ? 0.2 : -0.2;
    
    [super update:delta];
}

- (void) dealloc {
    NSLog(@"INFO - OVNI: Removed successfully");
    [super dealloc];
}

@end

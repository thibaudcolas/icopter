//
//  Gestion du joypad.
//

#import "Joypad.h"

@implementation Joypad

@synthesize bounds;
@synthesize center;

- (id)init:(Image*)img
{
	self= [super init];
    
	if (self!= nil)
    {
        int size = 40;
        
        image = img;
        center = CGPointMake(size + 10, size + 10);
        bounds = CGRectMake(center.x - size, center.y - size, size * 2, size * 2);
        
            NSLog(@"INFO - Joypad: Created successfully");
    }
	return self;
	
}

- (void)render
{
    [image renderCenteredAtPoint:center];
}

// Libère la mémoire utilisée.
- (void)dealloc
{
    [image release];
    NSLog(@"INFO - Joypad: Removed successfully");
    [super dealloc];
}

@end

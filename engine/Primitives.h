#import <objc/objc.h>
#import "Global.h"

@interface Primitives

@end

// Renders a rectangle to the screen based on the CGRect structure passed in
void drawRect(CGRect aRect);

// Render a circle to the screen based on the Circle structure passed in
void drawCircle(Circle aCircle, uint aSegments);
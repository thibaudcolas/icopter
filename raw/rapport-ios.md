// # Animations et spritesheets

// https://en.wikipedia.org/wiki/Sprite_%28computer_graphics%29#Sprites_by_CSS

// Analogie CSS requêtes HTTP

// metalslug.gif
// items.png
// flying-michou.png


SpriteSheet* spriteSheet = [[SpriteSheet alloc] initWithImage:image spriteSize:frameSize spacing:spacing margin:margin];

    for(int i = 0; i < nbRows; i++) {
            for(int j = 0; j < nbColumns; j++)
                [self addFrameWithImage:[spriteSheet spriteImageAtCoords:CGPointMake(j, i)] delay:animationDelay];
    }

        [spriteSheet release];

//# Effet "Parallax"



- (void) addLayer:(int)ordinate image:(Image*)img {

    // Plus un élément est loin de la route (i.e ajouté tôt), plus il est lent.
    float calcSpeed = ([layers count] * [layers count] + 1) * 10 * speed;

    [layers addObject:[[BGLayer alloc] init:calcSpeed ord:ordinate image:img]];
}

- (void) render {

    float currentAbs = position.x;
    // Afficher plusieurs fois l'image si elle est plus petite que l'écran.
    while(currentAbs < screenWidth + [image size].width) {
        [image renderAtPoint:CGPointMake(currentAbs, position.y)];
        currentAbs += [image imageSize].width - 1;
    }
}


// Moon Patrol, 1982

// https://en.wikipedia.org/wiki/Parallax_scrolling


SYNTHESIZE_SINGLETON_FOR_CLASS(ExplosionManager);

PackedSpriteSheet *master = [PackedSpriteSheet packedSpriteSheetForImageNamed:@"explosion-atlas.png" controlFile:@"explosion-coordinates" imageFilter:GL_LINEAR];

for (int i = 0; i < [explosions count]; i++) {
    tmp = [explosions objectAtIndex:i];
    [tmp update:delta];
    if ([tmp isOver]) {
        [explosions removeObjectAtIndex:i];
        [tmp autorelease];
    }
}

- (void) dealloc {
  [rocketLauncherDestroyed release];
  [explosions release];
  [super dealloc];
}

//
//  Gestion du score en prenant en compte la longueur de la partie.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject {

    // Durée de la partie.
    float duration;
    // Nombre d'ennemis tués depuis le début de la partie.
    int killCount;
    int value;
    // Multiplicateur de base du score.
    int scale;
    // Multiplicateur du score pour chaque kill
    int killBonus;
    // Intervalle avant que le score augmente.
    int interval;
    NSString *player;
    
}

@property (nonatomic, assign) float duration;
@property (nonatomic, getter = getValue) int value;
@property (nonatomic, assign) NSString* player;


- (id)init;

- (void)update:(float)delta kills:(int)nbKills;

- (void)augment:(int)val;

- (void)decrease:(int)val;

- (void)dealloc;

@end

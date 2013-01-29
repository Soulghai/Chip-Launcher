//
//  Statistics.m
//  Expand_It
//
//  Created by Mac Mini on 13.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CellsBackground.h"
#import "Defs.h"
#import "GameStandartFunctions.h"
#import "globalParam.h"

@implementation CellsBackground


- (id)init {
	if ((self = [super init])) {
        cells = [NSMutableArray arrayWithCapacity:6*8];
        [cells retain];
        
        cellCountX = 21;
        cellCountY = 31;
        cellWidth = 16;
        cellHeight = 16;
        
        cellsHighMap = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:5000],
                        [NSNumber numberWithInt:15000],
                        [NSNumber numberWithInt:30000],
                        [NSNumber numberWithInt:50000],nil];
        [cellsHighMap retain];
        
        cellCurrentFrames = [NSMutableArray arrayWithCapacity:cellCountX*cellCountY];
        for (int i = 0; i < cellCountX*cellCountY; i++) {
            [cellCurrentFrames addObject:[NSNumber numberWithInteger:0]];
        }
        [cellCurrentFrames retain];
        
        CCSprite *_spr;
        for (int i = 0; i < cellCountX; i++) {
            for (int j = 0; j < cellCountY; j++) {
                _spr = [CCSprite spriteWithSpriteFrameName:@"cell_1_1.jpg"];
                [_spr setAnchorPoint:CGPointZero];
                [_spr setOpacity:200];
                [cells addObject:_spr];
            }
        }
    }
	
	return self;
}

-(void) restartParameters {
    CCSprite *_spr;
    CCSpriteFrame* frame;
    for (int i = 0; i < cells.count; i++) {
        _spr = [cells objectAtIndex:i];
        [_spr setPosition:ccp((i % cellCountX)*cellWidth, (int)round(i / cellCountX)*cellHeight)];
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cell_1_1.jpg"];
        [_spr setDisplayFrame:frame];
    }
    
    for (int i = 0; i < cellCurrentFrames.count; i++) {
        [cellCurrentFrames replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:0]];
    }
}

- (void) setClearSprite:(CCSprite*)_spr {
     CCSpriteFrame* _frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cell_0.jpg"];
    [_spr setDisplayFrame:_frame];
}

- (void) manageCells {
    BOOL _flag;
    CCSprite *_spr;
    for (int i = 0; i < cells.count; i++) {
        _spr = [cells objectAtIndex:i];
        _flag = NO;
        
        if (_spr.position.y + [Defs instance].objectFrontLayer.position.y < -cellHeight) {
            _spr.position = ccp(_spr.position.x, _spr.position.y + cellCountY*cellHeight);
            _flag = YES;
        } else
            if (_spr.position.y + [Defs instance].objectFrontLayer.position.y > cellCountY*cellHeight - cellHeight) {
                _spr.position = ccp(_spr.position.x, _spr.position.y - + cellCountY*cellHeight);
                _flag = YES;
            }
        
        if (_spr.position.x + [Defs instance].objectFrontLayer.position.x < -cellWidth) {
            _spr.position = ccp(_spr.position.x + cellCountX*cellWidth, _spr.position.y);
            _flag = YES;
        } else
            if (_spr.position.x + [Defs instance].objectFrontLayer.position.x > cellCountX*cellWidth - cellWidth) {
                _spr.position = ccp(_spr.position.x - cellCountX*cellWidth, _spr.position.y);
                _flag = YES;
            }
        
        // Меняем вид текстуры
        if (_flag)
            [self changeCellSkin:_spr _currentLevel:[[cellCurrentFrames objectAtIndex:i] intValue]+1];
    }
}

- (void) changeCellSkin:(CCSprite*)_spr
          _currentLevel:(int)_currentLevel{
    
    if (!_spr.parent) [[Defs instance].spriteSheetCells addChild:_spr z:0];
    
    if (_currentLevel > 4) _currentLevel = 4;
    CCSpriteFrame* frame;
    float _ran = CCRANDOM_0_1()*13;
    if (_ran <= 11)
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"cell_%i_1.jpg",_currentLevel]];
    else {
        int _ranCellNumber = 1 + int(round(CCRANDOM_0_1()*3));
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"cell_%i_%i.jpg",_currentLevel,_ranCellNumber]];
    }
    [_spr setDisplayFrame:frame];
    
}

- (void) update {
    [self manageCells];
    
    CCSprite *_spr;
    for (int i = 0; i < cells.count; i++) {
        _spr = [cells objectAtIndex:i];
        
        int _currHighLevel = cellsHighMap.count - 1;   // если вдруг мы добрались до самого верха, то всегда будем видеть последнюю текстуру
        for (int i = 0; i < cellsHighMap.count; i++) {
            if (_spr.position.y < [[cellsHighMap objectAtIndex:i] intValue]) {
                _currHighLevel  = i;
                break;
            }
        }
        
        if ([[cellCurrentFrames objectAtIndex:i] intValue] != _currHighLevel) {
            [self changeCellSkin:_spr _currentLevel:_currHighLevel+1];
            [cellCurrentFrames replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:_currHighLevel]];
        }
    }
}

- (void) show:(BOOL)_flag{
	if (isVisible != _flag) {
        
		isVisible = _flag;
        
        CCSprite *_spr;
        for (int i = 0; i < cells.count; i++) {
            _spr = [cells objectAtIndex:i];
            if (isVisible){
                if (!_spr.parent) [[Defs instance].spriteSheetCells addChild:_spr z:0 tag:i];
            }else {
                if (_spr.parent) [_spr removeFromParent];
            }
        }
	}
}

-(void) ccTouchMoved:(CGPoint)_touchLocation
	   _prevLocation:(CGPoint)_prevLocation
			   _diff:(CGPoint)_diff {
    
    CGPoint _touchPos = ccpAdd(_touchLocation, ccp(0,-[Defs instance].objectFrontLayer.position.y));
    
	CCSprite *_spr;
    for (int i = 0; i < cells.count; i++) {
        _spr = [cells objectAtIndex:i];
        if ((_touchPos.x > _spr.position.x - cellWidth*0.5f)&&(_touchPos.x < _spr.position.x + cellWidth*0.5f)
            &&(_touchPos.y < _spr.position.y + cellHeight*0.5f)&&(_touchPos.y > _spr.position.y - cellHeight*0.5f)) {
            //[self setClearSprite:_spr];
            if (_spr.parent) [_spr removeFromParentAndCleanup:NO];
        }
    }
}

@end

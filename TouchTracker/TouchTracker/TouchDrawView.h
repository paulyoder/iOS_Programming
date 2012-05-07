//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Paul Yoder on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Line;

@interface TouchDrawView : UIView <UIGestureRecognizerDelegate>
{
  NSMutableDictionary *linesInProcess;
  NSMutableArray *completeLines;
  
  UIPanGestureRecognizer *moveRecognizer;
}

@property (nonatomic, weak) Line *selectedLine;

- (Line *)lineAtPoint:(CGPoint)p;
- (void)clearAll;
- (void)endTouches:(NSSet *)touches;

@end

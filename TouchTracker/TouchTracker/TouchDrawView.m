//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Paul Yoder on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"

@implementation TouchDrawView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    linesInProcess = [[NSMutableDictionary alloc] init];
    completeLines = [[NSMutableArray alloc] init];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setMultipleTouchEnabled:YES];
  }
  return self;
}


- (void)clearAll
{
  // Clear the collections
  [completeLines removeAllObjects];
  [linesInProcess removeAllObjects];
  
  // Redraw
  [self setNeedsDisplay];
}

- (void)endTouches:(NSSet *)touches
{
  // Remove ending touches from dictionary
  for (UITouch *t in touches) {
    NSValue *key = [NSValue valueWithNonretainedObject:t];
    Line *line = [linesInProcess objectForKey:key];
    
    // If this is a double tap, 'line' will be nil,
    // so make sure not to add it to the array
    if (line) {
      [completeLines addObject:line];
      [linesInProcess removeObjectForKey:key];
    }
  }
  [self setNeedsDisplay];
}

#pragma mark overrides

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, 10.0);
  CGContextSetLineCap(context, kCGLineCapRound);
  
  // Draw complete lines in black
  [[UIColor blackColor] set];
  for (Line *line in completeLines) {
    CGContextMoveToPoint(context, [line begin].x, [line begin].y);
    CGContextAddLineToPoint(context, [line end].x, [line end].y);
    CGContextStrokePath(context);
  }
  
  // Draw lines in process in red
  [[UIColor redColor] set];
  for (NSValue *v in linesInProcess) {
    Line *line = [linesInProcess objectForKey:v];
    CGContextMoveToPoint(context, [line begin].x, [line begin].y);
    CGContextAddLineToPoint(context, [line end].x, [line end].y);
    CGContextStrokePath(context);
  }
}

#pragma mark touch delegates

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  for (UITouch *t in touches) {
    // Is this a double tap?
    if ([t tapCount] > 1) {
      [self clearAll];
      return;
    }
    
    // Use the touch object (packed in NSValue) as the key
    NSValue *key = [NSValue valueWithNonretainedObject:t];
    
    // Create a line for the value
    CGPoint loc = [t locationInView:self];
    Line *newLine = [[Line alloc] init];
    [newLine setBegin:loc];
    [newLine setEnd:loc];
    
    // Put pair in dictionary
    [linesInProcess setObject:newLine forKey:key];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  // Update linesInProcess with moved touches
  for (UITouch *t in touches) {
    NSValue *key = [NSValue valueWithNonretainedObject:t];
    
    // Find the line for this touch
    Line *line = [linesInProcess objectForKey:key];
    
    // Update the line
    CGPoint loc = [t locationInView:self];
    [line setEnd:loc];
  }
  
  // Redraw
  [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self endTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self endTouches:touches];
}


@end

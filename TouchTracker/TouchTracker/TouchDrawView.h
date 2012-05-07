//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Paul Yoder on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchDrawView : UIView
{
  NSMutableDictionary *linesInProcess;
  NSMutableArray *completeLines;
}

- (void)clearAll;
- (void)endTouches:(NSSet *)touches;

@end

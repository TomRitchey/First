//
//  UIViewWithBorder.m
//  mu first app
//
//  Created by Kacper Augustyniak on 27/05/2015.
//  Copyright (c) 2015 Kacper Augustyniak. All rights reserved.
//

#import "UIViewWithBorder.h"

@implementation UIViewWithBorder

- (void)drawRect:(CGRect)rect {
    //self.lineWidth = 5.0;
    CGRect circleDraw;
    /* Set UIView Border */
    // Get the contextRef
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // Set the border width
    CGContextSetLineWidth(contextRef, self.lineWidth);
    
    // Set the border color to RED
    CGContextSetRGBStrokeColor(contextRef, 255.0, 0.0, 0.0, 1.0);
    
    // Draw the border along the view edge
    //CGContextStrokeRect(contextRef, rect);
    
    circleDraw.origin.x = rect.origin.x+self.lineWidth;
    circleDraw.origin.y = rect.origin.y+self.lineWidth;
    circleDraw.size.width = rect.size.width-2*self.lineWidth;
    circleDraw.size.height= rect.size.height-2*self.lineWidth;
    
    CGContextStrokeEllipseInRect(contextRef, circleDraw);
    
    if(self.pizzaParts > 1){
    for (int i =1; i <= self.pizzaParts ; i++) {

    
    CGFloat x1 = (cosf(i*2*M_PI/self.pizzaParts+self.startAngle)*circleDraw.size.width/2)+circleDraw.size.width/2+self.lineWidth;
    CGFloat y1 = (sinf(i*2*M_PI/self.pizzaParts +self.startAngle)*circleDraw.size.height/2)+circleDraw.size.height/2+self.lineWidth;
    
    CGContextMoveToPoint(contextRef, rect.size.width/2, rect.size.height/2);
    //NSLog(@"center %f, %f ", rect.size.width-rect.origin.x, rect.size.height-rect.origin.y);
    CGContextAddLineToPoint(contextRef,x1 , y1);
    //NSLog(@"center 2 %f, %f ", x1, y1);
    CGContextStrokePath(contextRef);
    }
    
}
    
}

@end

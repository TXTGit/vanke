//
//  CallOutAnnotationView.m
//  vanke
//
//  Created by pig on 13-6-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "CallOutAnnotationView.h"
#import <QuartzCore/QuartzCore.h>

#define Arror_height 6

@implementation CallOutAnnotationView

@synthesize contentView = _contentView;
@synthesize busInfoView = _busInfoView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -55);
        self.frame = CGRectMake(0, 0, 240, 80);
        
        UIView *tempContentView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width-15, self.frame.size.height-15)];
        tempContentView.backgroundColor = [UIColor clearColor];
        [self addSubview:tempContentView];
        _contentView = tempContentView;
        
    }
    return self;
}

-(void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

-(void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    
    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat midy = CGRectGetMidY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect) - Arror_height;
    CGContextMoveToPoint(context, midx + Arror_height, maxy);
    CGContextAddLineToPoint(context, midx, maxy + Arror_height);
    CGContextAddLineToPoint(context, midx - Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}


@end

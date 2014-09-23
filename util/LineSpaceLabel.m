//
//  LineSpaceLabel.m
//  LOL
//
//  Created by baojuan on 14-9-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "LineSpaceLabel.h"
#import <CoreText/CoreText.h>
#import<Foundation/Foundation.h>
@implementation LineSpaceLabel
{
    NSMutableAttributedString *attributedString;

}
@synthesize lineSpace = lineSpace_;
@synthesize charSpace = charSpace_;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lineSpace_ = 5.0;
        charSpace_ = 2.0;
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    lineSpace_ = 5.0;
    charSpace_ = 2.0;
}

-(void)setCharSpace:(CGFloat)charSpace{
    charSpace_ = charSpace;
    [self setNeedsDisplay];
}
-(void)setLineSpace:(CGFloat)lineSpace{
    lineSpace_ = lineSpace;
//    [self drawTextInRect:self.bounds];
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self createString];
}

-(void) drawTextInRect:(CGRect)requestedRect

{
    [self createString];
    //排版
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);

    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    
    CGPathAddRect(leftColumnPath, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), leftColumnPath , NULL);
    
    //翻转坐标系统（文本原来是倒的要翻转下）
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextClearRect(context, self.bounds);
    
    
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    
    //画出文本
    
    CTFrameDraw(leftFrame,context);
    
    //释放
    
    CGPathRelease(leftColumnPath);
    
    CFRelease(framesetter);
    
    
    
    UIGraphicsPushContext(context);
    
    [self.delegate calculateCellHeight:self.size.height];
    
}

- (void)createString
{
    //创建AttributeString
    if (attributedString == nil) {
        attributedString =[[NSMutableAttributedString alloc]initWithString:self.text];
        
        //设置字体及大小
        
        CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)self.font.fontName,self.font.pointSize,NULL);
        
        [attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)helveticaBold range:NSMakeRange(0,[attributedString length])];
        
        //设置字间距
        
        if(self.charSpace)
            
        {
            long number = self.charSpace;
            CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
            [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
            CFRelease(num);
        }
        
        //设置字体颜色
        
        [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(id)(self.textColor.CGColor) range:NSMakeRange(0,[attributedString length])];
        
        //创建文本对齐方式
        
        CTTextAlignment alignment = kCTLeftTextAlignment;
        
        if(self.textAlignment == NSTextAlignmentCenter)
        {
            alignment = kCTCenterTextAlignment;
            
        }
        
        if(self.textAlignment == NSTextAlignmentRight)
            
        {
            
            alignment = kCTRightTextAlignment;
            
        }
        
        CTParagraphStyleSetting alignmentStyle;
        
        alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
        
        alignmentStyle.valueSize = sizeof(alignment);
        
        alignmentStyle.value = &alignment;
        
        //设置文本行间距
        
        CGFloat lineSpace = self.lineSpace;
        
        CTParagraphStyleSetting lineSpaceStyle;
        
        lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
        
        lineSpaceStyle.valueSize = sizeof(lineSpace);
        
        lineSpaceStyle.value =&lineSpace;
        
        //设置文本段间距
        CGFloat paragraphSpacing = 1.0;
        
        CTParagraphStyleSetting paragraphSpaceStyle;
        
        paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
        
        paragraphSpaceStyle.valueSize = sizeof(CGFloat);
        
        paragraphSpaceStyle.value = &paragraphSpacing;
        
        
        
        //创建设置数组
        
        CTParagraphStyleSetting settings[ ] ={alignmentStyle,lineSpaceStyle,paragraphSpaceStyle};
        
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings ,3);
        
        //给文本添加设置
        
        [attributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0 , [attributedString length])];
        CFRelease(helveticaBold);
        

    }
}

- (CGFloat)height
{
//    //排版
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
//    CFRange range = CFRangeMake(0, attributedString.length);
//    self.size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0, 0),NULL, CGSizeMake(self.bounds.size.width, CGFLOAT_MAX), &range);
//    
//    return self.size.height;
    
    
    [self createString];
    
    CGFloat total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, self.frame.size.width, 100000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 100000 - line_y + descent;
    
    CFRelease(textFrame);
    
    return total_height;
    
    
}

- (CGFloat)insertIntoContentWithContent:(NSString *)string
{
    self.text = string;
//    [self drawTextInRect:self.bounds];
    return [self height];
}


@end

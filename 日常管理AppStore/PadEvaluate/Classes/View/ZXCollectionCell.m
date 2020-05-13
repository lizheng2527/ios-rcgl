//
//  ZXCollectionCell.m
//  ImageViewTest
//

#import "ZXCollectionCell.h"

@implementation ZXCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.frame)-10, CGRectGetWidth(self.frame)-10)];
        self.imgView.layer.masksToBounds = YES;
        self.imgView.layer.cornerRadius = 4.0f;
        [self addSubview:self.imgView];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        self.imgView.userInteractionEnabled = YES;
        [self.imgView addGestureRecognizer:ges];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.imgView.frame), CGRectGetWidth(self.frame)-10, 20)];
        self.text.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.text];
        
        _close  = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * image = [UIImage imageNamed:@"delete"];
        [_close setImage:image forState:UIControlStateNormal];
        [_close setFrame:CGRectMake(self.frame.size.width-image.size.width, 0, image.size.width, image.size.height)];
        [_close sizeToFit];
        [_close addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_close];
    }
    return self;
}
-(void)closeBtn:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(moveImageBtnClick:)]) {
        [_delegate moveImageBtnClick:self];
    }
}

-(void)tapAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showAlertController:)]) {
        [_delegate showAlertController:self];
    }
}

@end

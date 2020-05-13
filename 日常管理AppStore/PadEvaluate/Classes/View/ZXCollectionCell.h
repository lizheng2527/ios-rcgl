//
//  ZXCollectionCell.h
//  ImageViewTest
//

#import <UIKit/UIKit.h>

@class ZXCollectionCell;

@protocol ZXCollectionCellDelegate <NSObject>
@required
-(void)moveImageBtnClick:(ZXCollectionCell *)aCell;
-(void)showAlertController:(ZXCollectionCell *)aCell;
@end

@interface ZXCollectionCell : UICollectionViewCell
@property(nonatomic ,strong)UIImageView *imgView;
@property(nonatomic ,strong)UILabel *text;
@property(nonatomic ,strong)UIButton *btn;
@property(nonatomic,strong)UIButton * close;
@property(nonatomic,assign)id<ZXCollectionCellDelegate>delegate;

@end

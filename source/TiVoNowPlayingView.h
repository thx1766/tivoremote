// TiVoNowPlayingView
/*

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/
#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UITextView.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UITransitionView.h>
#import <UIKit/UIProgressHUD.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UITable.h>

@interface TiVoContainerItemTableCell:UIImageAndTextTableCell
{
    id value;
    id parent;
}
-(void)setParent:(id) parent;
-(void)setValue:(id) value;
-(id)getValue;
@end

@interface TiVoNowPlayingView: UIView
{
    UINavigationBar *navBar;
    UINavigationBar *bottomNavBar;
    UITransitionView *body;
    UIProgressHUD   *progress;
    NSMutableArray  *views;
    NSMutableArray  *model;
    struct CGRect    bodyRect;
    BOOL             disclosure;
}

- (id)initWithFrame:(struct CGRect)rect;
- (void) refresh:(id) param;
- (void) showDetails:(TiVoContainerItemTableCell *) cell;

@end






/** 首页按钮点击方法替换*/
defineClass('ViewController', {
            buttonAction: function(sender) {
            var tab = JPViewController.alloc().init()
            self.navigationController().pushViewController_animated(tab, YES)
        }
})

/** 更改，替换JPViewController页面的tabelview的点击方法*/
defineClass('JPViewController' , {
            tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
            var tab = JPTableViewController.alloc().init()
            self.navigationController().pushViewController_animated(tab, YES)
            }
})

/** tableviewController*/
defineClass('JPTableViewController : UITableViewController <UIAlertViewDelegate>', {
 dataSource: function() {
   var data = self.getProp('data')
   if (data) return data;
   var data = [];
   for (var i = 0; i < 20; i ++) {
            data.push("cell from js " + i);
        }
            self.setProp_forKey(data, 'data')
            return data;
        },
            numberOfSectionsInTableView: function(tableView) {
            return 1;
        },
            tableView_numberOfRowsInSection: function(tableView, section) {
            return self.dataSource().count();
        },
            tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
            var cell = tableView.dequeueReusableCellWithIdentifier("cell")
            if (!cell) {
            cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
        }
            cell.textLabel().setText(self.dataSource().objectAtIndex(indexPath.row()))
            return cell
        },
            tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
            return 50
        },
            
            tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
            //返回上一页
//            self.navigationController().popViewControllerAnimated(YES)
            //返回首页
            self.navigationController().popToRootViewControllerAnimated(YES)
            },
          
})

/** 自定义界面*/
defineClass("MJViewController: UIViewController", {
            
            
})













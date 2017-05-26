//
//  ProductListViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UISearchBarDelegate {
//, UIPickerViewDataSource, UIPickerViewDelegate{
    var categoryproductItems = [CategoryProduct]()
    var listItems = [List]()
    var productvariantItems = [ProductVariantList]()
    var categoryproductItems1 = [CategoryProduct1]()

    var productvariantItems1 = [ProductVariantList1]()
    var username1 = ""
    var password1 = ""
    
    var categoryimage: UIImage?
    var categoryID = ""
    var searchtext = ""
    var clickedButtonIndex : Int!


    @IBOutlet var contentView: UIView!

    @IBOutlet weak var cartbtn: UIButton!
    var productid = [[Int]]()
    var individualproductid = [[Int]]()
    var productname = [[String]]()
    var productstock = [[String]]()
    var producttype = [[String]]()
    var productprice = [[String]]()
    var productDiscountpercent = [[String]]()
    var productDiscountprice = [[String]]()
    var productUnitID = [[String]]()
    var productUnit = [[String]]()
    var productQuantity = [[String]]()
    var productcartcount = [[Int]]()
    var wishimage = [String]()
    
    var id = [Int]()
    var proid = [Int]()
    var name = [String]()
    var stock = [String]()
    var type = [String]()
    var price = [String]()
    var Discountpercent = [String]()
    var Discountprice = [String]()
    var unitid = [String]()
    var unit = [String]()
    var quantity = [String]()
    var cartcount = [Int]()
    
    var path = -1
    var tablerow = 0
    var pickerreturn = 0
    var pickerelement = [String]()
    
    var serverquantity = "1"
    var servermrp = 0.0
    var serverdiscountprice = 0.0
    var cartid = 0
    var userid = ""
    var alert = 0
    var alertno = 0
    var searchvalue = 0
    var typealertno = 0
    var pagenumber = 0
    var pagesize = 4
    var orderbycolumn = ""
    var orderbytype = ""
    var cartcountnumber = 0
    var navigationtitle = ""
    
    var productsCount = 0
    var headerimage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!
 
    @IBOutlet weak var smallactivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var search: UIBarButtonItem!
    var close: UIBarButtonItem!
    var sort: UIBarButtonItem!
     var searchActive : Bool = false
    var activityIndicatorView: ActivityIndicatorView!
    var searchController = UISearchController(searchResultsController: nil)
    
    
//    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
    
    var selectedwishlistid = ""
    var wishlistid = [String]()
    var wishlistname = [String]()
    var wishpath = 0
    var filterdata = [List]()
    var filter = [CategoryProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         getuserdetails()
//        self.cartbtn.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height - 80, 45, 45)
        self.title = navigationtitle
        self.cartbtn.layer.cornerRadius = 23
        self.cartbtn.layer.shadowOpacity = 1
        self.cartbtn.layer.shadowRadius = 2
        self.cartbtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.cartbtn.layer.shadowColor = UIColor.grayColor().CGColor
        
        self.cartbtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
        cartbtn.titleEdgeInsets = UIEdgeInsetsMake(5, -35, 0, 0)
        cartbtn.setImage(UIImage(named: "Cartimg.png"), forState: UIControlState.Normal)
        cartbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 4.5, 3, 0)
        cartbtn.tintColor = UIColor.whiteColor()
        cartbtn.backgroundColor = Appconstant.btngreencolor
        cartbtn.titleLabel?.textColor = Appconstant.btngreencolor
        self.cartbtn.frame = CGRectMake(self.view.frame.size.width-60, self.view.frame.size.height-60, 45, 45)

        cartbtn.userInteractionEnabled = true
        cartbtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cartbtn)
        self.view.backgroundColor = Appconstant.bgcolor

        headerimage = UIImageView(image: self.categoryimage)
        headerimage!.frame = CGRectMake(0,0,580,200)
        self.tableView.tableHeaderView = headerimage
        self.navigationItem.title = self.navigationtitle
    
        
        
        
        
        searchController.searchBar.delegate = self
        searchBar.showsCancelButton = false
//        searchController.searchBar.showsCancelButton = false
        searchBar.hidden = true
        searchController.searchBar.hidden = true
        sort = UIBarButtonItem(image: UIImage(named: "sort.png"), style: .Plain, target: self, action: Selector("sortaction"))
        search = UIBarButtonItem(image: UIImage(named: "search.png"), style: .Plain, target: self, action: Selector("searchaction"))
        close = UIBarButtonItem(image: UIImage(named: "close.png"), style: .Plain, target: self, action: Selector("searchaction"))
        navigationItem.rightBarButtonItems = [sort, search]
        self.view.userInteractionEnabled = false
        activityIndicator.startAnimating()
        checkconnection()
        let pagelistviewmodel = PagelistViewModel.init(OrderByColumn: "", OrderByType: "", Productname: "", pageSize: 10, categoryID: Int(self.categoryID)!, pageNumber: pagenumber)!
        let serializedjson  = JSONSerializer.toJson(pagelistviewmodel)
        print(serializedjson)
        pagenumber++
 
        sendrequesttoserver(Appconstant.WEB_API+Appconstant.GET_PAGELIST, value: serializedjson);
        
        sendrequesttoserverforCartid();
        let cartViewController = CartViewController()
        cartViewController.categoryID = categoryID
        self.tableView.reloadData()
        getWishList()
       
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.cartbtn.frame = CGRectMake(self.view.frame.size.width-60, self.view.frame.size.height-60, 45, 45)
       
    }

    func checkconnection(){
        if Reachability.isConnectedToNetwork() == true {
            //            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            var alertController:UIAlertController?
            alertController = UIAlertController(title: "No Internet",
                message: "Check network connection",
                preferredStyle: .Alert)
            
            let action = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.checkconnection()
            }
            let action1 = UIAlertAction(title: "Exit", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                exit(0)
            }
            alertController?.addAction(action)
            alertController?.addAction(action1)
            self.presentViewController(alertController!,
                animated: true,
                completion: nil)
            
        }
        
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filterdata = listItems.filter { List in

            return List.Name.lowercaseString.containsString(searchText.lowercaseString)
        }
    }

    func searchaction(){
        if (searchvalue == 0){
            searchBar.hidden = false
            searchActive = true
            navigationItem.rightBarButtonItems = [sort, close]
         searchvalue = 1

        }
        else{
            self.view.userInteractionEnabled = true
            searchvalue = 0
            searchActive = false
            searchBar.hidden = true
            searchController.searchBar.hidden = true
            navigationItem.rightBarButtonItems = [sort, search]
            self.tableView.reloadData()
        }
        
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
       
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchController.searchBar.text!)
        if(searchBar.text! == ""){
            self.view.userInteractionEnabled = false
        }
        else {
//            self.view.userInteractionEnabled = false
            activityIndicator.startAnimating()
            self.searchtext = searchBar.text!
            let pagelistviewmodel = PagelistViewModel.init(OrderByColumn: "", OrderByType: "", Productname: searchBar.text!, pageSize: 50, categoryID: Int(self.categoryID)!, pageNumber: 0)!
            let serializedjson  = JSONSerializer.toJson(pagelistviewmodel)
            print(serializedjson)
            sendrequesttoserverFilter(Appconstant.WEB_API+Appconstant.GET_PAGELIST, value: serializedjson);
        }
        

    }
    
    func sortaction(){

        var alertController:UIAlertController?
        alertController?.view.tintColor = UIColor.blackColor()
        alertController = UIAlertController(title: "Sort option",
            message: "",
            preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "A - Z", style: UIAlertActionStyle.Default, handler: {[weak self](paramAction:UIAlertAction!) in
            self!.activityIndicator.startAnimating()
            self!.view.userInteractionEnabled = false
            self!.clear()
            
            self!.orderbycolumn = "productname"
            self!.orderbytype = "asec"
            
//            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            let pagelistviewmodel = PagelistViewModel.init(OrderByColumn: self!.orderbycolumn, OrderByType: self!.orderbytype, Productname: "", pageSize: 10, categoryID: Int(self!.categoryID)!, pageNumber: self!.pagenumber)!
                    let serializedjson  = JSONSerializer.toJson(pagelistviewmodel)
                    print(serializedjson)
//                    self!.alert = 1
              self!.pagenumber++
                    self!.sendrequesttoserver(Appconstant.WEB_API+Appconstant.GET_PAGELIST, value: serializedjson)
            
            })
        let action1 = UIAlertAction(title: "Z - A", style: UIAlertActionStyle.Default, handler: {[weak self](paramAction:UIAlertAction!) in
            self!.activityIndicator.startAnimating()
            self!.view.userInteractionEnabled = false
            self!.clear()
            
            self!.orderbycolumn = "productname"
            self!.orderbytype = "desc"
            
//            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            let pagelistviewmodel = PagelistViewModel.init(OrderByColumn: self!.orderbycolumn, OrderByType: "desc", Productname: "", pageSize: 10, categoryID: Int(self!.categoryID)!, pageNumber: self!.pagenumber)!
            let serializedjson  = JSONSerializer.toJson(pagelistviewmodel)
            print(serializedjson)
            self!.pagenumber++
            self!.sendrequesttoserver(Appconstant.WEB_API+Appconstant.GET_PAGELIST, value: serializedjson)
            
            })
        
        
        let action2 = UIAlertAction(title: "Price - low to high", style: UIAlertActionStyle.Default, handler: {[weak self](paramAction:UIAlertAction!) in
             self!.activityIndicator.startAnimating()
            self!.view.userInteractionEnabled = false
            self!.clear()
            
            self!.orderbycolumn = "price"
            self!.orderbytype = "asec"
            
//            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            let pagelistviewmodel = PagelistViewModel.init(OrderByColumn: "price", OrderByType: "asec", Productname: "", pageSize: 10, categoryID: Int(self!.categoryID)!, pageNumber: self!.pagenumber)!
            let serializedjson  = JSONSerializer.toJson(pagelistviewmodel)
            print(serializedjson)
           self!.pagenumber++
            self!.sendrequesttoserver(Appconstant.WEB_API+Appconstant.GET_PAGELIST, value: serializedjson)

            })

        let action3 = UIAlertAction(title: "Price - high to low", style: UIAlertActionStyle.Default, handler: {[weak self](paramAction:UIAlertAction!) in
            self!.activityIndicator.startAnimating()
            self!.view.userInteractionEnabled = false
            self!.clear()
            
            self!.orderbycolumn = "price"
            self!.orderbytype = "desc"
            
            let pagelistviewmodel = PagelistViewModel.init(OrderByColumn: "price", OrderByType: "desc", Productname: "", pageSize: 10, categoryID: Int(self!.categoryID)!, pageNumber: self!.pagenumber)!
            let serializedjson  = JSONSerializer.toJson(pagelistviewmodel)
            print(serializedjson)
            self!.pagenumber++
            self!.sendrequesttoserver(Appconstant.WEB_API+Appconstant.GET_PAGELIST, value: serializedjson)
            })


        
        
        let action4 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
        }
        
        alertController?.addAction(action)
        alertController?.addAction(action1)
        alertController?.addAction(action2)
        alertController?.addAction(action3)
        alertController?.addAction(action4)
        self.presentViewController(alertController!, animated: true, completion: nil)

    }

 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
 
        
        let productcell = tableView.dequeueReusableCellWithIdentifier("P_Cell", forIndexPath: indexPath) as UITableViewCell!
        
        let productimg = productcell.viewWithTag(1) as! UIImageView
        let productlbl = productcell.viewWithTag(2) as! UILabel
        let recurring = productcell.viewWithTag(3) as! UIButton
        let wishimg = productcell.viewWithTag(6) as! UIButton
        let pricelbl = productcell.viewWithTag(4) as! UILabel
        let cartcountlbl = productcell.viewWithTag(8) as! UILabel
        let btn = productcell.viewWithTag(12) as! UIButton
        let dropDownImage = productcell.viewWithTag(13) as! UIImageView
//        recurring.hidden = true
        if searchActive == true {
            print(indexPath.row)
             let lists = listItems[indexPath.row]
            if(lists.wish == "true"){
                wishimg.setBackgroundImage(UIImage(named: "fav_filled.png"), forState: UIControlState.Normal)
            }
            else {
                wishimg.setBackgroundImage(UIImage(named: "fav_outline.png"), forState: UIControlState.Normal)
            }
            
            
            productlbl.text = lists.Name
            productlbl.textColor = UIColor.blackColor()
            productimg.image = lists.ProductPhoto
            pricelbl.text = "\u{20B9}" + lists.DiscountPrice
            pricelbl.textColor = Appconstant.btngreencolor
            cartcountlbl.text = "\(lists.cartCount)"
            cartcountlbl.font = UIFont(name: "Arial", size: 12)
            btn.setTitle(lists.Type, forState: UIControlState.Normal)
//            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            if categoryproductItems1[indexPath.row].ProductvariantList.count<=1
            {
                print("prod.vari_Count==>>",categoryproductItems1[indexPath.row].ProductvariantList.count)
                dropDownImage.hidden = true
                btn.userInteractionEnabled = false
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
                btn.layer.borderColor = UIColor.clearColor().CGColor
            }
            else
            {
                btn.layer.borderColor = UIColor(red: 168.0/255.0, green: 168.0/255.0, blue: 168.0/255.0, alpha: 1.0).CGColor
                btn.layer.borderWidth = 1.2
                dropDownImage.hidden = false
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
                btn.userInteractionEnabled = true
            }

            btn.titleLabel?.textColor = UIColor.grayColor()
            btn.layer.cornerRadius = 12
            btn.backgroundColor = UIColor.clearColor()
            productcell.layer.borderWidth = 1
            productcell.layer.borderColor = Appconstant.bgcolor.CGColor
            activityIndicator.stopAnimating()
            self.view.userInteractionEnabled = true
            return productcell
        }
        print(indexPath.row)
        if(wishimage[indexPath.row] == "true"){
            wishimg.setBackgroundImage(UIImage(named: "fav_filled.png"), forState: UIControlState.Normal)
        }
        else {
            wishimg.setBackgroundImage(UIImage(named: "fav_outline.png"), forState: UIControlState.Normal)
        }
        btn.setTitle(producttype[indexPath.row][0], forState: UIControlState.Normal)
        btn.layer.cornerRadius = 3
        
        
        btn.titleLabel?.textColor = UIColor.grayColor()
        btn.layer.cornerRadius = 12
        btn.backgroundColor = UIColor.clearColor()

        let categoryproduct = categoryproductItems[indexPath.row]
        
        productlbl.text = categoryproduct.Name
        
        productlbl.textColor = UIColor.blackColor()
//        productlbl.font = UIFont(name: "Arial", size: 12)
        productimg.image = categoryproduct.ProductPhoto
        
        pricelbl.text = "\u{20B9}" + self.productDiscountprice[indexPath.row][0]
        pricelbl.textColor = Appconstant.btngreencolor
//        pricelbl.font = UIFont(name: "Arial", size: 12)
        cartcountlbl.text = "\(self.productcartcount[indexPath.row][0])"
        cartcountlbl.font = UIFont(name: "Arial", size: 12)
        
        if categoryproductItems[indexPath.row].ProductvariantList.count<=1
        {
            print("prod.vari_Count==>>",categoryproductItems[indexPath.row].ProductvariantList.count)
            dropDownImage.hidden = true
            btn.userInteractionEnabled = false
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            btn.layer.borderColor = UIColor.clearColor().CGColor
        }
        else
        {
            btn.layer.borderColor = UIColor(red: 168.0/255.0, green: 168.0/255.0, blue: 168.0/255.0, alpha: 1.0).CGColor
            btn.layer.borderWidth = 1.2
            dropDownImage.hidden = false
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            btn.userInteractionEnabled = true
        }
        
        productcell.layer.borderWidth = 1
        productcell.layer.borderColor = Appconstant.bgcolor.CGColor
        
        if(pagesize == indexPath.row){
            smallactivityIndicator.startAnimating()
            let pagelistviewmodel = PagelistViewModel.init(OrderByColumn: orderbycolumn, OrderByType: orderbytype, Productname: "", pageSize: 10, categoryID: Int(self.categoryID)!, pageNumber: pagenumber)!
            let serializedjson  = JSONSerializer.toJson(pagelistviewmodel)
            print(serializedjson)
            pagenumber++
            pagesize = pagesize + 6
            activityIndicator.startAnimating()
            sendrequesttoserver(Appconstant.WEB_API+Appconstant.GET_PAGELIST, value: serializedjson);
            activityIndicator.stopAnimating()
        }
        
        self.view.userInteractionEnabled = true
        if(alertno == 1){
            alertno == 0
//            self.activityIndicatorView.stopAnimating()
        }
        activityIndicator.stopAnimating()
        self.view.userInteractionEnabled = true
        productcell.selectionStyle = UITableViewCellSelectionStyle.None
//        
//        if(indexPath.row == categoryproductItems.count-1){
//            self.cartbtn.frame = CGRectMake(20, self.view.frame.size.height-60, 45, 45)
//        }
//        else{
//            self.cartbtn.frame = CGRectMake(self.view.frame.size.width-60, self.view.frame.size.height-60, 45, 45)
//        }

        return productcell
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searchActive == true {
            print(categoryproductItems1.count)
            return categoryproductItems1.count
        }
        return categoryproductItems.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("goto_productdes", sender: self)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }



    
    
            
    func sendrequesttoserver(url : String, value : String)
    {
        let username = self.username1
        let password = self.password1
        print(self.username1)
        print(self.password1)
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)

        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("ERROR")
                    print("response = \(response)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }

                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                let json = JSON(data: data!)
                let item1 = json["result"]
                for item in item1["productList"].arrayValue {

                    
                    
                    self.wishimage.append(item["IsWishListed"].stringValue)
                    self.productvariantItems = [ProductVariantList]()
                    self.id = [Int]()
                    self.proid = [Int]()
                    self.name = [String]()
                    self.stock = [String]()
                    self.type = [String]()
                    self.price = [String]()
                    self.Discountpercent = [String]()
                    self.Discountprice = [String]()
                    self.unit = [String]()
                    self.unitid = [String]()
                    self.quantity = [String]()
                    self.cartcount = [Int]()
                for product in  item["ProductVariantList"].arrayValue {
                       
                    let productvariantlist = ProductVariantList(ID: product["ID"].intValue, ProductID: product["ProductID"].intValue,  ProductName: product["ProductName"].stringValue,
                            Price: String(product["Price"].doubleValue), Stock: product["Stock"].stringValue, DiscountPercentage: product["DiscountPercentage"].stringValue, DiscountPrice: String(product["DiscountPrice"].doubleValue), Unit: product["Unit"].stringValue, Type: product["Description"].stringValue,
                        Quantity: product["Quantity"].stringValue, UnitID: product["UnitID"].stringValue, cartCount: product["cartCount"].intValue)!
                        self.productvariantItems += [productvariantlist];
                   
                    
                    
                    self.id.append(product["ID"].intValue)
                    self.proid.append(product["ProductID"].intValue)
                    self.name.append(product["ProductName"].stringValue)
                    self.type.append(product["Description"].stringValue)
                    self.stock.append(product["Stock"].stringValue)
                    self.price.append(String(product["Price"].doubleValue))
                    self.Discountpercent.append(product["DiscountPercentage"].stringValue)
                    self.Discountprice.append(String(product["DiscountPrice"].doubleValue))
                    self.unit.append(product["Unit"].stringValue)
                    self.unitid.append(product["UnitID"].stringValue)
                    self.quantity.append(product["Quantity"].stringValue)
                    self.cartcount.append(product["cartCount"].intValue)
                    
                    }
                    if(item["ImageUrl"].stringValue.isEmpty){
                        let defaultimg = UIImage(named: "loading_sqr.png")

                        let categoryproduct = CategoryProduct(ID: item["ID"].stringValue, Name: item["Name"].stringValue, Description: item["Description"].stringValue,  ProductPhoto : defaultimg!, Productimgurl: item["ImageUrl"].stringValue, ProductvariantList: self.productvariantItems)!
                        print ("catt produc=>>",categoryproduct)
                        self.categoryproductItems += [categoryproduct];
                    }
                    else{
                    let categoryimgPath = Appconstant.IMAGEURL+"Images/Products/"+item["ImageUrl"].stringValue;
                        
//                    let productimg =  UIImage(data: NSData(contentsOfURL: NSURL(string:categoryimgPath)!)!)
                        if let data = NSData(contentsOfURL: NSURL(string:categoryimgPath)!){
                            let productimg =  UIImage(data: NSData(contentsOfURL: NSURL(string:categoryimgPath)!)!)
                            let categoryproduct = CategoryProduct(ID: item["ID"].stringValue, Name: item["Name"].stringValue, Description: item["Description"].stringValue,  ProductPhoto : productimg!, Productimgurl: item["ImageUrl"].stringValue, ProductvariantList: self.productvariantItems)!
                            self.categoryproductItems += [categoryproduct];
                            self.productsCount = self.productsCount+1
                        }
                        else{
                            let productimg = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png")!)!)
                            let categoryproduct = CategoryProduct(ID: item["ID"].stringValue, Name: item["Name"].stringValue, Description: item["Description"].stringValue,  ProductPhoto : productimg!, Productimgurl: item["ImageUrl"].stringValue, ProductvariantList: self.productvariantItems)!
                            self.categoryproductItems += [categoryproduct];
                            self.productsCount = self.productsCount+1
                        }

                        
                        
                        
//                        catch {
//                            let productimg1 = UIImage(named: "loading_sqr.png")
//                            let categoryproduct = CategoryProduct(ID: item["ID"].stringValue, Name: item["Name"].stringValue, Description: item["Description"].stringValue,  ProductPhoto : productimg1!, Productimgurl: item["ImageUrl"].stringValue, ProductvariantList: self.productvariantItems)!
//                            self.categoryproductItems += [categoryproduct];
//                            self.productsCount = self.productsCount+1
//                        }
                    
                    
                    
                    
                    }
                    
                    self.individualproductid.append(self.id)
                    self.productid.append(self.proid)
                    self.productname.append(self.name)
                    self.producttype.append(self.type)
                    self.productstock.append(self.stock)
                    self.productprice.append(self.price)
                    self.productDiscountpercent.append(self.Discountpercent)
                    self.productDiscountprice.append(self.Discountprice)
                    self.productUnit.append(self.unit)
                    self.productUnitID.append(self.unitid)
                    self.productQuantity.append(self.quantity)
                    self.productcartcount.append(self.cartcount)
              
                    }
                
                dispatch_async(dispatch_get_main_queue()) {
                    if self.categoryproductItems.count == 0 {
                        self.activityIndicator.stopAnimating()
                        self.presentViewController(Alert().alert("No products found", message: ""),animated: true,completion: nil)
                    }
                    else{
                    self.tableView.reloadData()
                    self.smallactivityIndicator.stopAnimating()
                    }
                }
            }
        
        print("Count_Products==>>",self.productsCount)
        
        
    task.resume()
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goto_productdes") {
            let nextviewcontroller = segue.destinationViewController as! ProductdescriptionViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            if searchActive == true {
              
                
                nextviewcontroller.productimage = self.categoryproductItems1[(indexPath?.row)!].ProductPhoto
                nextviewcontroller.productname = self.categoryproductItems1[(indexPath?.row)!].Name
                nextviewcontroller.prodesc = self.listItems[(indexPath?.row)!].Description
                nextviewcontroller.proprice = self.listItems[(indexPath?.row)!].Price
                nextviewcontroller.prodiscount = self.listItems[(indexPath?.row)!].DiscountPercentage
                nextviewcontroller.proamount = self.listItems[(indexPath?.row)!].DiscountPrice
                nextviewcontroller.prounit = self.listItems[(indexPath?.row)!].Unit
                nextviewcontroller.protype = self.listItems[(indexPath?.row)!].Type
                nextviewcontroller.proquantity = self.listItems[(indexPath?.row)!].Quantity
                nextviewcontroller.individuvalid = self.listItems[(indexPath?.row)!].ProductVariantID
                nextviewcontroller.productid = self.listItems[(indexPath?.row)!].ProductID
                nextviewcontroller.dis_price = self.listItems[(indexPath?.row)!].DiscountPrice
                nextviewcontroller.productcartcount = self.listItems[(indexPath?.row)!].cartCount
                nextviewcontroller.cartid = self.cartid
                nextviewcontroller.username1 = self.username1
                nextviewcontroller.password1 = self.password1
                nextviewcontroller.cartcountnumber = self.cartcountnumber
            }
            else{
            nextviewcontroller.productimage = self.categoryproductItems[(indexPath?.row)!].ProductPhoto
            nextviewcontroller.productname = self.categoryproductItems[(indexPath?.row)!].Name
            nextviewcontroller.prodesc = self.productname[(indexPath?.row)!][0]
            nextviewcontroller.proprice = self.productprice[(indexPath?.row)!][0]
            nextviewcontroller.prodiscount = self.productDiscountpercent[(indexPath?.row)!][0]
            nextviewcontroller.proamount = self.productDiscountprice[(indexPath?.row)!][0]
            nextviewcontroller.prounit = self.productUnit[(indexPath?.row)!][0]
            nextviewcontroller.protype = self.producttype[(indexPath?.row)!][0]
            nextviewcontroller.proquantity = self.productQuantity[(indexPath?.row)!][0]
            nextviewcontroller.individuvalid = self.individualproductid[(indexPath?.row)!][0]
            nextviewcontroller.productid = self.productid[(indexPath?.row)!][0]
            nextviewcontroller.dis_price = self.productDiscountprice[(indexPath?.row)!][0]
            nextviewcontroller.productcartcount = self.productcartcount[(indexPath?.row)!][0]
            nextviewcontroller.cartid = self.cartid
                nextviewcontroller.username1 = self.username1
                nextviewcontroller.password1 = self.password1
                nextviewcontroller.cartcountnumber = self.cartcountnumber 
            }
          
        }

    }
    
    
    @IBAction func WishBtnAction(sender: AnyObject) {
        

        var indexPath: Int!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? ProductCell {
                    indexPath = tableView.indexPathForCell(cell)?.row
                    wishpath = indexPath
                }
            }
        }
    alertFunction()

    }
    var alertindex = 0
    func alertFunction(){
        let alertView: UIAlertView = UIAlertView()
        alertView.delegate = self
        alertView.title = "Wish List"
        for(var i = 0; i<wishlistid.count ; i++){
            alertView.addButtonWithTitle("\(wishlistname[i])")
            
        }
        alertView.addButtonWithTitle("Create New Wishlist")
        alertView.addButtonWithTitle("Cancel")
        
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        print(buttonIndex)
        print(wishlistid.count)
        
        if(typealertno == 1){
            typealertno = 0

             if((searchActive == true) && (self.categoryproductItems1[alertindex].ProductvariantList.count != buttonIndex)) {
                
                listItems[alertindex].ProductVariantID = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].ID
                listItems[alertindex].ProductID = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].ProductID
                listItems[alertindex].Name = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].ProductName
                listItems[alertindex].Type = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].Type
                listItems[alertindex].Stock = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].Stock
                listItems[alertindex].Price = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].Price
                listItems[alertindex].DiscountPercentage = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].DiscountPercentage
                listItems[alertindex].DiscountPrice = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].DiscountPrice
                listItems[alertindex].UnitID = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].UnitID
                listItems[alertindex].Unit = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].Unit
                listItems[alertindex].Quantity = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].Quantity
                listItems[alertindex].cartCount = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].cartCount
            }
             else if(self.categoryproductItems[alertindex].ProductvariantList.count != buttonIndex){
            
            self.individualproductid[alertindex][0] = self.categoryproductItems[alertindex].ProductvariantList[buttonIndex].ID
            self.productid[alertindex][0] = self.categoryproductItems[alertindex].ProductvariantList[buttonIndex].ProductID
            self.productname[alertindex][0] = self.categoryproductItems[alertindex].ProductvariantList[buttonIndex].ProductName
            self.producttype[alertindex][0] = self.categoryproductItems[alertindex].ProductvariantList[buttonIndex].Type
            self.productstock[alertindex][0] = self.categoryproductItems[alertindex].ProductvariantList[buttonIndex].Stock
            self.productprice[alertindex][0] = self.categoryproductItems[alertindex].ProductvariantList[buttonIndex].Price
            self.productDiscountpercent[alertindex][0] = self.categoryproductItems[alertindex].ProductvariantList[buttonIndex].DiscountPercentage
            self.productDiscountprice[alertindex][0] = self.categoryproductItems[alertindex].ProductvariantList[buttonIndex].DiscountPrice
            self.productUnitID[alertindex][0] = self.categoryproductItems[alertindex].ProductvariantList[buttonIndex].UnitID
            self.productUnit[alertindex][0] = self.categoryproductItems[alertindex].ProductvariantList[buttonIndex].Unit
            self.productQuantity[alertindex][0] = self.categoryproductItems[alertindex].ProductvariantList[buttonIndex].Quantity
            self.productcartcount[alertindex][0] = self.categoryproductItems[alertindex].ProductvariantList[buttonIndex].cartCount
            
            }
            
            self.tableView.reloadData()

            
        }
       else if(buttonIndex < wishlistid.count){
            
            
            
            if searchActive == true {
                listItems[wishpath].wish = "true"
                self.tableView.reloadData()
                let wishviewmodel = WishlineitemViewModel.init(productVariantID: listItems[wishpath].ProductVariantID, productID: listItems[wishpath].ProductID, wishlistID: wishlistid[buttonIndex])!
                let serializedjson  = JSONSerializer.toJson(wishviewmodel)
                print(serializedjson)
                CreateWishListItem(Appconstant.WEB_API+Appconstant.CREATE_WISH_LIST_LINEITEM, value: serializedjson)
                
            }
            else{
                self.wishimage[wishpath] = "true"
                self.tableView.reloadData()
            let wishviewmodel = WishlineitemViewModel.init(productVariantID: self.individualproductid[wishpath][0], productID: self.productid[wishpath][0], wishlistID: wishlistid[buttonIndex])!
            let serializedjson  = JSONSerializer.toJson(wishviewmodel)
            print(serializedjson)
            CreateWishListItem(Appconstant.WEB_API+Appconstant.CREATE_WISH_LIST_LINEITEM, value: serializedjson)
            }
            
        }
        else if(buttonIndex == wishlistid.count)
        {
            var alertController:UIAlertController?
                        alertController = UIAlertController(title: "Create New Wishlist",
                            message: "",
                            preferredStyle: .Alert)
            
                        alertController!.addTextFieldWithConfigurationHandler(
                            {(textField: UITextField!) in
                                textField.placeholder = "Wishlist Name"
                        })
            let action = UIAlertAction(title: "OK",
                            style: UIAlertActionStyle.Default,
                            handler: {[weak self]
                                (paramAction:UIAlertAction!) in
                                if let textFields = alertController?.textFields{
                                    let theTextFields = textFields as [UITextField]
                                    let enteredText = theTextFields[0].text
                                    print(enteredText!)
                                    let wishlistviewmodel = WishViewModel.init(UserID: self!.userid, Name: enteredText!)!
                                    let serializedjson  = JSONSerializer.toJson(wishlistviewmodel)
                                    print("Wishlist creation Request==>>")
                                    print(serializedjson)
                                    self?.activityIndicator.startAnimating()
                                    self!.clickedButtonIndex = buttonIndex
                                    dispatch_async(dispatch_get_main_queue()) {
                                         self!.CreateWishListinServerAndAddItem(Appconstant.WEB_API+Appconstant.CREATE_WISH_LIST, value: serializedjson)
                                        
                                        self!.activityIndicator.stopAnimating()
                                    }

                                    
                                   
                                    /*
                                    dispatch_async(dispatch_get_main_queue())
                                    {
                                        
                                        //Added For Item Addition
                                        
                                        if self!.searchActive == true {
                                            self!.listItems[self!.wishpath].wish = "true"
                                            self!.tableView.reloadData()
                                            let wishviewmodel = WishlineitemViewModel.init(productVariantID: self!.listItems[self!.wishpath].ProductVariantID, productID: self!.listItems[self!.wishpath].ProductID, wishlistID: self!.wishlistid[buttonIndex])!
                                            let serializedjson  = JSONSerializer.toJson(wishviewmodel)
                                            print(serializedjson)
                                            self!.CreateWishListItem(Appconstant.WEB_API+Appconstant.CREATE_WISH_LIST_LINEITEM, value: serializedjson)
                                            
                                        }
                                        else{
                                            
                                            print(self!.wishlistid[0])
                                            print(self!.individualproductid[self!.wishpath][0])
                                            print(self!.productid[self!.wishpath][0])
                                            
                                            self!.wishimage[self!.wishpath] = "true"
                                            self!.tableView.reloadData()
                                            let wishviewmodel = WishlineitemViewModel.init(productVariantID: self!.individualproductid[self!.wishpath][0], productID: self!.productid[self!.wishpath][0], wishlistID: self!.wishlistid[0])!
                                            let serializedjson  = JSONSerializer.toJson(wishviewmodel)
                                            print("Item addition To Wishlist Request==>>")
                                            print(serializedjson)
                                            self!.CreateWishListItem(Appconstant.WEB_API+Appconstant.CREATE_WISH_LIST_LINEITEM, value: serializedjson)
                                        }

                                        
                                        
                                        self!.activityIndicator.stopAnimating()
                                    }
                                    */
                                }
                            })
            let action1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                
                            }
            
                            alertController?.addAction(action)
                            alertController?.addAction(action1)
                            self.presentViewController(alertController!, animated: true, completion: nil)
         }
        else {
            
        }
     }
    
    
    func addFirstItemToWishList()
    {
        
    }
    
    
    
    @IBAction func TypeBtn(sender: AnyObject) {
        var indexPath: Int!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? ProductCell {
                    indexPath = tableView.indexPathForCell(cell)?.row
                          print("\(indexPath)")
                }
            }
        }
        typealertno = 1
        alertindex = indexPath
        let alertView1: UIAlertView = UIAlertView()
        alertView1.delegate = self
        alertView1.title = "Product Variant"
        
        if searchActive == true {
            for(var i = 0; i<self.categoryproductItems1[indexPath].ProductvariantList.count; i++){
                print(self.categoryproductItems1[indexPath].ProductvariantList.count)
                alertView1.addButtonWithTitle("\(self.categoryproductItems1[indexPath].ProductvariantList[i].Type)" + " - " + "Rs." + "\(self.categoryproductItems1[indexPath].ProductvariantList[i].DiscountPrice)")
            }
            alertView1.addButtonWithTitle("Cancel")
        }
        else{
         for(var i = 0; i<self.categoryproductItems[indexPath].ProductvariantList.count ; i++){
                  alertView1.addButtonWithTitle("\(self.categoryproductItems[indexPath].ProductvariantList[i].Type)" + " - " + "Rs." + "\(self.categoryproductItems[indexPath].ProductvariantList[i].DiscountPrice)")
         }
            alertView1.addButtonWithTitle("Cancel")
        }
        alertView1.show()
        
    }
    @IBAction func AddtoCart(sender: AnyObject) {
  
        var indexPath: Int!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? ProductCell {
                    indexPath = tableView.indexPathForCell(cell)?.row
              //      print("\(indexPath)")
                    
                }
            }
        }

        if searchActive == true {
            if(listItems[indexPath].cartCount == 0){
                self.cartcountnumber += 1
                self.cartbtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
            }
            listItems[indexPath].cartCount = listItems[indexPath].cartCount + 1
    
            self.tableView.reloadData()
            
            let productmodel = Productvariant.init(ID: listItems[indexPath].ProductVariantID, ProductID: listItems[indexPath].ProductID, ProductName: listItems[indexPath].ProductName, Stock: Int(listItems[indexPath].Stock)!, Description: listItems[indexPath].Type, Unit: listItems[indexPath].Unit, Quantity: Int(listItems[indexPath].Quantity)!, Price: Float(listItems[indexPath].Price)!, DiscountPercentage: Float(listItems[indexPath].DiscountPercentage)!, DiscountPrice: Float(listItems[indexPath].DiscountPrice)!)!
            
            
            let cartadd = CartaddViewModel.init(CartID: self.cartid, ProductVariant: productmodel, Quantity: Int(self.serverquantity)!, MRP: Float(listItems[indexPath].Price)!, DiscountedPrice: Float(listItems[indexPath].DiscountPrice)!)!
            
            let serializedjson  = JSONSerializer.toJson(cartadd)
            
            print(serializedjson)
            print(Appconstant.WEB_API+Appconstant.ADD_TO_CART)
            
            sendrequesttoserverAddcart(Appconstant.WEB_API+Appconstant.ADD_TO_CART, value: serializedjson)
            if(listItems[indexPath].cartCount == 1){
                self.presentViewController(Alert().alert("Item added to cart successfully", message: ""),animated: true,completion: nil)
            }
            
        }
        else{
            if(self.productcartcount[indexPath][0] == 0){
                self.cartcountnumber += 1
                self.cartbtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
            }
        self.productcartcount[indexPath][0] = self.productcartcount[indexPath][0] + 1
            
        self.tableView.reloadData()

        let productmodel = Productvariant.init(ID: self.individualproductid[indexPath][0], ProductID: self.productid[indexPath][0], ProductName: self.productname[indexPath][0], Stock: Int(self.productstock[indexPath][0])!, Description: self.producttype[indexPath][0], Unit: self.productUnit[indexPath][0], Quantity: Int(self.productQuantity[indexPath][0])!, Price: Float(self.productprice[indexPath][0])!, DiscountPercentage: Float(self.productDiscountpercent[indexPath][0])!, DiscountPrice: Float(self.productDiscountprice[indexPath][0])!)!


        let cartadd = CartaddViewModel.init(CartID: self.cartid, ProductVariant: productmodel, Quantity: Int(self.serverquantity)!, MRP: Float(self.productprice[indexPath][0])!, DiscountedPrice: Float(self.productDiscountprice[indexPath][0])!)!
        
        let serializedjson  = JSONSerializer.toJson(cartadd)
 
        print(serializedjson)
        print(Appconstant.WEB_API+Appconstant.ADD_TO_CART)
        
        sendrequesttoserverAddcart(Appconstant.WEB_API+Appconstant.ADD_TO_CART, value: serializedjson)
            if(self.productcartcount[indexPath][0] == 1){
                self.presentViewController(Alert().alert("Item added to cart successfully", message: ""),animated: true,completion: nil)
            }
      }
        
    }
    
    
    @IBAction func MinusBtnAction(sender: AnyObject) {
        let point = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)!
        print(indexPath)
        
        if searchActive == true {
            
            if(listItems[indexPath.row].cartCount > 1){
                
                listItems[indexPath.row].cartCount = listItems[indexPath.row].cartCount - 1
                self.tableView.reloadData()
                let decrementmodel = DecrementViewModel.init(userId: userid, productId: listItems[indexPath.row].ProductID, productVariantId: listItems[indexPath.row].ProductVariantID)!
                
                let serializedjson  = JSONSerializer.toJson(decrementmodel)
                print(serializedjson)
                sendrequesttoserverForDecrement(Appconstant.WEB_API+Appconstant.CART_DECREMENT+"userId=\(userid)&productId=\(listItems[indexPath.row].ProductID)&productVariantId=\(listItems[indexPath.row].ProductVariantID)")
                

            }
            else if(listItems[indexPath.row].cartCount == 1){
                var alertController:UIAlertController?
                alertController = UIAlertController(title: "Are you sure want to remove item from cart?",
                    message: "",
                    preferredStyle: .Alert)
                
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                    self.cartcountnumber -= 1
                    self.cartbtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
                    self.listItems[indexPath.row].cartCount = self.listItems[indexPath.row].cartCount - 1
                    self.tableView.reloadData()
                    let decrementmodel = DecrementViewModel.init(userId: self.userid, productId: self.listItems[indexPath.row].ProductID, productVariantId: self.listItems[indexPath.row].ProductVariantID)!
                    
                    let serializedjson  = JSONSerializer.toJson(decrementmodel)
                    print(serializedjson)
                    self.sendrequesttoserverForDecrement(Appconstant.WEB_API+Appconstant.CART_DECREMENT+"userId=\(self.userid)&productId=\(self.listItems[indexPath.row].ProductID)&productVariantId=\(self.listItems[indexPath.row].ProductVariantID)")
                    
                }
                let action1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                    
                }
                alertController?.addAction(action)
                alertController?.addAction(action1)
                self.presentViewController(alertController!,
                    animated: true,
                    completion: nil)

            }
        }

       else if(productcartcount[indexPath.row][0] > 1){
            
            self.productcartcount[indexPath.row][0] = self.productcartcount[indexPath.row][0] - 1
            self.tableView.reloadData()
            let decrementmodel = DecrementViewModel.init(userId: userid, productId: self.productid[indexPath.row][0], productVariantId: self.individualproductid[indexPath.row][0])!

            let serializedjson  = JSONSerializer.toJson(decrementmodel)
            print(serializedjson)
            sendrequesttoserverForDecrement(Appconstant.WEB_API+Appconstant.CART_DECREMENT+"userId=\(userid)&productId=\(self.productid[indexPath.row][0])&productVariantId=\(self.individualproductid[indexPath.row][0])")
            
        }
        else if(productcartcount[indexPath.row][0] == 1){
            var alertController:UIAlertController?
            alertController = UIAlertController(title: "Are you sure want to remove item from cart?",
                message: "",
                preferredStyle: .Alert)
            
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.cartcountnumber -= 1
                self.cartbtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
                self.productcartcount[indexPath.row][0] = self.productcartcount[indexPath.row][0] - 1
                self.tableView.reloadData()
                let decrementmodel = DecrementViewModel.init(userId: self.userid, productId: self.productid[indexPath.row][0], productVariantId: self.individualproductid[indexPath.row][0])!
                
                let serializedjson  = JSONSerializer.toJson(decrementmodel)
                print(serializedjson)
                self.sendrequesttoserverForDecrement(Appconstant.WEB_API+Appconstant.CART_DECREMENT+"userId=\(self.userid)&productId=\(self.productid[indexPath.row][0])&productVariantId=\(self.individualproductid[indexPath.row][0])")
            }
            let action1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                
            }
            alertController?.addAction(action)
            alertController?.addAction(action1)
            self.presentViewController(alertController!,
                animated: true,
                completion: nil)

            
        }
    }
    func getuserdetails(){
        DBHelper().opensupermarketDB()
        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
        let databasePath = databaseURL.absoluteString
        let supermarketDB = FMDatabase(path: databasePath as String)
        if supermarketDB.open() {
            
            let selectSQL = "SELECT * FROM LOGIN"
            
            let results:FMResultSet! = supermarketDB.executeQuery(selectSQL,
                withArgumentsInArray: nil)
            if (results.next())
            {
                self.userid = "\(results.intForColumn("USERID"))"
                self.username1 = results.stringForColumn("EMAILID")
                self.password1 = results.stringForColumn("PASSWORD")
                
            }
            supermarketDB.close()
        } else {
            print("Error: \(supermarketDB.lastErrorMessage())")
        }
    }
    func sendrequesttoserverForDecrement(url : String){
        
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        print(url)
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        
//        request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                else {
                    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("responseString = \(responseString)")

                }
        }
        
        task.resume()

    }

    func sendrequesttoserverAddcart(url : String,value : String)
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)

        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "Post"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        

        request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                else {
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                
                    
                }
        }

        task.resume()
        
    }
    
    
    
    func sendrequesttoserverforCartid()
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_CART_OPEN+self.userid)!)
        request.HTTPMethod = "GET"
        // set Content-Type in HTTP header
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        //    let postString = "Username="+self.txtUsername.text!+"&Password="+self.txtPassword.text!
        //    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        //     print("GET RESPONSE")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("ERROR")
                    print("response = \(response)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                //    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //     print("responseString = \(responseString)")
                let json = JSON(data: data!)
                var item = json["result"]
                self.cartid = item["ID"].intValue
                print(self.userid)
                print(self.cartid)

                
                
        }
        
        
        
        task.resume()
        
    }
    

    
    func getWishList() {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
               
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_ALL_WISH_LIST+self.userid)!)
        request.HTTPMethod = "GET"
        // set Content-Type in HTTP header
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        //    let postString = "Username="+self.txtUsername.text!+"&Password="+self.txtPassword.text!
        //    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        //     print("GET RESPONSE")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("ERROR")
                    print("response = \(response)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                //    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //     print("responseString = \(responseString)")
                self.wishlistid.removeAll()
                self.wishlistname.removeAll()
                let json = JSON(data: data!)
                for item in json["result"].arrayValue {
                    self.wishlistid.append(item["ID"].stringValue)
                    self.wishlistname.append(item["Name"].stringValue)
                }
                
        }
        
        task.resume()

    }

    
    func CreateWishListItem(url : String,value : String)
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "Post"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("Item Addition response = \(response)")
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Item Addition response = \(responseString)")
                let json = JSON(data: data!)
                let item3 = json["Status"].stringValue
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(Alert().alert(item3, message: ""),animated: true,completion: nil)
                }
        }
        
        task.resume()
    }
    
    func CreateWishListinServer(url : String,value : String){
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        //    let events = EventManager();
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "Post"
        // set Content-Type in HTTP header
        
        //         NSURLProtocol.setProperty("application/json", forKey: "Content-Type", inRequest: request)
        //        NSURLProtocol.setProperty(base64LoginString, forKey: "Authorization", inRequest: request)
        //        NSURLProtocol.setProperty(AppConstants.TENANT, forKey: "TENANT", inRequest: request)
        //
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        
        request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("WishList Creation responseString = \(responseString)")
                
                let json = JSON(data: data!)
                let item = json["result"]
                    self.wishlistid.append(item["ID"].stringValue)
                    self.wishlistname.append(item["Name"].stringValue)
                
                
                    self.alertFunction()
                
        }
        task.resume()
    }
    
    
    
    func CreateWishListinServerAndAddItem(url : String,value : String){
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        //    let events = EventManager();
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "Post"
        // set Content-Type in HTTP header
        
        //         NSURLProtocol.setProperty("application/json", forKey: "Content-Type", inRequest: request)
        //        NSURLProtocol.setProperty(base64LoginString, forKey: "Authorization", inRequest: request)
        //        NSURLProtocol.setProperty(AppConstants.TENANT, forKey: "TENANT", inRequest: request)
        //
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        
        request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("WishList Creation responseString = \(responseString)")
            
            let json = JSON(data: data!)
            let item = json["result"]
            self.wishlistid.append(item["ID"].stringValue)
            self.wishlistname.append(item["Name"].stringValue)
            
            
            dispatch_async(dispatch_get_main_queue())
            {
                
                //Added For Item Addition
                
                if self.searchActive == true {
                    self.listItems[self.wishpath].wish = "true"
                    self.tableView.reloadData()
                    let wishviewmodel = WishlineitemViewModel.init(productVariantID: self.listItems[self.wishpath].ProductVariantID, productID: self.listItems[self.wishpath].ProductID, wishlistID: self.wishlistid[self.clickedButtonIndex])!
                    let serializedjson  = JSONSerializer.toJson(wishviewmodel)
                    print(serializedjson)
                    self.CreateWishListItem(Appconstant.WEB_API+Appconstant.CREATE_WISH_LIST_LINEITEM, value: serializedjson)
                    
                }
                else{
                    
                    print(self.wishlistid[0])
                    print(self.individualproductid[self.wishpath][0])
                    print(self.productid[self.wishpath][0])
                    
                    self.wishimage[self.wishpath] = "true"
                    self.tableView.reloadData()
                    let wishviewmodel = WishlineitemViewModel.init(productVariantID: self.individualproductid[self.wishpath][0], productID: self.productid[self.wishpath][0], wishlistID: self.wishlistid[self.clickedButtonIndex])!
                    let serializedjson  = JSONSerializer.toJson(wishviewmodel)
                    print("Item addition To Wishlist Request==>>")
                    print(serializedjson)
                    self.CreateWishListItem(Appconstant.WEB_API+Appconstant.CREATE_WISH_LIST_LINEITEM, value: serializedjson)
                }
                
                
                
                self.activityIndicator.stopAnimating()
            }

            
            
            
            self.alertFunction()
            
        }
        task.resume()
    }
    

    
    
    
    func sendrequesttoserverFilter(url : String, value : String)
    {
        
        print(value)
        print(url)
        self.categoryproductItems1.removeAll()
        self.productvariantItems1.removeAll()
        self.listItems.removeAll()
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("ERROR")
                    print("response = \(response)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("")
                print("")
                print("responseString = \(responseString)")
                let json = JSON(data: data!)
                
                
                let item2 = json["result"]
                if(item2["searchKey"].stringValue == self.searchtext) {
                for item in item2["productList"].arrayValue {
                    
                    self.id.removeAll()
                    self.proid.removeAll()
                    self.name.removeAll()
                    self.stock.removeAll()
                    self.type.removeAll()
                    self.price.removeAll()
                    self.Discountpercent.removeAll()
                    self.Discountprice.removeAll()
                    self.unit.removeAll()
                    self.unitid.removeAll()
                    self.quantity.removeAll()
                    self.cartcount.removeAll()
                    
                    
                    
                
                    
                    self.productvariantItems1 = [ProductVariantList1]()

                    for product in  item["ProductVariantList"].arrayValue {
                        
                        self.id.append(product["ID"].intValue)
                        self.proid.append(product["ProductID"].intValue)
                        self.name.append(product["ProductName"].stringValue)
                        self.stock.append(product["Stock"].stringValue)
                        self.type.append(product["Description"].stringValue)
                        self.price.append(product["Price"].stringValue)
                        self.Discountpercent.append(product["DiscountPercentage"].stringValue)
                        self.Discountprice.append(String(product["DiscountPrice"].doubleValue))
                        self.unit.append(product["Unit"].stringValue)
                        self.unitid.append(product["UnitID"].stringValue)
                        self.quantity.append(product["Quantity"].stringValue)
                        self.cartcount.append(product["cartCount"].intValue)
                        
                        let productvariantlist1 = ProductVariantList1(ID: product["ID"].intValue, ProductID: product["ProductID"].intValue,  ProductName: product["ProductName"].stringValue,
                            Price: product["Price"].stringValue, Stock: product["Stock"].stringValue, DiscountPercentage: product["DiscountPercentage"].stringValue, DiscountPrice: product["DiscountPrice"].stringValue, Unit: product["Unit"].stringValue, Type: product["Description"].stringValue,
                            Quantity: product["Quantity"].stringValue, UnitID: product["UnitID"].stringValue, cartCount: product["cartCount"].intValue)!
                        self.productvariantItems1 += [productvariantlist1];
                        
                    }
                    if(item["ImageUrl"].stringValue.isEmpty){
                        let defaultimg = UIImage(named: "loading_sqr.png")
                        let categoryproduct1 = CategoryProduct1(ID: item["ID"].stringValue, Name: item["Name"].stringValue, Description: item["Description"].stringValue,  ProductPhoto : defaultimg!, Productimgurl: item["ImageUrl"].stringValue, ProductvariantList: self.productvariantItems1)!
                        
                        let list = List(ID: item["ID"].stringValue, Name: item["Name"].stringValue, Description: item["Description"].stringValue, ProductPhoto: defaultimg!, Productimgurl: item["ImageUrl"].stringValue, ProductVariantID: self.id[0], ProductID: self.proid[0], ProductName: self.name[0], Price: self.price[0], Stock: self.stock[0], DiscountPercentage: self.Discountpercent[0], DiscountPrice: self.Discountprice[0], Unit: self.unit[0], Type: self.type[0], Quantity: self.quantity[0], UnitID: self.unitid[0], cartCount: self.cartcount[0], wish: item["IsWishListed"].stringValue)!
                        
                        self.categoryproductItems1 += [categoryproduct1];
                        self.listItems += [list];
                        print(list.Name)

                    }
                    else{
                    let categoryimgPath = Appconstant.IMAGEURL+"Images/Products/"+item["ImageUrl"].stringValue;
//                    let productimg =  UIImage(data: NSData(contentsOfURL: NSURL(string:categoryimgPath)!)!)
                        if let data = NSData(contentsOfURL: NSURL(string:categoryimgPath)!){
                            let productimg =  UIImage(data: NSData(contentsOfURL: NSURL(string:categoryimgPath)!)!)
                            let categoryproduct1 = CategoryProduct1(ID: item["ID"].stringValue, Name: item["Name"].stringValue, Description: item["Description"].stringValue,  ProductPhoto : productimg!, Productimgurl: item["ImageUrl"].stringValue, ProductvariantList: self.productvariantItems1)!
                            
                            let list = List(ID: item["ID"].stringValue, Name: item["Name"].stringValue, Description: item["Description"].stringValue, ProductPhoto: productimg!, Productimgurl: item["ImageUrl"].stringValue, ProductVariantID: self.id[0], ProductID: self.proid[0], ProductName: self.name[0], Price: self.price[0], Stock: self.stock[0], DiscountPercentage: self.Discountpercent[0], DiscountPrice: self.Discountprice[0], Unit: self.unit[0], Type: self.type[0], Quantity: self.quantity[0], UnitID: self.unitid[0], cartCount: self.cartcount[0], wish: item["IsWishListed"].stringValue)!
                            
                            self.categoryproductItems1 += [categoryproduct1];
                            self.listItems += [list];
                        }
                        else{
                            let productimg = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png")!)!)
                            let categoryproduct1 = CategoryProduct1(ID: item["ID"].stringValue, Name: item["Name"].stringValue, Description: item["Description"].stringValue,  ProductPhoto : productimg!, Productimgurl: item["ImageUrl"].stringValue, ProductvariantList: self.productvariantItems1)!
                            
                            let list = List(ID: item["ID"].stringValue, Name: item["Name"].stringValue, Description: item["Description"].stringValue, ProductPhoto: productimg!, Productimgurl: item["ImageUrl"].stringValue, ProductVariantID: self.id[0], ProductID: self.proid[0], ProductName: self.name[0], Price: self.price[0], Stock: self.stock[0], DiscountPercentage: self.Discountpercent[0], DiscountPrice: self.Discountprice[0], Unit: self.unit[0], Type: self.type[0], Quantity: self.quantity[0], UnitID: self.unitid[0], cartCount: self.cartcount[0], wish: item["IsWishListed"].stringValue)!
                            
                            self.categoryproductItems1 += [categoryproduct1];
                            self.listItems += [list];
                        }
                    
                    
                    }
                    
                }
                
                print(self.categoryproductItems1.count)
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        }
        
        task.resume()

    }
    
    func clear(){
        self.alertno = 1
        self.pagenumber = 0
        self.pagesize = 4
        self.productvariantItems.removeAll()
        self.categoryproductItems.removeAll()
        self.wishimage.removeAll()
        self.id.removeAll()
        self.proid.removeAll()
        self.name.removeAll()
        self.stock.removeAll()
        self.type.removeAll()
        self.price.removeAll()
        self.Discountpercent.removeAll()
        self.Discountprice.removeAll()
        self.unit.removeAll()
        self.unitid.removeAll()
        self.quantity.removeAll()
        self.cartcount.removeAll()
        self.individualproductid.removeAll()
        self.productid.removeAll()
        self.productname.removeAll()
        self.producttype.removeAll()
        self.productstock.removeAll()
        self.productprice.removeAll()
        self.productDiscountpercent.removeAll()
        self.productDiscountprice.removeAll()
        self.productUnit.removeAll()
        self.productUnitID.removeAll()
        self.productQuantity.removeAll()
        self.productcartcount.removeAll()
    }
    

    @IBAction func recurringBtn(sender: AnyObject) {
        let point = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)!

        
        if searchActive == true {
            Appconstant.productid = listItems[indexPath.row].ProductID
            Appconstant.productvariantid = listItems[indexPath.row].ProductVariantID
        }
        else{
            Appconstant.productid = self.individualproductid[indexPath.row][0]
            Appconstant.productvariantid = self.productid[indexPath.row][0]
        }
        self.displayViewController(.BottomTop)
        
    }


    func displayViewController(animationType: SLpopupViewAnimationType) {
        let myPopupViewController:PopViewController = PopViewController(nibName:"PopViewController", bundle: nil)
        self.presentpopupViewController(myPopupViewController, animationType: animationType, completion: { () -> Void in
            
        })
    }
   
//    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.OverCurrentContext
//    }   
//    
    

}










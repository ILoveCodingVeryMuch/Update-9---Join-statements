CREATE SCHEMA Project;
USE Project;
 #User: Username(PK), Password, Role, FName, LName, Email, HomeAddress, ContactDetail, Gender
CREATE TABLE UserTable(
	Username VARCHAR(20),
    Pass VARCHAR(20),
    UserRole VARCHAR(20),
    FName VARCHAR(20),
    LName VARCHAR(20),
    Email VARCHAR(20),
    HomeAddress VARCHAR(50),
    ContactDetail VARCHAR(20),
    Gender VARCHAR(10),
    Primary Key (Username)
    );
#Vendor: VendorName (PK), MinOrderQuant, Quality, Email, PhoneNo
CREATE TABLE Vendor(
	VendorName VARCHAR(30),
    MinOrderQuant INT(10),
    Quality VARCHAR(10),
    Email VARCHAR(40),
    PhoneNo VARCHAR(12),
    Primary Key (VendorName)
	);
#Item: ItemCode (PK), ItemName, ItemDescript, Price, ManuDate, ExpDate, Manufacturer, ItemImg, VendorName (FK), AltItem
CREATE TABLE Item (
	ItemCode VARCHAR(10),
    ItemName VARCHAR(20),
    ItemDescript VARCHAR(20),
    Price DOUBLE(10,2),
    ManuDate DATE,
    ExpDate DATE,
    Manufacturer VARCHAR(20),
    ItemImg BLOB,
    VendorName VARCHAR(20),
    AltItem VARCHAR(20),
    Primary Key (ItemCode),
    Foreign Key (VendorName) References Vendor(VendorName)
	);
#MaterialIndent: [MIID, SeqNo] (PK), ItemCode (FK), DeliverBy, Quantity, AcceptAltItem
CREATE TABLE MaterialIndent (
	MIID INT(10),
    SeqNo INT(5),
    ItemCode VARCHAR(10),
    DeliverBy DATE,
    Quantity INT(10),
    AcceptAltItem VARCHAR(3),
    Primary Key (MIID, SeqNo),
    Foreign Key (ItemCode) References Item(ItemCode)
    );
#Discount: DiscountNo (PK), ItemCode (FK), DiscRate
CREATE TABLE Discount (
	DiscountNo VARCHAR(10),
    ItemCode VARCHAR(10),
    DiscRate DOUBLE(4,2),
    Primary Key (DiscountNo),
    Foreign Key (ItemCode) References Item(ItemCode)
    );
#PurchaseOrder: [OrderID, SeqNo] (PK), MIID (FK), VendorName(FK)
CREATE TABLE PurchaseOrder (
	OrderID INT(10),
    SeqNo INT(5),
    MIID INT(10),
    MISeq INT(5),
    VendorName VARCHAR(20),
    Primary Key (OrderID, SeqNo),
    Foreign Key (MIID, MISeq) References MaterialIndent(MIID, SeqNo),
    Foreign Key (VendorName) References Vendor(VendorName)
    );
#GoodsReceipt: ReceiptID (PK), OrderID (FK), OrderDate, OrderStatus, BillingAddress, PaymentMethod, OrderPrice
CREATE TABLE GoodsReceipt (
	ReceiptID INT(10),
    OrderID INT(10),
    OrderDate DATE,
    OrderStatus VARCHAR(10),
    BillingAddress VARCHAR(50),
    PaymentMethod VARCHAR(20),
    OrderPrice DOUBLE(10,2),
    Primary Key (ReceiptID),
    Foreign Key (OrderID) References PurchaseOrder(OrderID)
    );
#GR_ItemsOrdered: [ReceiptID, SeqNo] (PK), ItemCode(FK), Quantity
CREATE TABLE GR_ItemsOrdered (
	ReceiptID INT(10),
    SeqNo INT(5),
    ItemCode VARCHAR(10),
    Quantity INT(10),
    Foreign Key (ReceiptID) References GoodsReceipt(ReceiptID),
    Primary Key (ReceiptID, SeqNo)
    );
    
#Filling Tables (10 each)
#User
INSERT INTO UserTable Values("pbicket","password123","Vendor","Patrick","Bicket","email","address","contact","Male");
INSERT INTO UserTable Values("aburhop","password123","Manager","Alex","Burhop","email","address","contact","Male");
INSERT INTO UserTable Values("rfrescoln","password123","Admin","Rachel","Frescoln","email","address","contact","Female");
INSERT INTO UserTable Values("lsingbush","password123","Shop","Lauren","Singbush","email","address","contact","Female");
INSERT INTO UserTable Values("raman","password123","Manager","Raman","Aravamudhan","email","address","contact","Male");
INSERT INTO UserTable Values("ingroj","password123","Manager","Ingroj","Shrestha","email","address","contact","Male");
INSERT INTO UserTable Values("troubleshootAd","password123","Admin","Tester","Admin","email","address","contact","N/A");
INSERT INTO UserTable Values("troubleshootSh","password123","Shop","Tester","Shop","email","address","contact","N/A");
INSERT INTO UserTable Values("troubleshootMg","password123","Manager","Tester","Manager","email","address","contact","N/A");
INSERT INTO UserTable Values("troubleshootVd","password123","Vendor","Tester","Vendor","email","address","contact","N/A");
#Vendor
INSERT INTO Vendor Values("Target",15,"Medium","email","phone");
INSERT INTO Vendor Values("Hawk Shop",10,"Medium","email","phone");
INSERT INTO Vendor Values("Sears",15,"Medium","email","phone");
INSERT INTO Vendor Values("Walmart",15,"Low","email","phone");
INSERT INTO Vendor Values("Dragon's Lair",5,"High","email","phone");
INSERT INTO Vendor Values("Menards",10,"Medium","email","phone");
INSERT INTO Vendor Values("Lowes",20,"Medium","email","phone");
INSERT INTO Vendor Values("Home Depot",20,"Medium","email","phone");
INSERT INTO Vendor Values("Barnes and Nobles",10,"High","email","phone");
INSERT INTO Vendor Values("NFM",40,"Medium","email","phone");
#Item
INSERT INTO Item Values("A1","Screws (100 ct.)","100 Screws",10.49,"2017-6-12",NULL,"Lowes",NULL,"Lowes","A3");
INSERT INTO Item Values("A2","Screws (100 ct.)","100 Premium Screws",14.99,"2017-6-27",NULL,"Menards",NULL,"Menards","A1");
INSERT INTO Item Values("A3","Screws (100 ct.)","100 HQ Screws",12.99,"2015-6-12",NULL,"Home Depot",NULL,"Home Depot","A1");
INSERT INTO Item Values("B1","Broom","It's a broom",10.49,"2017-6-12",NULL,"Target",NULL,"Target","B2");
INSERT INTO Item Values("B2","High Quality Broom","Sweeping power!",33.49,"2017-6-12",NULL,"Walmart",NULL,"Walmart","B1");
INSERT INTO Item Values("C1","DIY Construction","How to build things",34.49,"2013-6-12",NULL,"University Press",NULL,"Barnes and Nobles","C2");
INSERT INTO Item Values("C2","Construction Guide","Building Manual",40.99,"2018-6-12",NULL,"University Press",NULL,"Barnes and Nobles","C1");
INSERT INTO Item Values("D1","Nails (20 ct.)","20 Nails",5.49,"2017-6-12",NULL,"Menards",NULL,"Menards","D2");
INSERT INTO Item Values("D2","Nails (40 ct.)","40 Nails",8.75,"2017-6-12",NULL,"Home Depot",NULL,"Home Depot","D1");
INSERT INTO Item Values("D3","Nails (50 ct.)","50 Nails",10.99,"2017-6-12",NULL,"Lowes",NULL,"Lowes","D2");
#Material Indent
INSERT INTO MaterialIndent Values(1,0,"A1","2018-12-8",5,"Yes");
INSERT INTO MaterialIndent Values(1,1,"D3","2018-12-8",8,"Yes");
INSERT INTO MaterialIndent Values(2,0,"B1","2018-12-22",2,"No");
INSERT INTO MaterialIndent Values(3,0,"C1","2018-12-15",1,"Yes");
INSERT INTO MaterialIndent Values(3,1,"A2","2018-12-7",6,"Yes");
#Discount
INSERT INTO Discount Values("D01","C2",50.00);
#PurchaseOrder
INSERT INTO PurchaseOrder Values(1,0,1,0,"Lowes");
INSERT INTO PurchaseOrder Values(1,1,1,1,"Lowes");
INSERT INTO PurchaseOrder Values(2,0,1,0,"Target");
INSERT INTO PurchaseOrder Values(3,0,1,0,"Barnes and Nobles");
INSERT INTO PurchaseOrder Values(4,0,1,1,"Menards");
#GoodsReciept
##[Fix order Price!]
INSERT INTO GoodsReceipt Values(1,1,"2018-11-25","Delivered","Address","Payment",NULL);
INSERT INTO GoodsReceipt Values(2,2,"2018-12-1","Pending","Address","Payment",NULL);
INSERT INTO GoodsReceipt Values(3,3,"2018-12-1","Pending","Address","Payment",NULL);
INSERT INTO GoodsReceipt Values(4,4,"2018-12-5","Pending","Address","Payment",NULL);
#GR_ItemsOrderd
INSERT INTO GR_ItemsOrdered Values(1,0,"A1",5);
INSERT INTO GR_ItemsOrdered Values(1,1,"D3",8);
INSERT INTO GR_ItemsOrdered Values(2,0,"B1",2);
INSERT INTO GR_ItemsOrdered Values(3,0,"C1",1);
INSERT INTO GR_ItemsOrdered Values(4,0,"A2",6);



 Delimiter //
Create Procedure VendorAdd(in NewVendorName VARCHAR(20), NewMinOrderQuant INT(10), NewQuality VARCHAR(10), NewEmail VARCHAR(20),NewPhoneNo VARCHAR(10))
	Begin
		INSERT INTO Vendor VALUES (NewVendorName, NewMinOrderQuant, NewQuality, NewEmail, NewPhoneNo);
	End //
Delimiter ;

Delimiter //
Create Procedure LoginCheck(in CheckUsername VARCHAR(20), CheckPass VARCHAR(20))
	Begin
		Select * From UserTable Where (Username = CheckUsername AND Pass = CheckPass);
	End //
Delimiter ;

Delimiter //
Create Procedure UserUpdate(in UpdateUsername VARCHAR(20),
    UpdatePass VARCHAR(20),
    UpdateUserRole VARCHAR(20),
    UpdateFName VARCHAR(20),
    UpdateLName VARCHAR(20),
    UpdateEmail VARCHAR(20),
    UpdateHomeAddress VARCHAR(50),
    UpdateContactDetail VARCHAR(20),
    UpdateGender VARCHAR(10))
    Begin
		Update UserTable Set UpdateUserRole = UserRole, UpdateFName = Fname, UpdateLName = Lname,
        UpdateEmail = Email, UpdateHomeAddress = HomeAddress, UpdateContactDetail = ContactDetail,
        UpdateGender = Gender WHERE Username = UpdateUsername AND Pass = UpdatePass;
	End //
Delimiter ;

Delimiter //
Create Procedure UserUpdatePassword(in UpdateUsername VARCHAR(20), UpdatePass VARCHAR(20))
	Begin
		Update UserTable set Pass = UpdatePass WHERE Username = UpdateUsername;
	End //
Delimiter ; 

Delimiter //
Create Procedure AddUser(in UpdateUsername VARCHAR(20),
    UpdatePass VARCHAR(20),
    UpdateUserRole VARCHAR(20),
    UpdateFName VARCHAR(20),
    UpdateLName VARCHAR(20),
    UpdateEmail VARCHAR(20),
    UpdateHomeAddress VARCHAR(50),
    UpdateContactDetail VARCHAR(20),
    UpdateGender VARCHAR(10))
    Begin
		Insert into UserTable values (UpdateUsername, UpdatePass, UpdateUserRole,
        UpdateFName, UpdateLName, UpdateEmail, UpdateHomeAddress,
        UpdateContactDetail, UpdateGender);
	End //
Delimiter ;

Delimiter //
Create Procedure ShopSearch(in SearchItemName VARCHAR(20),
    SearchVendorName VARCHAR(20))
    Begin
		Select * from Item Having ItemName = SearchItemName AND VendorName = SearchVendorName;
	End //
Delimiter ;

Delimiter //
Create Procedure MatIndentInsert(in counterMIID INT(10),
    counterSeqNo INT(5),
    statedItemCode VARCHAR(10),
    generatedDeliverBy DATE,
    insertedQuantity INT(10),
    boolAcceptAltItem VARCHAR(3))
    Begin
		Insert into MaterialIndent Values (counterMIID, counterSeqNo, statedItemCode,
        generatedDeliverBy, insertedQuantity, boolAcceptAltItem);
	End //
Delimiter ;

Delimiter //
Create Procedure PurchaseOrderCreate(in counterOrderID INT(10),
    counterSeqNo INT(5),
    counterMIID INT(10),
    counterMISeq INT(5),
    insertedVendorName VARCHAR(20))
    Begin
		Insert into PurchaseOrder Values (counterOrderID, counterSeqNo,
        counterMIID, counterMISeq, insertedVendorName);
	End //
Delimiter ;

Delimiter //
Create Procedure GoodsReceiptGen (in finalReceiptID INT(10),
    finalOrderID INT(10),
    finalOrderDate DATE,
    finalOrderStatus VARCHAR(10),
    finalBillingAddress VARCHAR(50),
    finalPaymentMethod VARCHAR(20),
    finalOrderPrice DOUBLE(10,2))
    Begin
		Insert into GoodsReceipt Values (finalReceiptID, finalOrderID,
        finalOrderDate, finalOrderStatus, finalBillingAddress,
        finalPaymentMethod, finalOrderPrice);
	End //
Delimiter ;

Delimiter //
Create Procedure GoodsReceiptCreate (in finalReceiptID INT(10))
	Begin
		Select * From GoodsReceipt WHERE ReceiptID = finalReceiptID;
	End //
Delimiter ;

Delimiter //
Create Procedure ManagerVendorChange (in changePhoneNo Varchar(12),
changeMinOrderQuant int(10),
changeQuality Varchar(10),
changeEmail varchar(40))
	begin
		update Vendor set PhoneNo = changePhoneNo, MinOrderQuant = changeMinOrderQuant,
		Quality = changeQuality where Email = changeEmail;
	end //
Delimiter ;

Delimiter //
Create Procedure DeleteVendor (in delVendorName varchar(30))
	begin
		Delete from Vendor where VendorName = delVendorName;
	end //
Delimiter ;

Delimiter //
Create Procedure DeleteUser (in delUsername varchar(20), delPass varchar(20))
	begin
		Delete from UserTable where Username = delUsername and Pass = delPass;
	end //
Delimiter ;

Delimiter //
create procedure PrintReceipt(in requestReceiptId int(10))
	begin
		Select GoodsReceipt.OrderID, PurchaseOrder.SeqID, PurchaseOrder.MIID, PurchaseOrder.MISeq,
    PurchaseOrder.VendorName, OrderDate, OrderStatus, BillingAddress, PaymentMethod, OrderPrice
    from GoodsReceipt
    inner join PurchaseOrder
    on GoodsReceipt.OrderID = PurchaseOrder.OrderID
    where ReceiptId = requestReceiptId;
	end //
Delimiter ;
	
Delimiter //
create procedure PrintMatIndents (in requestOrderId Int(10))
	begin
		Select MaterialIndent.MIID, MaterialIndent.SeqNo, MaterialIndent.ItemCode, 
        MaterialIndent.DeliverBy, MaterialIndent.Quantity, MaterialIndent.AcceptAltItem, VendorName
        FROM PurchaseOrder
        inner join MaterialIndent
        on PurchaseOrder.MIID = MaterialIndent.MIID
        where PurchaseOrder.MIID = requestOrderID;
	end //
Delimiter ;

	
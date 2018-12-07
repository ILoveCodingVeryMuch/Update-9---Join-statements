from flask import Flask, render_template, redirect, url_for, request
from datetime import datetime, timedelta
import pymysql
import pymysql.cursors
conn= pymysql.connect(host='localhost', user='root', password='Rainbow.86', db='Project')
app = Flask(__name__)
counterMatIndent = 4
sequencecounterMatIndent = 0
Ndays = 10
orderidcounter = 5
sequencecounterPurchaseOrder = 0
receiptID = 5


@app.route('/AdminHome')
def AdminHome():
    return render_template('adminhome.html')

@app.route('/AdminChangeInfo', methods = ['GET', 'POST'])
def AdminChangeInfo():
    a = conn.cursor()
    error = None
    if request.method == 'POST':
        Name = request.form['Username']
        Password = request.form['Pass']
        FName = request.form['FName']
        LName = request.form['LName']
        Email = request.form['Email']
        Address = request.form['Address']
        ContactDetail = request.form['ContactDetail']
        Gender = request.form['Gender']
        userupdateargs = [FName, LName, Email, Address, ContactDetail, Gender, Name, Password]
        a.callproc('UserUpdate', userupdateargs)
        conn.commit()
        return redirect(url_for('AdminHome'))
    return render_template('adminchangeinfo.html')

@app.route('/AdminUpdatePass', methods = ['GET', 'POST'])
def AdminUpdate():
    a = conn.cursor()
    error = None
    if request.method =='POST':
        Name = request.form['Username']
        Password = request.form['Pass']
        updatepassargs = [Password, Name]
        a.callproc('UserUpdatePassword', updatepassargs)
        conn.commit()
        return redirect(url_for('AdminHome'))
    return render_template('adminupdate.html', error = error)

@app.route('/AdminAdd', methods = ['GET', 'POST'])
def AdminAdd():
    a = conn.cursor()
    error = None
    if request.method =='POST':
        Name = request.form['Username']
        Password = request.form['Pass']
        Role = request.form['UserRole']
        FName = request.form['FName']
        LName = request.form['LName']
        Email = request.form['Email']
        Address = request.form['Address']
        ContactDetail = request.form['ContactDetail']
        Gender = request.form['Gender']
        adduserargs = [Name, Password, Role, FName, LName, Email, Address, ContactDetail, Gender]
        a.callproc('AddUser', adduserargs)
        conn.commit()
        return redirect(url_for('AdminHome'))
    return render_template('adminadd.html', error = error)


@app.route('/AdminDelete', methods = ['GET', 'POST'])
def AdminDelete():
    a = conn.cursor()
    error = None
    if request.method == 'POST':
        Usern = request.form['Username']
        Passw = request.form['Pass']
        adddeletionargs = [Usern, Passw]
        a.callproc('DeleteUser', adddeletionargs)
        conn.commit()
        return redirect(url_for('AdminHome'))
    return render_template('admindelete.html', error = error)

 ####################################################

@app.route('/ManagerHome')
def ManagerHome():
    return render_template('managerhome.html')

@app.route('/vendorchangeinfo', methods = ['GET', 'POST'])
def VendorChangeInfo():
    a = conn.cursor()
    error = None
    if request.method =='POST':
        email = request.form['Email']
        phoneno = request.form['PhoneNo']
        minorderquant = request.form['MinOrderQuant']
        quality = request.form['Quality']
        changeargs = [phoneno, minorderquant, quality, email]
        a.callproc('ManagerVendorChange', changeargs)
        conn.commit()
        return redirect(url_for('ManagerHome'))
    return render_template('vendorchangeinfo.html', error = error)


@app.route('/deletevendor', methods = ['GET', 'POST'])
def DeleteVendor():
    a = conn.cursor()
    if request.method == 'POST':
        vendname = request.form['VendorName']
        deleteargs = [vendname]
        a.callproc('DeleteVendor', deleteargs)
        conn.commit()
        return redirect(url_for('ManagerHome'))
    return render_template('deletevendor.html')

@app.route('/receiptsonscreen', methods = ['GET', 'POST'])
def PrintGoodsReceipts():
    a = conn.cursor()
    if request.method == 'POST':
        recID = request.form['ReceiptID']
        receiptargs = [recID]
        a.callproc('PrintReceipt', receiptargs)
        results = a.fetchall()
        print(results)
    return render_template('receiptrequest.html')

@app.route('/matindentlist', methods = ['GET', 'POST'])
def ListMatIndents():
    a = conn.cursor()
    if request.method == 'POST':
        OrderID = request.form['OrderID']
        matidargs = [OrderID]
        a.callproc('PrintMatIndents', matidargs)
        results = a.fetchall()
        print(results)
    return render_template('MIrequest.html')
 ####################################################

#counterMatIndent = 4
#sequencecounterMatIndent = 0
#Ndays = 10
#orderidcounter = 5
#sequencecounterPurchaseOrder = 0
#receiptID = 5
@app.route('/ShopHome')
def ShopHome():
    return render_template('shophome.html')

@app.route('/search', methods =['GET', 'POST'])
def ShopSearch():
    global counterMatIndent
    global sequencecounterMatIndent
    global Ndays
    Date_N_Days_From_Now = datetime.now() + timedelta(days=Ndays)
    a = conn.cursor()
    error = None
    if request.method == 'POST':
        item = request.form['searchitem']
        vendorname = request.form['searchvendor']
        quantity = request.form['quantity']
        altitembool = request.form['altitem']
        #print(item)
        #print(vendorname)
        searchargs = [item, vendorname]
        a.callproc('ShopSearch', searchargs)
        results = a.fetchone()
        #print(results)
        N1 = results[0]
        matindargs = [counterMatIndent, sequencecounterMatIndent, N1, Date_N_Days_From_Now.date(), quantity, altitembool]
        print(matindargs)
        a.callproc('MatIndentInsert', matindargs)
        conn.commit()
        #print(results)
        return redirect(url_for('PurchaseOrderCreate'))
    return render_template('fancysearch.html', error = error)
@app.route('/PurchaseOrderCreate', methods =['GET', 'POST'])

def PurchaseOrderCreate():
    a = conn.cursor()
    error = None
    if request.method == 'POST':
        global counterMatIndent
        global sequencecounterMatIndent
        global orderidcounter
        global sequencecounterPurchaseOrder
        VendorNameSql = request.form['VendorName']
        print(VendorNameSql)
        purchaseorderargs = [orderidcounter, sequencecounterPurchaseOrder, counterMatIndent, sequencecounterMatIndent, VendorNameSql]
        a.callproc('PurchaseOrderCreate', purchaseorderargs)
        conn.commit()
        sequencecounterMatIndent = sequencecounterMatIndent + 1
        sequencecounterPurchaseOrder = sequencecounterPurchaseOrder + 1
        return redirect(url_for('OrderMoreItems'))
    return render_template('purchaseordervendorfill.html', error = error)

@app.route('/OrderMoreItems')
def OrderMoreItems():
    print(sequencecounterMatIndent)
    return render_template('shophomeaftersearch.html')

@app.route('/CreateNewIndent', methods = ['GET', 'POST'])
def CreateNewIndent():
    global counterMatIndent
    counterMatIndent = counterMatIndent + 1
    global sequencecounterMatIndent
    sequencecounterMatIndent = 0
    global Ndays
    Date_N_Days_From_Now = datetime.now() + timedelta(days=Ndays)
    a = conn.cursor()
    error = None
    if request.method == 'POST':
        item = request.form['searchitem']
        vendorname = request.form['searchvendor']
        quantity = request.form['quantity']
        altitembool = request.form['altitem']
        print(item)
        print(vendorname)
        newsearchargs = [item, vendorname]
        a.callproc('ShopSearch', newsearchargs)
        results = a.fetchone()
        print(results)
        N1 = results[0]
        morematindargs = [counterMatIndent, sequencecounterMatIndent, N1, Date_N_Days_From_Now.date(), quantity, altitembool]
        a.callproc('MatIndentInsert', morematindargs)
        conn.commit()
        # print(results)
        return redirect(url_for('OrderMoreItems'))
    return render_template('fancysearch.html', error=error)

@app.route('/AddANewPurchaseOrder')
def AddANewPurchaseOrder():
    global orderidcounter
    global sequencecounterPurchaseOrder
    global receiptID
    dateoforder = datetime.now()
    print(dateoforder)
    a = conn.cursor()
    Pend = 'Pending'
    Addr = 'Address'
    Paym = 'Payment'
    Price = 0.00
    purchorderargs = [receiptID, orderidcounter, dateoforder.date(), Pend, Addr, Paym, Price]
    a.callproc('GoodsReceiptGen', purchorderargs)
    conn.commit()
    receiptID = receiptID + 1
    orderidcounter = orderidcounter + 1
    sequencecounterPurchaseOrder = 0
    return render_template('shopcreateanotherpurchaseorder.html')

@app.route('/CreateGoodsReceipt')
def CreateGoodsReceipt():
    global receiptID
    a = conn.cursor()
    goodsrecargs = [receiptID]
    a.callproc('GoodsReceiptCreate', goodsrecargs)
    results = a.fetchall()
    print(results)
    return(redirect(url_for('ShopHome')))

######################################

@app.route('/VendorHome')
def VendorHome():
    return render_template('vendorhome.html')


@app.route('/VendorAdd', methods = ['GET', 'POST'])
def VendorAdd():
    a = conn.cursor()
    error = None
    if request.method =='POST':
        vname = request.form['VendorName']
        minquant = request.form['MinOrderQuant']
        quality = request.form['Quality']
        email = request.form['Email']
        phoneno = request.form['PhoneNo']
        args = [vname, minquant, quality, email, phoneno]
        a.callproc('VendorAdd', args)
        conn.commit()
        return redirect(url_for('VendorHome'))
    return render_template('vendoradd.html', error = error)

 #######################################

@app.route('/')
def home():
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        usern = request.form['username']
        passw = request.form['password']
        a = conn.cursor()
        loginargs = [usern, passw]
        a.callproc('LoginCheck', loginargs)
        data = a.fetchone()
        if data[2] == "Admin":
            return redirect(url_for('AdminHome'))
        elif data[2] == "Shop":
            return redirect(url_for('ShopHome'))
        elif data[2] == 'Manager':
            return redirect(url_for('ManagerHome'))
        elif data[2] == "Vendor":
            return redirect(url_for('VendorHome'))
        #....
        else:
            error = 'Invalid Credentials. Please try again.'
    return render_template('fancylogin.html', error=error)


if __name__ == '__main__':
    app.run(debug=True)

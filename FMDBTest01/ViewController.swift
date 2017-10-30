//
//  ViewController.swift
//  FMDBTest01
//


import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var familyname: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!

    @IBAction func SAVEaction(_ sender: UIButton) {
        if !FileManager.default.fileExists(atPath: dbpath){ return }
        
        let connectiontoFMDB = FMDatabase(path: dbpath);
        if( connectiontoFMDB.open() ){
            let sqlstatement = "insert into person (firstname, familyname, phone) values ('\(self.firstname.text!)', '\(self.familyname.text!)', '\(self.phone.text!)');";
                
            let result = connectiontoFMDB.executeUpdate(sqlstatement, withArgumentsIn: []);
            self.status.text = result ? "SAVE SUCCESS!" : "SAVE FAILURE!";
            disableEditButtons();
            clearTextFields();
        }
        
        connectiontoFMDB.close();
    }
    
    @IBAction func LOADaction(_ sender: UIButton) {
        if !FileManager.default.fileExists(atPath: dbpath){ return }
        
        let connectiontoFMDB = FMDatabase(path: dbpath);
        if( connectiontoFMDB.open() ){
            let sqlstatement = "select familyname, phone from person where firstname = '\(self.firstname.text!)';";
                
            let resultset: FMResultSet? = connectiontoFMDB.executeQuery(sqlstatement, withArgumentsIn: []);
            if resultset?.next() == true{
                self.familyname.text = resultset!.string(forColumn: "familyname");
                self.phone.text = resultset!.string(forColumn: "phone");
                self.status.text = "LOAD SUCCESS!"
                self.DeleteButton.isEnabled = true;
                self.updateButton.isEnabled =  true;
            } else{
                self.status.text = "LOAD FAILURE!"
            }
                
        }
        
        connectiontoFMDB.close();
    }
    
    @IBOutlet weak var DeleteButton: UIButton!
    @IBAction func DELETEaction(_ sender: UIButton) {
        if !FileManager.default.fileExists(atPath: dbpath){ return }
        
        let connectiontoFMDB = FMDatabase(path: dbpath);
        if( connectiontoFMDB.open() ){
            let sqlstatement = "delete from person where firstname = '\(self.firstname.text!)';";
                
            let result = connectiontoFMDB.executeUpdate(sqlstatement, withArgumentsIn: []);
            self.status.text = result ? "DELETE SUCCESS!" : "DELETE FAILURE!";
            disableEditButtons();
            clearTextFields();
        }
        
        connectiontoFMDB.close();
    }
    
    @IBOutlet weak var updateButton: UIButton!
    @IBAction func UPDATEaction(_ sender: UIButton) {
        if !FileManager.default.fileExists(atPath: dbpath){ return }
        
        let connectiontoFMDB = FMDatabase(path: dbpath);
        if( connectiontoFMDB.open() ){
            let sqlstatement = "update person set familyname = '\(self.familyname.text!)' ,phone = '\(self.phone.text!)' where firstname = '\(self.firstname.text!)' ;";
            
            let result = connectiontoFMDB.executeUpdate(sqlstatement, withArgumentsIn: []);
            self.status.text = result ? "UPDATE SUCCESS!" : "UPDATE FAILURE!";
            disableEditButtons();
            clearTextFields();
        }
        
        connectiontoFMDB.close();
    }
    
    @IBAction func firstnameEdited(_ sender: UITextField) {
        disableEditButtons();
    }
    
    func clearTextFields() {
        self.firstname.text = "";
        self.familyname.text = "";
        self.phone.text = "";
    }
    
    func disableEditButtons() {
        self.DeleteButton.isEnabled = false;
        self.updateButton.isEnabled =  false;
    }
    
    

    var dbpath: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // We use default filemanager in this exercise. It's FileManager.default.
        // Find path to database by finding the document directory first.
        let pathdummy = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask);
        
        // The path to DB location is set into document directory root and name of DB is set as mydatabase.db
        dbpath = pathdummy[0].appendingPathComponent("mydatabase.db").path;
        print(dbpath);
        
        if !FileManager.default.fileExists(atPath: dbpath){
            // No DB found so it must be created now.
            let connectiontoFMDB = FMDatabase(path: dbpath);
            
            // Connection to DB must established
            if( connectiontoFMDB.open() ){
                let sqlstatement = "create table if not exists person (id integer primary key autoincrement, firstname text, familyname text, phone integer);";
                connectiontoFMDB.executeStatements(sqlstatement);
                NSLog(connectiontoFMDB.debugDescription);
            }
            
            connectiontoFMDB.close();
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ViewController.swift
//  Desafio da Saude MV
//
//  Created by Alice Kellen on 11/10/20.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filterSC: UISegmentedControl!
    @IBOutlet weak var cnesTV: UITableView!
    @IBOutlet weak var viewForm: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var managementField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var cepField: UITextField!
    @IBOutlet weak var districtField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var ufField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var heightViewForm: NSLayoutConstraint!
    
    let cellReuseIdentifier = "cell"
    var listCNES: [Cnes] = []
    var itemUpdate: Cnes = Cnes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hiddenShowForm(show: false)
        self.getCnesList()
        self.cnesTV.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        cnesTV.delegate = self
        cnesTV.dataSource = self
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        NotificationCenter.default.addObserver(self,
               selector: #selector(self.keyboardNotification(notification:)),
               name: UIResponder.keyboardWillChangeFrameNotification,
               object: nil)
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
       }
     
       @objc func keyboardNotification(notification: NSNotification) {
         guard let userInfo = notification.userInfo else { return }

         let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
         let endFrameY = endFrame?.origin.y ?? 0
         let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
         let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
         let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
         let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)

         if endFrameY >= UIScreen.main.bounds.size.height {
           self.heightViewForm?.constant = 0.0
         } else {
            self.heightViewForm?.constant = 272.0 + (endFrame?.size.height ?? 0.0)
         }

         UIView.animate(
           withDuration: duration,
           delay: TimeInterval(0),
           options: animationCurve,
           animations: { self.view.layoutIfNeeded() },
           completion: nil)
       }

    func getCnesList(){
                
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let list = jsonResult["cnes"] as? [Any] {
                    
                    for item in list {
                        let cnes = Cnes(data: item as! [String : Any])
                        self.listCNES.append(cnes)
                    }
                    self.listCNES = self.listCNES.sorted(by: {$0.ds_tipo_unidade < $1.ds_tipo_unidade})
                  }
              } catch {
                   print("Erro ao acessar banco de dados")
              }
        }
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch filterSC.selectedSegmentIndex {
        case 0:
            self.listCNES = self.listCNES.sorted(by: {$0.ds_tipo_unidade < $1.ds_tipo_unidade})
            self.cnesTV.reloadData()
        case 1:
            self.listCNES = self.listCNES.sorted { $0.uf.lowercased() < $1.uf.lowercased() }
            self.cnesTV.reloadData()
        default:
            break;
        }
    }
    
    @IBAction func update(_ sender: Any) {
        self.viewForm.isHidden = true
        self.heightViewForm.constant = 0.0
        self.hideKeyboard()
        
        self.itemUpdate.no_fantasia = self.nameField.text!
        self.itemUpdate.tp_gestao = self.managementField.text!
        self.itemUpdate.ds_tipo_unidade = self.typeField.text!
        self.itemUpdate.co_cep = self.cepField.text!
        self.itemUpdate.no_bairro = self.districtField.text!
        self.itemUpdate.municipio = self.cityField.text!
        self.itemUpdate.no_logradouro = self.streetField.text!
        self.itemUpdate.nu_endereco = self.numberField.text!
        self.itemUpdate.uf = self.ufField.text!
        self.itemUpdate.nu_telefone = self.phoneField.text!
        
        let dictionary: [String: Any] = ["co_cnes": self.itemUpdate.co_cnes,
                                         "co_ibge": self.itemUpdate.co_ibge,
                                         "no_fantasia": self.itemUpdate.no_fantasia,
                                         "ds_tipo_unidade": self.itemUpdate.ds_tipo_unidade,
                                         "tp_gestao": self.itemUpdate.tp_gestao,
                                         "no_logradouro": self.itemUpdate.no_logradouro,
                                         "nu_endereco": self.itemUpdate.nu_endereco,
                                         "no_bairro": self.itemUpdate.no_bairro,
                                         "co_cep": self.itemUpdate.co_cep,
                                         "uf": self.itemUpdate.uf,
                                         "municipio": self.itemUpdate.municipio,
                                         "nu_telefone": self.itemUpdate.nu_telefone]
        
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("data.json")

            try JSONSerialization.data(withJSONObject: dictionary)
                .write(to: fileURL)
        } catch {
            print(error)
        }
    }
    @IBAction func cancel(_ sender: Any) {
        self.viewForm.isHidden = true
        self.heightViewForm.constant = 0.0
        self.hideKeyboard()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listCNES.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.cnesTV.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!

        cell.textLabel?.text = self.listCNES[indexPath.row].no_fantasia
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = self.listCNES[indexPath.row]
        self.fillForm(item: selectedItem)
        self.hiddenShowForm(show: true)
    }
    
    func fillForm(item: Cnes){
        self.itemUpdate = item
        self.nameField.text = (item.no_fantasia != "") ? item.no_fantasia : ""
        self.managementField.text = (item.tp_gestao != "") ? item.tp_gestao : ""
        self.typeField.text = (item.ds_tipo_unidade != "") ? item.ds_tipo_unidade : ""
        self.cepField.text = (item.co_cep != "") ? "\(item.co_cep)" : ""
        self.districtField.text = (item.no_bairro != "") ? item.no_bairro : ""
        self.cityField.text = (item.municipio != "") ? item.municipio : ""
        self.streetField.text = (item.no_logradouro != "") ? item.no_logradouro : ""
        self.numberField.text = (item.nu_endereco != "") ? item.nu_endereco : ""
        self.ufField.text = (item.uf != "") ? item.uf : ""
        self.phoneField.text = (item.nu_telefone != "") ? "\(item.nu_telefone)" : ""
    }
    
    func hiddenShowForm(show: Bool){
        self.viewForm.isHidden = true
        self.heightViewForm.constant = 0.0
        if show {
            self.viewForm.isHidden = false
            self.heightViewForm.constant = 272.0
        }
    }
}

#if canImport(UIKit)
extension ViewController {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

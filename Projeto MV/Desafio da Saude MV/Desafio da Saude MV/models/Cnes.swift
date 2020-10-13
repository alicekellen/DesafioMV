//
//  Cnes.swift
//  Desafio da Saude MV
//
//  Created by Alice Kellen on 11/10/20.
//

import Foundation

class Cnes: Codable {
    var co_cep: String = ""
    var co_cnes: String = ""
    var co_ibge: String = ""
    var ds_tipo_unidade: String = ""
    var municipio: String = ""
    var no_bairro: String = ""
    var no_fantasia: String = ""
    var no_logradouro: String = ""
    var nu_endereco: String = ""
    var tp_gestao: String = ""
    var uf: String = ""
    var nu_telefone: String = ""
    
    init(){
        
    }
    
    init(data: [String : Any]){
        co_cep = (data["co_cep"] as? String)!
        co_cnes = (data["co_cnes"] as? String)!
        co_ibge = (data["co_ibge"] as? String)!
        ds_tipo_unidade = (data["ds_tipo_unidade"] as? String)!
        municipio = data["municipio"] as? String ?? ""
        no_bairro = data["no_bairro"] as? String ?? ""
        no_fantasia = data["no_fantasia"] as? String ?? ""
        no_logradouro = (data["no_logradouro"] as? String)!
        nu_endereco = data["nu_endereco"] as? String ?? "S/N"
        tp_gestao = (data["tp_gestao"] as? String)!
        uf = data["uf"] as? String ?? ""
        nu_telefone = (data["nu_telefone"] as? String)!
    }
    
    init(codCnes:String, codIbge:String, nome:String, tipo:String, gestao:String, logradouro:String, endereco:String, bairro:String, cep:String, estado:String, cidade:String, telefone:String) {
        self.co_cnes = codCnes
        self.co_ibge = codIbge
        self.no_fantasia = nome
        self.ds_tipo_unidade = tipo
        self.tp_gestao = gestao
        self.no_logradouro = logradouro
        self.nu_endereco = endereco
        self.no_bairro = bairro
        self.co_cep = cep
        self.uf = estado
        self.municipio = cidade
        self.nu_telefone = telefone
    }
}

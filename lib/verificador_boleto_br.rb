require_relative "./verificador_boleto_br/version"
require_relative "./verificador_boleto_br/operationals"
require_relative "./verificador_boleto_br/calculus/module10"
require_relative "./verificador_boleto_br/calculus/module11"
require_relative "./verificador_boleto_br/slip/arrecadation/code_assembly"
require_relative "./verificador_boleto_br/slip/arrecadation/validity"
require_relative "./verificador_boleto_br/slip/bank/code_assembly"
require_relative "./verificador_boleto_br/slip/bank/validity"

require 'date'

module VerificadorBoletoBr
  include Operationals
  def self.check(code)
    clean_code =  code.gsub(/( |\.|-)/, '')
    if clean_code.size.eql?(47)
      VerificadorBoletoBr::Slip::Bank::Validity.new(code)
    elsif clean_code.size.eql?(48)
      VerificadorBoletoBr::Slip::Arrecadation::Validity.new(code)
    else
      raise ArgumentError, 'Invalid Digitable Line'
    end
  end

  def self.translate_barcode(code)
    clean_code =  code.gsub(/( |\.|-)/, '')
    if clean_code.size.eql?(44) && clean_code[0] != '8'
      VerificadorBoletoBr::Slip::Bank::CodeAssembly.new(code)
    elsif clean_code.size.eql?(44) && clean_code[0] == '8'
      VerificadorBoletoBr::Slip::Arrecadation::CodeAssembly.new(code)
    else
      raise ArgumentError, 'Invalid Barcode'
    end
  end
end

require_relative "./verificador_boleto_br/version"
require_relative "./verificador_boleto_br/operationals"
require_relative "./verificador_boleto_br/calculus/module10"
require_relative "./verificador_boleto_br/calculus/module11"
require_relative "./verificador_boleto_br/arrecadation_slip"
require_relative "./verificador_boleto_br/bank_slip"

require 'date'

module VerificadorBoletoBr
  include Operationals
  def self.check(digitable_line)
    if digitable_line.gsub(/( |\.|-)/, '').size.eql?(47)
      BankSlip.new(digitable_line)
    elsif digitable_line.gsub(/( |\.|-)/, '').size.eql?(48)
      ArrecadationSlip.new(digitable_line)
    else
      raise ArgumentError, 'Invalid Digitable Line'
    end
  end
end

module VerificadorBoletoBr
  module Operationals
    def clean_masks(cod)
      cod.gsub(/( |\.|-)/, '')
    end

    def bank_epoque(number_of_days)
      Date.new(1997, 10, 7) + number_of_days
    end
  end
end
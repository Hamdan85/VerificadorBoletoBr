module VerificadorBoletoBr
  module Calculus
    module Module11
      def modulo11(str)
        peso = 2
        soma = 0

        str = str.chars.reverse

        str.each do |char|
          soma += char.to_i * peso
          peso = peso == 9 ? 2 : peso + 1
        end
        dv = soma % 11
        return 0 if dv == 0 || dv == 1

        return 1 if dv == 10

        11 - dv
      end
    end
  end
end
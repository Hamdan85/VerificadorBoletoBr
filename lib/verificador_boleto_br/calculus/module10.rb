module VerificadorBoletoBr
  module Calculus
    module Module10
      def modulo10(str)
        str  = str.chars.reverse
        i    = 2
        sum  = 0
        res  = 0

        str.each do |char|
          res = char.to_i * i
          sum += res > 9 ? (res - 9) : res
          i = i == 2 ? 1 : 2
        end

        if (sum % 10) == 0
          0
        else
          10 - (sum % 10)
        end
      end
    end
  end
end
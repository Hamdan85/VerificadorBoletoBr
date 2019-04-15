module VerificadorBoletoBr
  module Slip
    module Bank
      class CodeAssembly
        include VerificadorBoletoBr::Calculus::Module10
        include VerificadorBoletoBr::Calculus::Module11

        attr_accessor :code

        def initialize(code)
          @code = code
        end

        def digitable_line
          block_1 = code[0..3] + code[19..23] + modulo10(code[0..3] + code[19..23]).to_s
          block_2 = code[24..33] + modulo10(code[24..33]).to_s
          block_3 = code[34..-1] + modulo10(code[34..-1]).to_s
          block_1 + block_2 + block_3 + code[4..18]
        end
      end
    end
  end
end
module VerificadorBoletoBr
  module Slip
    module Arrecadation
      class CodeAssembly

        include VerificadorBoletoBr::Calculus::Module10
        include VerificadorBoletoBr::Calculus::Module11

        def initialize(code)
          @code = code
        end

        def treated_group
          @code.scan(/.{1,11}/m)
        end

        def treated_code
          treated_group.map {|partial| partial << "0" }.join
        end

        def digitable_line
          result = ""
          treated_group.each do |group|
            result += group + send(bacen_module, group).to_s
          end
          result
        end

        def bacen_module
          case treated_code[2]
          when '6'
            'modulo10'
          when '7'
            'modulo10'
          when '8'
            'modulo11'
          when '9'
            'modulo11'
          end
        end
      end
    end
  end
end


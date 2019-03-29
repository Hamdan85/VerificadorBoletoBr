require 'json'

module VerificadorBoletoBr
  class ArrecadationSlip

    include VerificadorBoletoBr::Operationals
    include VerificadorBoletoBr::Calculus::Module10
    include VerificadorBoletoBr::Calculus::Module11

    attr_accessor :digitable_line, :errors

    def initialize(cod)
      @digitable_line = cod
      raise ArgumentError, 'Expected String'              unless @digitable_line.class.eql?(String)
      raise ArgumentError, 'Invalid Digitable Line'       unless clean_digitable_line.size == 48
      raise ArgumentError, 'Boleto Não é de Arrecadação'  unless @digitable_line[0] == '8'

      @errors = []
    end

    def clean_digitable_line
      clean_masks(@digitable_line)
    end

    def verification_digit
      clean_digitable_line[3].to_i
    end

    def value_in_cents
      return nil unless valid?
      digitable_line_without_dvs[4..14].to_i
    end

    def value
      return nil unless valid?
      value_in_cents.to_f / 100
    end

    def due_date
      begin
        Date.parse(digitable_line_without_dvs[-6..-1])
      rescue
        nil
      end
    end

    def segment
      case clean_digitable_line[1]
      when '1'
        'Prefeitura'
      when '2'
        'Saneamento'
      when '3'
        'Energia Elétrica e Gás'
      when '4'
        'Telefonia'
      when '5'
        'Órgãos Governamentais'
      when '6'
        'Empresas / Órgãos com CNPJ.'
      when '7'
        'Multa de trânsito'
      when '9'
        'Uso exclusivo do banco'
      end
    end

    def identification
      begin
        JSON.parse(File.read('lib/verificador_boleto_br/data/Dealerships.json'))
          .select { |d| d['code'] == clean_digitable_line[15..18] && d['segment'] == clean_digitable_line[1].to_i }[0]["dealership"]
      rescue
        "Boleto de #{segment}"
      end
    end

    def bacen_module
      case clean_digitable_line[2]
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

    def valid?
      global_validity && !groups_validity.map { |group| group[:valid] }.include?(false)
    end

    def groups_validity
      grouped_digitable_line.map do |group|
        dv = send(bacen_module, group[:num]).to_s
        valid = dv.eql?(group[:dv])
        errors << "Campo #{group[:group]}" unless valid
        {
          group: group[:group],
          valid: valid
        }
      end
    end

    def global_validity
      send(bacen_module, digitable_line_without_dvs[0..2] + digitable_line_without_dvs[4..-1]) == verification_digit
    end

    def grouped_digitable_line
      clean_digitable_line.scan(/.{1,12}/).each_with_index.map do |group, index|
        {
          group: index,
          num: group[0..-2],
          dv: group[-1]
        }
      end
    end

    def digitable_line_without_dvs
      grouped_digitable_line.map { |group| group[:num] }.join
    end
  end
end
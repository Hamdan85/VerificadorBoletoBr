module VerificadorBoletoBr
  class BankSlip
    include VerificadorBoletoBr::Operationals
    include VerificadorBoletoBr::Calculus::Module10
    include VerificadorBoletoBr::Calculus::Module11

    attr_accessor :digitable_line, :errors

    def initialize(cod)
      @digitable_line = cod
      raise ArgumentError, 'Expected String'              unless @digitable_line.class.eql?(String)
      raise ArgumentError, 'Invalid Digitable Line'       unless clean_digitable_line.size == 47
    end

    def clean_digitable_line
      clean_masks(@digitable_line)
    end

    def bank_code
      clean_digitable_line[0..2].to_i
    end

    def currency_code
      clean_digitable_line[3].to_i
    end

    def verification_digit
      clean_digitable_line[32].to_i
    end

    def value_in_cents
      clean_digitable_line[37..-1].to_i
    end

    def value
      value_in_cents.to_f / 100
    end

    def block_1_validity
      modulo10(clean_digitable_line[0..8]).eql?clean_digitable_line[9].to_i
    end

    def block_2_validity
      modulo10(clean_digitable_line[10..19]).eql?clean_digitable_line[20].to_i
    end

    def block_3_validity
      modulo10(clean_digitable_line[21..30]).eql?clean_digitable_line[31].to_i
    end

    def global_validity
      str = ""
      str += clean_digitable_line[0..2]
      str += clean_digitable_line[3..3]
      str += clean_digitable_line[32..32]
      str += clean_digitable_line[33..36]
      str += clean_digitable_line[37..46]
      str += clean_digitable_line[4..8]
      str += clean_digitable_line[10..19]
      str += clean_digitable_line[21..30]

      modulo11(str[0..3] + str[5..-1]).eql?(verification_digit)
    end

    def due_date
      begin
        bank_epoque(clean_digitable_line[33..36].to_i)
      rescue
        nil
      end
    end

    def valid?
      block_1_validity && block_2_validity && block_3_validity && global_validity
    end

    def grouped_digitable_line
      [
        {
          group: 0,
          valid: block_1_validity
        },
        {
          group: 1,
          valid: block_2_validity
        },
        {
          group: 2,
          valid: block_2_validity
        },
      ]
    end

    def segment
      'Boleto Bancário'
    end

    def identification
      'Boleto Bancário'
    end
  end
end
require 'spec_helper'

RSpec.describe VerificadorBoletoBr::ArrecadationSlip do

  VALID_SLIP      = '858900000018 097802702000 323858108001 011520190292'
  INVALID_SLIP    = '858900000018 097802702000 323848108001 011520190292'

  context "Initializing" do
    it "should receive ONE string as argument" do
      expect { VerificadorBoletoBr::ArrecadationSlip.new() }.to raise_error(ArgumentError)
      expect { VerificadorBoletoBr::ArrecadationSlip.new(VALID_SLIP, 1) }.to raise_error(ArgumentError)
    end

    it "should receive a 44 chars digitable line" do
      expect { VerificadorBoletoBr::ArrecadationSlip.new('123') }.to raise_error(ArgumentError)
    end
  end

  context "testing a valid slip digitable line" do
    it "should return if slip is valid" do
      expect(VerificadorBoletoBr::ArrecadationSlip.new(VALID_SLIP)).to respond_to(:valid?)
      expect(VerificadorBoletoBr::ArrecadationSlip.new(VALID_SLIP).valid?).to be_truthy
    end

    it "should return if slip is invalid" do
      expect(VerificadorBoletoBr::ArrecadationSlip.new(INVALID_SLIP).valid?).to be_falsy
    end

    it "should show which fields are messy" do
      expect(VerificadorBoletoBr::ArrecadationSlip.new(INVALID_SLIP).groups_validity.class).to be(Array)
      expect(VerificadorBoletoBr::ArrecadationSlip.new(INVALID_SLIP).groups_validity.size).to be > 0
    end
  end

  context "gathering info from slip" do
    it "should return slip's amount in cents" do
      expect(VerificadorBoletoBr::ArrecadationSlip.new(VALID_SLIP)).to respond_to(:value_in_cents)
      expect(VerificadorBoletoBr::ArrecadationSlip.new(VALID_SLIP).value_in_cents).to equal(10978)
    end

    it "should return slip's formatted amount" do
      expect(VerificadorBoletoBr::ArrecadationSlip.new(VALID_SLIP)).to respond_to(:value)
      expect(VerificadorBoletoBr::ArrecadationSlip.new(VALID_SLIP).value).to equal(109.78)
    end

    it "should return slip's segment" do
      expect(VerificadorBoletoBr::ArrecadationSlip.new(VALID_SLIP)).to respond_to(:segment)
      expect(VerificadorBoletoBr::ArrecadationSlip.new(VALID_SLIP).segment).to eq("Órgãos Governamentais")
    end
  end
end
# VerificadorBoletoBr

Essa gem o ajudará a identificar boletos bancários nos seguinte items:
* Banco
* Valor
* Data de Vencimento

e, no caso de boleto de arrecadação:
* Segmento
* Concessionario (Emissor)
* Valor
* Validade (se disponível e "padrão" (🤣🤣🤣🤣) Febraban)

E ainda conferir a **validade** dos mesmos.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'verificador_boleto_br'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install verificador_boleto_br

## Usage

````ruby
require './lib/verificador_boleto_br'
>> slip = VerificadorBoletoBr.check('34191 75801 03928 662935 80573 180009 4 67700000007388')
=> #<VerificadorBoletoBr::BankSlip:0x00007ff4c3933478 @digitable_line="34191 75801 03928 662935 80573 180009 4 67700000007388">
````
It will return the respective slip class with its methods:

### BankSlip

````ruby
>> slip.valid?
=> true
>> slip.bank_code
=> 341
>> slip.currency_code 
=> 9
>> slip.value_in_cents
=> 7388
>> slip.value
=> 73.88
>> slip.due_date
=> #<Date: 2016-04-20 ((2457499j,0s,0n),+0s,2299161j)
````

### ArrecadationSlip (Concessionária)

````ruby
>> slip = VerificadorBoletoBr.check('858900000018 097802702000 323858108001 011520190292')
=> #<VerificadorBoletoBr::ArrecadationSlip:0x00007ff4c50c8d40 @digitable_line="858900000018 097802702000 323858108001 011520190292", @errors=[]>
>> slip.valid?
=> true
>> slip.value_in_cents
=> 10978
>> slip.value
=> 109.78
>> slip.due_date
=> nil # if unavailable
>> slip.segment
=> "Órgãos Governamentais"
>> slip.identification
=> "Guia GPS - INSS"
````

You can access the slip classes directly if you want.

## Special Feature
Some bank slips do not validate the global digit well (anybody, feel free to explain me if my theory is correct) for example credit card slips (eg: NuBank). It may be because credit card bills can be paid with any value and global verification ensures that the value is also correct. This method allows to validate bank slips without global digit validation:

````ruby
slip.valid_without_global?
````

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Hamdan85/VerificadorBoletoBr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/VerificadorBoletoBr/blob/master/CODE_OF_CONDUCT.md).

## SPECIAL THANKS

Encontrei a lista de identificadores de bolego no repositório do Rodrigo Stuchi (https://github.com/rod-stuchi)
Obrigado cara.. não sei a origem dos dados (porque não consegui com a Febraban) mas parabens ;)
require 'blockchain'

@wallet = Blockchain::Wallet.new(ENV['BLOCKCHAIN_IDENTIFIER'], ENV['BLOCKCHAIN_PASSWORD'])

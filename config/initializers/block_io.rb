require 'block_io'

BlockIo.set_options :api_key => ENV['BLOCKIO_API_KEY'], :pin => ENV['BLOCKIO_SECRET_PIN'], :version => 2

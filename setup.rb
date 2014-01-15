require 'etsy'
Etsy.api_key = 'tgfzd6jtx7rmap0001i0rlci'
Etsy.api_secret = 'udklpfsheo'
Etsy.environment = :production
Etsy.protocol = 'https'
request = Etsy.request_token
puts Etsy.verification_url
access = Etsy.access_token(request.token, request.secret, '2ca45714')
user = Etsy.myself(access.token, access.secret)
require 'gmail'

gmail = Gmail.new('lalalulu222333','12345678xx')

gmail.deliver do
  to "sasha@kontera.com"
  subject "Having fun in Puerto Rico!"
  text_part do
    body "Text of plaintext message."
  end
  html_part do
    body "<p>Text of <em>html</em> message.</p>"
  end
end
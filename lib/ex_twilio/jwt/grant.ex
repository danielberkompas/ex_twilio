defprotocol ExTwilio.JWT.Grant do
  def type(grant)
  def attrs(grant)
end

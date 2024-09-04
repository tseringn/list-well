class ClientService
  def create (create_params)
    @client = Client.new(create_params)
    if @client.save
      return @client
    end
    return nil
  end
end
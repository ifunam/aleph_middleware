MIDDLEWARE_DB.create_table? :clients do
  primary_key :id
  String  :name
  String  :description
  String  :ip_address
  String  :token
  String  :emails
  Boolean :enabled
end

MIDDLEWARE_DB.create_table? :transactions do
  primary_key :id
  Integer :client_id
  String  :content
  Boolean :status
end

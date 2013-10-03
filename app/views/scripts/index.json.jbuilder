json.array!(@scripts) do |script|
  json.extract! script, :name, :body, :created_by, :updated_by, :guid, :archived
  json.url script_url(script, format: :json)
end

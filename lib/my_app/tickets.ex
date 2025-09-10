defmodule MyApp.Tickets do
  use Ash.Domain,
    otp_app: :my_app,
    extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource MyApp.Tickets.Organization do
      define :create_organization, action: :create
      define :read_organizations, action: :read
    end

    resource MyApp.Tickets.Representative do
      define :create_representative, action: :create
      define :read_representatives, action: :read
    end
  end
end

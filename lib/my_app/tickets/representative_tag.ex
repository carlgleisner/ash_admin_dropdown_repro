defmodule MyApp.Tickets.RepresentativeTag do
  use Ash.Resource,
    domain: MyApp.Tickets,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshAdmin.Resource
    ]

  admin do
    label_field :name
    relationship_select_max_items 2
  end

  postgres do
    table "representative_tags"
    repo MyApp.Repo
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  relationships do
    relationships do
      belongs_to :tag, MyApp.Tickets.Tag do
        primary_key? true
        allow_nil? false
        public? true
      end

      belongs_to :representative, MyApp.Tickets.Representative do
        primary_key? true
        allow_nil? false
        public? true
      end
    end
  end
end

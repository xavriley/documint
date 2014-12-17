class AddSearchIndexToDocuments < ActiveRecord::Migration
  def change
    execute "
        create index on documents using gin(to_tsvector('english', source_url));
        create index on documents using gin(to_tsvector('english', content));
        create index on documents using gin(to_tsvector('english', metadata));"
  end
end

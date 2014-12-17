class Document < ActiveRecord::Base
  attr_accessor :entities, :persons

  def self.get(source_url)
    if document = Document.find_by(source_url: source_url)
      #Quick check to see if we've got this before
      document
    else
      #TODO:  secure this
      content, metadata = Rika.parse_content_and_metadata(source_url)
      Document.create(source_url: source_url, 
                      content: content, 
                      metadata: metadata)
    end
  end
end

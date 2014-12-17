require 'jruby-ner'
class NerWorker
  include Sidekiq::Worker

  def perform(source_url)
    d = Document.find_by(source_url: source_url)
    r = Ner::Recognizer.new

    results = r.extract_3class(document.content)
    # normalize spaces and dedup
    results.each {|k,v| results[k] = v.map {|x| x.gsub(/\s+/, ' ') }.uniq {|x| x.downcase }.sort! }

    document.named_entities = results.to_json
    document.save
  end
end

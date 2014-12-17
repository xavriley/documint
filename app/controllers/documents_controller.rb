require 'rika'
require 'jruby-ner'

class DocumentsController < ApplicationController
  def find_or_enqueue
    url = CGI.unescape(params[:url])

    #small hack to deal with Rails stripping some params
    url = url.gsub('http://', 'http:/')
    url = url.gsub('http:/', 'http://')
    url.strip!
    url = URI.encode(url)

    @document = Document.find_by(source_url: url)

    if @document.nil?
      Document.delay(retry: 3).get(url)
    else
      r = Ner::Recognizer.new
      ents = r.extract_3class(@document.content)
      @document.entities = ents[:organizations].map {|x| 
        x.gsub(/\s+/, ' ').split(' ').map(&:strip).delete_if(&:blank?).join(" ")
      }.uniq

      @document.persons = ents[:persons].map {|x| 
        x.gsub(/\s+/, ' ').split(' ').map(&:strip).delete_if(&:blank?).join(" ")
      }.uniq
    end
    
    render 'documents/show'
  end

  def search
    @documents = Document.search(params[:query]).limit(20)
  end
end

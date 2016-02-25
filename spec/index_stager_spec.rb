require 'spec_helper'
require 'pp'

describe Elasticsearch::IndexStager do

  after(:each) do
    ESHelper.client.indices.delete index: "articles_staged" rescue false
  end

  it "generates index names" do
    stager = Elasticsearch::IndexStager.new(index_name: 'articles', es_client: ESHelper.client)
    expect(stager.stage_index_name).to eq "articles_staged"
    expect(stager.tmp_index_name).to match(/^articles_\d{14}-\w{8}$/)
  end

  it "stages an index" do
    stager = stage_index
    aliases = ESHelper.client.indices.get_aliases(index: stager.stage_index_name)
    expect(aliases.keys.size).to eq 1
    expect(aliases.keys[0]).to eq stager.tmp_index_name
  end

  it "promotes a staged index to live" do
    stager = stage_index
    stager.promote
    ESHelper.client.refresh_index!

    response = ESHelper.client.search(index: 'articles', body: { query: { title: 'test' } } )
    expect(response.results.size).to eq 2

    aliases = ESHelper.client.indices.get_aliases(index: stager.index_name) 
    expect(aliases.keys[0]).to eq stager.tmp_index_name
  end

  it "handles first-time migration to staged paradigm" do
    create_index('articles')
    stager = stage_index
    stager.promote
    ESHelper.client.refresh_index!

    aliases = ESHelper.client.indices.get_aliases(index: stager.index_name)
    expect(aliases.keys[0]).to eq stager.tmp_index_name
  end

  def create_index(index_name)
    ESHelper.client.index(index: index_name, type: 'article', id: 1, body: { title: 'Test' })
    ESHelper.client.index(index: index_name, type: 'article', id: 2, body: { title: 'Test' })
  end

  def stage_index
    stager = Elasticsearch::IndexStager.new(index_name: 'articles', es_client: ESHelper.client)
    create_index(stager.tmp_index_name)
    stager.alias_stage_to_tmp_index
    stager
  end
end

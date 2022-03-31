shared_examples_for 'API nestable' do
  describe 'author' do
    it 'contains author object' do
      
      expect(resource_response['user_id']).to eq resource.user_id
    end
  end

  describe 'files' do
    it 'returns list of files' do
      expect(resource_response['files'].size).to eq files.size unless skipped_params&.include? 'files'
    end
  end

  describe 'comments' do
    it 'returns list of comments' do
      expect(resource_response['comments'].size).to eq comments.size unless skipped_params&.include? 'comments'
    end

    it 'returns all public fields' do
      comments_public_fields.each do |attr|
        expect(resource_response['comments'].first[attr]).to eq resource.comments.first.send(attr).as_json
      end unless skipped_params&.include? 'comments'
    end
  end

  describe 'links' do
    it 'returns list of comments' do
      expect(resource_response['links'].size).to eq links.size
    end

    it 'returns all public fields' do
      links_public_fields.each do |attr|
        expect(resource_response['links'].first[attr]).to eq resource.links.first.send(attr).as_json
      end
    end
  end
end

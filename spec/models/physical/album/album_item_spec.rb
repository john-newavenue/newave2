require 'spec_helper'

describe "Album Item Model", :slow => true do

  let(:album_item) { FactoryGirl.create(:album_item_with_image_attachment )}
  let(:album_item_no_file) { FactoryGirl.create(:album_item)}
  let(:album_item_with_text_file) { FactoryGirl.create(:album_item_with_text_attachment )}

  it "should respond to properties" do
    %w(album title description deleted_at position parent root attachment comment credit_name credit_url).each do |att| 
      expect(album_item).to respond_to(att.to_sym)
    end
  end

  pending "should validate credit_name/credit_URL"

  it "should be soft deleted" do
    album_item.destroy
    expect(Physical::Album::AlbumItem.with_deleted.find_by_id(album_item.id)).to_not be_nil
    expect(Physical::Album::AlbumItem.find_by_id(album_item.id)).to be_nil
  end

  it "should be taggable" do
    expect(album_item).to respond_to(:tag_list)
    album_item.tag_list.add(%w(red yellow green))
    expect(album_item.tag_list).to include("red")
  end

  it "should have an attachment" do
    expect(album_item.attachment_file_name).to_not be_nil
    expect(/^image\/(png|gif|jpeg|jpg|bmp)/.match album_item.attachment_content_type).to_not be_nil
    expect(album_item.attachment_file_size).to_not be_nil
    expect(album_item.attachment_type).to_not be_nil
  end

  it "should create thumbnails for images" do
    expect(album_item.attachment(:original)).to_not be_nil
    expect(album_item.attachment(:small_square)).to_not be_nil
    expect(album_item.attachment(:medium_square)).to_not be_nil
    expect(album_item.attachment(:large)).to_not be_nil
  end

  it "should not create thumbnails for other attachments" do
    expect(album_item_with_text_file.send(:skip_for_nonimage)).to_not be_true
  end

  it "should determine the type of attachment it has" do
    expect(album_item.attachment_type).to eql("image")
    expect(album_item_with_text_file.attachment_type).to eql("text")
  end

  it "should yield position info if it's an image" do
    album = FactoryGirl.create(:album)
    img1 = FactoryGirl.create(:album_item_with_image_attachment, :album => album)
    img2 = FactoryGirl.create(:album_item_with_image_attachment, :album => album)
    img3 = FactoryGirl.create(:album_item_with_image_attachment, :album => album)
    img4 = FactoryGirl.create(:album_item_with_image_attachment, :album => album)
    expect(img2.get_image_position_info).to_not be_nil
  end

  it "should see neighboring images if it's an image" do
    album = FactoryGirl.create(:album)
    img1 = FactoryGirl.create(:album_item_with_image_attachment, :album => album)
    img2 = FactoryGirl.create(:album_item_with_image_attachment, :album => album)
    img3 = FactoryGirl.create(:album_item_with_image_attachment, :album => album)
    img4 = FactoryGirl.create(:album_item_with_image_attachment, :album => album)
    
    a1 = img1.get_neighboring_images(2).map(&:id)
    a2 = img1.get_neighboring_images(3).map(&:id)
    b1 = img3.get_neighboring_images(2).map(&:id)
    b2 = img3.get_neighboring_images(3).map(&:id)

    # images are retrieved by position ASC (default = 9999), id DESC,
    # so they are retrieved as [img4, img3, img2, img1]

    expect(a1).to eql([img3, img2, img1].map(&:id))
    expect(a2).to eql([img4, img3, img2, img1].map(&:id))
    expect(b1).to eql([img4, img3, img2].map(&:id))
    expect(b2).to eql([img4, img3, img2, img1].map(&:id))
    # puts "hi"
  end

  it "should create project timeline activity for uploading an image" do
    project = FactoryGirl.create(:project)
    album_item = FactoryGirl.create(:album_item_with_image_attachment, :album => project.primary_album)
    expect(project.items.map(&:id)).to include(album_item.id)
  end

  it "should note its ancestry and copy ancestral attachment" do
    album1 = FactoryGirl.create(:album)
    album2 = FactoryGirl.create(:album)
    album3 = FactoryGirl.create(:album)
    img1 = FactoryGirl.create(:album_item_with_image_attachment, :album => album1)
    img2 = FactoryGirl.create(:album_item, :album => album2, :parent => img1 )
    img3 = FactoryGirl.create(:album_item, :album => album3, :parent => img2 )
    expect(img1.root).to be_nil
    expect(img1.parent).to be_nil
    expect(img2.root).to eql(img1)
    expect(img2.root).to eql(img2.parent)
    expect(img3.root).to eql(img1)
    expect(img3.parent).to eql(img2)
    expect(img2.attachment_file_name).to eql(img1.attachment_file_name)
    expect(img3.attachment_file_name).to eql(img1.attachment_file_name)
  end

  it "should allow an optional valid category to be assigned" do
    album_item_no_file.category = FactoryGirl.create(:album_item_category)
    expect(album_item_no_file.valid?).to be_true
    album_item_no_file.category_id = -1
    # the assigned category_id is invalid, so this just evaluates to nil, which is allowed
    expect(album_item_no_file.valid?).to be_true 
  end


end
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def extension_white_list
    %w(jpg)
  end

  def store_dir
    "uploads/"
  end
end

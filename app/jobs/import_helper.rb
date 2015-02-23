module ImportHelper
  def self.store_s3_file!(filename)
    AWS::S3::S3Object.store(filename, open(full_path(filename)), Constants::S3_BUCKET)
  end

  def self.s3_file_value(filename)
    AWS::S3::S3Object.value(filename, Constants::S3_BUCKET)
  end

  def self.delete_tmp_file!(filename)
    File.delete(full_path(filename))
  end

  def self.delete_s3_file!(filename)
    AWS::S3::S3Object.delete(filename, Constants::S3_BUCKET)
  end

  def self.full_path(filename)
    "#{Constants::TEMP_PATH}#{filename}"
  end
end
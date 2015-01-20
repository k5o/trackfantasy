class EntryWipeJob < ActiveJob::Base

  def perform args
    ActiveRecord::Base.connection_pool.with_connection do
      user = User.find_by_id(args[:user_id])

      user.entries.destroy_all
    end
  end

end

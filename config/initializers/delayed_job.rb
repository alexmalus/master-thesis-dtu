# snippet from https://medium.com/@darrenrush/save-414-on-your-heroku-bill-this-year-5680251ab972#.gx3ggczcm
# hopefully allows delayed job to work in single web dyno FREEE
if !Rails.const_defined?('Console') && !($0 =~ /rake$/) && !Rails.env.test?
  Rails.application.config.after_initialize do

    # (1..2).each do |thread_id| 
      Thread.new { 
        Thread.current[:thread_name] = "DJ Web Worker Thread 1"
        ActiveRecord::Base.connection_pool.with_connection do |conn|
          dj = Delayed::Worker.new
          Rails.logger.warn "Starting #{Thread.current[:thread_name]}"
          at_exit         { Rails.logger.warn "Stopping background thread"; dj.stop }
          dj.start
        end
      }
    # end
  end
end
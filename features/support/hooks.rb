
require('httparty')


def post_to_top(type, duration)
  timeNow = Time.now
  timeUTC = timeNow.utc.iso8601
  timeLong = timeNow.to_i
  Kernel.puts "TIME #{timeNow} #{timeUTC} #{timeLong}"
  url = "#{ENV["LOGSTASH_URL"]}"
  Kernel.puts "URL: #{url}"
  Kernel.puts ENV.to_a
  dataset = "#{ENV["BUILD_TEAM_NAME"]}.#{ENV["BUILD_PIPELINE_NAME"]}.#{ENV["BUILD_ID"]}.#{ENV["BUILD_JOB_NAME"]}"
  doc = {
    # "@timestamp": timeUTC,
    service: {
      name: "Cucumber",
      version: "1.0.0"
    },
    duration: duration,
    event: {
      type: type,
      kind: "state",
      action: "Build Status",
      module: "concourse.features",
      code: 2672295,
      dataset: dataset
    },
    ci: {
      ref: ENV["BUILD_REF"],
      start_time: timeUTC,
      end_time: timeUTC,
      job_name: ENV["BUILD_JOB_NAME"]
    }
  }

  options = { :body => doc.to_json, :headers => { 'Content-Type': 'application/json' } }
  HTTParty.post(url, options)
  # client = Elasticsearch::Client.new url:server_url, log: true
  # client.index  index: 'scs-data-concourse', type: '_doc', body: doc
end

Before do
  post_to_top('start', 0)
end

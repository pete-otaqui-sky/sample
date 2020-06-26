
require('elasticsearch')


def post_to_top(type, duration)
  timeNow = Time.now
  timeUTC = timeNow.utc.iso8601
  timeLong = timeNow.to_i
  puts "TIME #{timeNow} #{timeUTC} #{timeLong}"
  server_url = "http://localhost:9200/scs-data-concourse/cucumber"
  doc = {
    "@timestamp": timeUTC,
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
      dataset: "nowtv-europe.nowtv-europe-master.89399646.master-nowtv-web-release-functional"
    },
    ci: {
      ref: BUILD_REF,
      start_time: timeUTC,
      end_time: timeUTC,
      job_name: BRANCH
    }
  }
  puts doc
  client = Elasticsearch::Client.new log: true
  client.index  index: 'scs-data-concourse', type: '_doc', body: doc
end

Before do
  post_to_top('start', 0)
end
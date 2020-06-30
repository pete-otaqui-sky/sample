const fetch = require("node-fetch");
const elasticsearch = require("elasticsearch");
const env = require("../env.json");

const client = new elasticsearch.Client({
  hosts: ["http://localhost:9200"],
});

async function fetchConcourse(url = "") {
  // url = "http://localhost:8080/api/v1/teams/main/pipelines/dawt/resources/src/versions"
  const response = await fetch(`${env.concourse.versionsUrl}${url}`, {
    headers: {
      accept: "*/*",
      "accept-language": "en-GB,en;q=0.9,en-US;q=0.8",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin",
      cookie: env.concourse.cookie,
    },
    referrer: "http://localhost:8080",
    referrerPolicy: "no-referrer-when-downgrade",
    body: null,
    method: "GET",
    mode: "cors",
  });
  const result = await response.json();
  return result;
}

function writeElastic(body) {
  return client.index({
    index: "scs-data-concourse",
    type: "_doc",
    body,
  });
}

async function main() {
  const versions = await fetchConcourse();
  console.log("Got", versions.length, "versions");
  for (let i = 0, imax = versions.length; i < imax; i += 1) {
    const versionId = versions[i].id;
    const commitRef = versions[i].version.ref.substr(0, 7);
    const inputTo = await fetchConcourse(`/${versionId}/input_to`);
    console.log(
      "...",
      "Current version was an input to",
      inputTo.length,
      "builds"
    );
    for (let j = 0, jmax = inputTo.length; j < jmax; j += 1) {
      const build = inputTo[j];
      const duration = build.end_time - build.start_time;
      const job_name = build.job_name;
      const start_time = new Date(build.start_time * 1000);
      const end_time = new Date(build.end_time * 1000);
      const scsDoc = {
        "@timestamp": start_time,
        service: {
          name: "Concourse",
          version: "5.6.0",
        },
        duration,
        event: {
          type: "end",
          kind: "state",
          action: "Build Status",
          module: "concourse.jobs",
          code: versionId,
          dataset: `main.dawt.${versionId}.${job_name}`,
        },
        ci: {
          ref: commitRef,
          start_time: start_time,
          end_time: end_time,
          job_name: job_name,
        },
      };
      const result = await writeElastic(scsDoc);
      console.log("...", "...", "Wrote to elastic", result);
    }
  }
}
main();

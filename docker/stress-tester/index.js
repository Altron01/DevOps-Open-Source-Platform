const axios = require('axios')
const BE_ENDPOINT = require('./config').BE_ENDPOINT
const NUM_TESTS = require('./config').NUM_TESTS

for (let i = 0; i < NUM_TESTS; i++) {
    axios.get(BE_ENDPOINT).then(res => {
        console.log(`${res} was returned`)
    })
    console.log("CALLED SENT")
}
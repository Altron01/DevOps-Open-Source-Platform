require('dotenv').config()

const BE_ENDPOINT = parseInt(process.env.BE_ENDPOINT)
const NUM_TESTS = parseInt(process.env.NUM_TESTS)

module.exports = { BE_ENDPOINT, NUM_TESTS }
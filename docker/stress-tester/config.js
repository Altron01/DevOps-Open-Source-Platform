require('dotenv').config()

const BE_ENDPOINT = process.env.BE_ENDPOINT
const NUM_TESTS = process.env.NUM_TESTS

module.exports = { BE_ENDPOINT, NUM_TESTS }
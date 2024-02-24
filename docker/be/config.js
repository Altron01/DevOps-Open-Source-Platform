require('dotenv').config()

const PORT = process.env.PORT
const MIN = process.env.MIN
const MAX = process.env.MAX

module.exports = { PORT, MIN, MAX }
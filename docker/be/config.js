require('dotenv').config()

const PORT = parseInt(process.env.PORT)
const MIN = parseInt(process.env.MIN)
const MAX = parseInt(process.env.MAX)

module.exports = { PORT, MIN, MAX }
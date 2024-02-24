const express = require('express')
const app = express()

const PORT = require('./config').PORT
const MIN = require('./config').MIN
const MAX = require('./config').MAX

function fibonacci(num) {
    if (num <= 1) return num;
    return fibonacci(num - 1) + fibonacci(num - 2);
}

app.get('/', (req, res) => {
  const n = Math.floor(Math.random() * (MAX - MIN)) + parseInt(MIN);

  console.log('Calculating fibonacci for', n);
  const result = fibonacci(n);
  res.status(200).send(`Result: ${result}`)
})

app.listen(PORT, () => {
  console.log(`Example app listening on port ${PORT}`)
})
const Pool = require('pg').Pool
const pool = new Pool({
  user: process.env.MESSAGE_STORE_USER,
  host: process.env.MESSAGE_STORE_HOST,
  database: process.env.MESSAGE_STORE_DATABASE,
  password: process.env.MESSAGE_STORE_PASSWORD,
  port: process.env.MESSAGE_STORE_PORT,
})

const getMessages = (request, response) => {
    try {
        pool.query('SELECT * FROM public.messages ORDER BY id ASC', (error, results) => {
            if (typeof results == 'undefined') {
                response.status(200).json({ info: 'No Data' })
            }
            else {
                response.status(200).json(results.rows)
            }
        })
    } catch (e) {}
}

const getMessageById = (request, response) => {
    try {
        const id = request.params.id

        pool.query('SELECT * FROM public.messages WHERE id = $1', [id], (error, results) => {
            if (typeof results == 'undefined') {
                response.status(200).json({ info: 'No Data' })
            }
            else {
                response.status(200).json(results.rows)
            }
        })
    } catch (e) {}
}

const writeMessage = (request, response) => {
    try {
        const { id, type, stream_name, metadata, data } = request.body
        // console.log(request.body)
        pool.query('select write_message(_id := $1, _stream_name := $2, _type := $3, _data := $4, _metadata := $5);', [id, stream_name, type, data, metadata], (error, results) => {
            if (error) {
                console.log(error)
                response.status(400)
            }
            else if (typeof results == 'undefined') {
                response.status(200).json({ info: 'No Data' })
            }
            else {
                response.status(200).json(results)
            }
        })
    } catch (e) {}
}

module.exports = {
  getMessages,
  getMessageById,
  writeMessage
}
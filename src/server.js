import express from 'express';

const serverPort = 3031;
const readyPath = "/ready"

const app = express();

app.get(readyPath, (req, res) => {
    const respondeReady = "SERVER READY AT: " + new Date();
	res.send(respondeReady);
});


app.listen(serverPort, () => {
    console.log(`App listening on ${serverPort}`);
});
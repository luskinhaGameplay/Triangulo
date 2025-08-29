import express from 'express';

const serverPort = 3031;
const healthCheckPath = "/ready"

const app = express();

app.get(healthCheckPath, (req, res) => {
    const respondeReady = "SERVER READY AT: " + new Date();
	res.send(respondeReady);
});


app.listen(serverPort, () => {
    console.log(`App listening on ${serverPort}`);
});
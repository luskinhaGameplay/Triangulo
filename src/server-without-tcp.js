import express from 'express';

const serverPort = 3031;
const readyPath = "/ready"

const app = express();

app.get(readyPath, (req, res) => {
    res.send(
        {
            message:"SERVER READY",
            timeStamp: new Date()
        }       
    );
});

export default app;
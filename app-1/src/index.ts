import express from "express";

const app = express();

app.use((req: express.Request, res: express.Response) => {
	res.send("Hello World, says app-1!");
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
	console.log(`Listening on http://0.0.0.0:${port}`);
});
